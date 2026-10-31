"""Subprocess-only boundary to the frozen validator CLI, plus a test double."""

from __future__ import annotations

import os
import signal
import json
import re
import subprocess
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Protocol

from .storage import atomic_write_json
from .task import TaskSpec


class EdaAdapterError(RuntimeError):
    """The validator contract could not be invoked or verified."""


_UNCONFIRMED_PROCESSES = []


class OwnedProcessTimeout(EdaAdapterError):
    def __init__(self,pid,cleaned,seconds,cleanup_detail=None):
        super().__init__(f"owned process {pid} exceeded {seconds}s; local tree cleanup confirmed={cleaned}")
        self.pid,self.cleaned,self.seconds=pid,cleaned,seconds
        self.cleanup_detail=cleanup_detail


def _windows_process_snapshot():
    """Read-only PID/parent snapshot; do not infer completion from localized tool text."""
    import ctypes
    from ctypes import wintypes
    class Entry(ctypes.Structure):
        _fields_=[('size',wintypes.DWORD),('usage',wintypes.DWORD),('pid',wintypes.DWORD),
                  ('heap',ctypes.c_size_t),('module',wintypes.DWORD),('threads',wintypes.DWORD),
                  ('parent',wintypes.DWORD),('priority',wintypes.LONG),('flags',wintypes.DWORD),('exe',wintypes.WCHAR*260)]
    kernel=ctypes.WinDLL('kernel32',use_last_error=True)
    kernel.CreateToolhelp32Snapshot.argtypes=[wintypes.DWORD,wintypes.DWORD]
    kernel.CreateToolhelp32Snapshot.restype=wintypes.HANDLE
    kernel.Process32FirstW.argtypes=[wintypes.HANDLE,ctypes.POINTER(Entry)]
    kernel.Process32NextW.argtypes=[wintypes.HANDLE,ctypes.POINTER(Entry)]
    kernel.CloseHandle.argtypes=[wintypes.HANDLE]
    handle=kernel.CreateToolhelp32Snapshot(2,0)
    if handle==ctypes.c_void_p(-1).value: raise ctypes.WinError(ctypes.get_last_error())
    try:
        entry=Entry();entry.size=ctypes.sizeof(entry);result={}
        ok=kernel.Process32FirstW(handle,ctypes.byref(entry))
        while ok:
            result[int(entry.pid)]=int(entry.parent)
            ok=kernel.Process32NextW(handle,ctypes.byref(entry))
        error=ctypes.get_last_error()
        if error!=18: raise ctypes.WinError(error)  # ERROR_NO_MORE_FILES only
        return result
    finally: kernel.CloseHandle(handle)


def _expand_owned_pids(snapshot,owned):
    while True:
        expanded=owned | {pid for pid,parent in snapshot.items() if parent in owned}
        if expanded==owned: return expanded
        owned=expanded


def _stop_owned_tree(process,grace):
    """Only our owned local worker tree. Never contact or kill the GPU server."""
    try:
        if os.name=='nt':
            owned=_expand_owned_pids(_windows_process_snapshot(),{process.pid})
            stopped=subprocess.run(['taskkill','/PID',str(process.pid),'/T','/F'],capture_output=True,
                                   timeout=grace,creationflags=subprocess.CREATE_NO_WINDOW)
            # A console helper may exit while taskkill is enumerating it. Its exit
            # code alone is neither proof of cleanup nor proof of a live child.
            stderr=stopped.stderr.decode('oem',errors='replace')
            owned |= {int(pid) for pid in re.findall(r'(?m)^.*?\bPID\s+(\d+)',stderr)}
            deadline=time.monotonic()+grace
            while True:
                snapshot=_windows_process_snapshot()
                owned=_expand_owned_pids(snapshot,owned)
                alive=owned & set(snapshot)
                if not alive: break
                if time.monotonic()>=deadline:
                    process._cleanup_detail={"exit_code":stopped.returncode,"alive_owned_pids":sorted(alive)}
                    return False
                time.sleep(min(0.05,max(0,deadline-time.monotonic())))
            process._cleanup_detail={"exit_code":stopped.returncode,"owned_pids_confirmed_exited":sorted(owned)}
            confirmed=True
        else:
            os.killpg(process.pid,signal.SIGKILL);confirmed=True
        process.wait(timeout=grace)
        return confirmed
    except (OSError,subprocess.SubprocessError) as exc:
        process._cleanup_detail={"error":str(exc)}
        return False


def run_owned_process(command,*,cwd,timeout,grace):
    options={'creationflags':subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.CREATE_NO_WINDOW} if os.name=='nt' else {'start_new_session':True}
    process=subprocess.Popen(command,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                             text=True,encoding='utf-8',errors='replace',**options)
    try:
        out,err=process.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        cleaned=_stop_owned_tree(process,grace)
        # Descendants may still hold inherited pipe handles if cleanup failed.
        if cleaned:
            try: process.communicate(timeout=grace)
            except subprocess.TimeoutExpired:
                cleaned=False
                process._cleanup_detail={"error":"owned pipe handles did not close after process tree termination"}
        if not cleaned:
            if process.poll() is None:
                try:
                    process.kill();process.wait(timeout=grace)
                except (OSError,subprocess.TimeoutExpired): pass
            # Windows communicate uses daemon pipe readers. Closing a pipe held by
            # an unresolved descendant can itself block; retain ownership until exit.
            _UNCONFIRMED_PROCESSES.append(process)
        raise OwnedProcessTimeout(process.pid,cleaned,timeout,getattr(process,"_cleanup_detail",None))
    return subprocess.CompletedProcess(command,process.returncode,out,err)


@dataclass(frozen=True)
class ValidationRecord:
    result: dict[str, Any]
    exit_code: int
    output_dir: Path


class EdaAdapter(Protocol):
    def validate(self, task: TaskSpec, source_path: Path, output_dir: Path) -> ValidationRecord:
        """Validate one immutable candidate."""


def is_environment_failure(result: dict[str, Any]) -> bool:
    if result.get("stage") == "environment":
        return True
    if result.get("error_type") in {"tool_not_found", "unsupported_part", "license_error"}:
        return True
    return (
        result.get("stage") == "simulation"
        and result.get("error_type") == "unknown_error"
        and "no candidate RTL evidence" in str(result.get("summary", ""))
    )


_CRITICAL_RESULT_FIELDS = (
    "schema_version",
    "passed",
    "stage",
    "error_type",
    "summary",
    "source",
    "testbench",
    "top_module",
    "part",
    "clock_period_ns",
    "vivado_version",
    "output_dir",
)


class CliEdaAdapter:
    """Invoke ``tools/validate_rtl.py`` without interpreting Vivado logs."""

    def __init__(self, config: dict[str, Any]):
        self.validator_root = Path(config["validator_root"]).resolve()
        entry = Path(config["validator_entry"])
        self.validator_entry = entry if entry.is_absolute() else self.validator_root / entry
        self.python_executable = str(config["python_executable"])
        self.part = str(config["target_part"])
        self.clock_period_ns = float(config["clock_period_ns"])
        self.timeouts = dict(config["timeouts"])

    def validate(self, task: TaskSpec, source_path: Path, output_dir: Path) -> ValidationRecord:
        if not self.validator_entry.is_file():
            raise EdaAdapterError(f"validator entry not found: {self.validator_entry}")
        if not task.testbench_path.is_file():
            raise EdaAdapterError(f"validator testbench not found: {task.testbench_path}")
        if task.constraints_path is not None and not task.constraints_path.is_file():
            raise EdaAdapterError(f"validator constraints not found: {task.constraints_path}")
        command = [
            self.python_executable,
            str(self.validator_entry),
            "--source",
            str(source_path.resolve()),
            "--testbench",
            str(task.testbench_path),
            "--top",
            task.top_module,
            "--part",
            self.part,
            "--clock-period",
            str(self.clock_period_ns),
            "--output-dir",
            str(output_dir.resolve()),
        ]
        if task.constraints_path is not None:
            command.extend(["--constraints", str(task.constraints_path)])
        for stage in ("compile", "elaborate", "simulation", "synthesis"):
            command.extend([f"--{stage}-timeout", str(self.timeouts[f"{stage}_seconds"])])
        outer_timeout = sum(float(value) for value in self.timeouts.values()) + 120.0
        started = time.monotonic()
        try:
            completed = run_owned_process(command,cwd=self.validator_root,timeout=outer_timeout,grace=10.0)
        except OwnedProcessTimeout:
            # Preserve cleanup certainty for Controller/worker barriers.
            raise
        except OSError as exc:
            raise EdaAdapterError(f"validator process could not start: {exc}") from exc
        elapsed = round(time.monotonic() - started, 6)
        stdout = completed.stdout.strip()
        if not stdout:
            raise EdaAdapterError(
                f"validator returned exit {completed.returncode} without stdout JSON; stderr={completed.stderr[:1000]!r}"
            )
        try:
            stdout_result = json.loads(stdout)
        except json.JSONDecodeError as exc:
            raise EdaAdapterError(
                f"validator stdout is not one JSON object: {stdout[:1000]!r}"
            ) from exc
        if not isinstance(stdout_result, dict):
            raise EdaAdapterError("validator stdout JSON root must be an object")
        actual_output = Path(stdout_result.get("output_dir", output_dir)).resolve()
        disk_path = actual_output / "result.json"
        if not disk_path.is_file():
            raise EdaAdapterError(f"validator result.json not found: {disk_path}")
        try:
            disk_result = json.loads(disk_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            raise EdaAdapterError(f"validator result.json is invalid: {disk_path}") from exc
        mismatches = [
            key
            for key in _CRITICAL_RESULT_FIELDS
            if stdout_result.get(key) != disk_result.get(key)
        ]
        if mismatches:
            raise EdaAdapterError(
                f"validator stdout/result.json mismatch in fields: {mismatches}"
            )
        environment_failure = is_environment_failure(disk_result)
        expected_exit = 0 if disk_result.get("passed") else 2 if environment_failure else 1
        if completed.returncode not in {0, 1, 2}:
            raise EdaAdapterError(f"validator returned unsupported exit code {completed.returncode}")
        if completed.returncode != expected_exit:
            raise EdaAdapterError(
                f"validator exit code {completed.returncode} conflicts with result; expected {expected_exit}"
            )
        atomic_write_json(
            actual_output / "adapter_invocation.json",
            {
                "argv": command,
                "cwd": str(self.validator_root),
                "exit_code": completed.returncode,
                "elapsed_seconds": elapsed,
                "stderr": completed.stderr,
            },
        )
        return ValidationRecord(disk_result, completed.returncode, actual_output)


class GiteeEdaAdapter:
    """Invoke the official Gitee task harness through the EDA adapter contract.

    Gitee's public benches instantiate ``RefModule`` and use a ``tb`` top, so
    they cannot be sent through ``tools/validate_rtl.py`` (which requires a
    ``tb_<top>`` bench).  The integration runner preserves the same structured
    result schema and writes the complete Vivado evidence directory.  Keeping
    this bridge here lets the candidate-search runner use the normal validation loop
    without changing the frozen validator or the old task path.
    """

    def __init__(self, config: dict[str, Any]):
        self.config = dict(config)
        self.timeouts = dict(config["timeouts"])
        self.vivado_bin = config.get("vivado_bin")

    def validate(self, task: TaskSpec, source_path: Path, output_dir: Path) -> ValidationRecord:
        # Import lazily so ordinary CLI/mock runs do not import the optional
        # Gitee integration module or alter their startup path.
        from integrations.gitee_tasks.run_gitee_validation import run_one, tool_bin

        limits = {
            "compile_seconds": float(self.timeouts["compile_seconds"]),
            "elaborate_seconds": float(self.timeouts["elaborate_seconds"]),
            "simulation_seconds": float(self.timeouts["simulation_seconds"]),
            "synthesis_seconds": float(self.timeouts["synthesis_seconds"]),
        }
        result = run_one(
            task.root,
            source_path.resolve(),
            output_dir.resolve(),
            tool_bin(self.vivado_bin),
            limits,
        )
        result = dict(result)
        # The full harness warnings remain in the local EDA result file; they
        # are not candidate repair context, even for public example benches.
        result["warnings"] = []
        if re.search(r"\b(?:tb|testbench|ref|reference)\.(?:sv|v)\b", str(result.get("summary", "")), re.I):
            result.update(
                stage="environment",
                error_type="unknown_error",
                summary="validation harness diagnostic withheld; inspect local EDA logs",
                passed=False,
            )
        actual_output = Path(result["output_dir"]).resolve()
        # Match CliEdaAdapter's exit-code contract consumed by the scheduler.
        environment_failure = (
            result.get("stage") == "environment"
            or result.get("error_type") in {"tool_not_found", "unsupported_part", "license_error"}
        )
        exit_code = 0 if result.get("passed") else 2 if environment_failure else 1
        return ValidationRecord(result, exit_code, actual_output)


_SCENARIOS: dict[str, tuple[str, str, str, bool, int]] = {
    "pass": ("complete", "none", "mock validation passed", True, 0),
    "syntax": ("compile", "syntax_error", "mock syntax error at candidate line 3", False, 1),
    "functional": ("simulation", "functional_mismatch", "mock output mismatch at cycle 4", False, 1),
    "synthesis": ("synthesis", "synthesis_error", "mock synthesis failed", False, 1),
    "timeout": ("simulation", "simulation_timeout", "mock simulation timeout", False, 1),
    "environment": ("environment", "tool_not_found", "mock Vivado environment unavailable", False, 2),
}


class MockEdaAdapter:
    """Simulate validator outcomes while writing complete result.json evidence."""

    def __init__(self, scenarios: list[Any] | tuple[Any, ...], vivado_version: str = "mock-2026.1"):
        self._scenarios = list(scenarios)
        self.vivado_version = vivado_version
        self.calls: list[dict[str, Any]] = []

    def validate(self, task: TaskSpec, source_path: Path, output_dir: Path) -> ValidationRecord:
        if not self._scenarios:
            raise EdaAdapterError("mock EDA scenario sequence exhausted")
        scenario = self._scenarios.pop(0)
        output_dir = output_dir.resolve()
        output_dir.mkdir(parents=True, exist_ok=False)
        if isinstance(scenario, str):
            scenario = {"kind": scenario}
        if not isinstance(scenario, dict):
            raise EdaAdapterError(f"invalid mock EDA scenario: {scenario!r}")
        kind = scenario.get("kind", "pass")
        if kind not in _SCENARIOS:
            raise EdaAdapterError(f"unknown mock EDA scenario kind: {kind}")
        stage, error_type, summary, passed, exit_code = _SCENARIOS[kind]
        stage = str(scenario.get("stage", stage))
        error_type = str(scenario.get("error_type", error_type))
        summary = str(scenario.get("summary", summary))
        passed = bool(scenario.get("passed", passed))
        exit_code = int(scenario.get("exit_code", exit_code))
        result = {
            "schema_version": "1.0",
            "passed": passed,
            "stage": stage,
            "error_type": error_type,
            "summary": summary,
            "source": str(source_path.resolve()),
            "testbench": str(task.testbench_path),
            "top_module": task.top_module,
            "part": task.metadata["part"],
            "clock_period_ns": float(task.metadata["clock_period_ns"]),
            "vivado_version": self.vivado_version,
            "timings": {
                "compile_seconds": 0.0,
                "elaborate_seconds": 0.0,
                "simulation_seconds": 0.0,
                "synthesis_seconds": 0.0,
                "total_seconds": float(scenario.get("elapsed_seconds", 0.001)),
            },
            "commands": [],
            "log_files": [str(output_dir / "mock.log")],
            "artifacts": [],
            "warnings": list(scenario.get("warnings", [])),
            "output_dir": str(output_dir),
        }
        (output_dir / "mock.log").write_text(
            str(scenario.get("raw_log", "mock validator log; not used for feedback")),
            encoding="utf-8",
        )
        atomic_write_json(output_dir / "result.json", result)
        self.calls.append(
            {"task_id": task.task_id, "source": str(source_path), "output_dir": str(output_dir)}
        )
        return ValidationRecord(result, exit_code, output_dir)


def create_eda_adapter(config: dict[str, Any]):
    if config["eda"]["adapter"] == "mock":
        return MockEdaAdapter(config["mock"]["eda_scenarios"])
    if config["eda"]["adapter"] == "gitee":
        return GiteeEdaAdapter(config["eda"])
    return CliEdaAdapter(config["eda"])


def run_public_diagnostics(source_path, facts, output_dir, *, budget_seconds=60):
    """Execute literal public cases in an isolated generated bench; never read private TB."""
    import shutil,uuid
    from .failure_evidence import public_table_cases
    from .storage import atomic_write_text
    cases=public_table_cases(facts)
    none=lambda status,reason:{'status':status,'reason':reason,'cases':[]}
    if not cases:return none('not_applicable','no_supported_literal_public_cases')
    iverilog,vvp=shutil.which('iverilog'),shutil.which('vvp')
    vivado=[shutil.which(name) for name in ('xvlog','xelab','xsim')]
    if not (iverilog and vvp) and not all(vivado):return none('not_executed','public_simulator_unavailable')
    if budget_seconds<=0:return none('not_executed','diagnostic_time_budget_unavailable')
    output_dir=Path(output_dir).resolve();output_dir.mkdir(parents=True,exist_ok=True)
    token='PUBLIC_'+uuid.uuid4().hex;probe='public_probe_'+uuid.uuid4().hex[:10]
    declarations=[];connections=[];body=[]
    for port in facts['interface']['ports']:
        width='' if port['width']==1 else f"[{port['width']-1}:0] "
        declarations.append(('reg ' if port['direction']=='input' else 'wire ')+width+port['name']+';')
        connections.append('.'+port['name']+'('+port['name']+')')
    for case in cases:
        body.extend(f"{name} = {value};" for name,value in case['inputs'].items());body.append('#1;')
        for name in case['expected']:
            body.append(f'$display("{token} {case["case_id"]} {name} %h", {name});')
    body.extend([f'$display("{token} DONE");','$finish;'])
    bench=output_dir/'public_probe.sv'
    atomic_write_text(bench,'module '+probe+';\n'+'\n'.join(declarations)+'\n'+facts['interface']['module']+' dut('+','.join(connections)+');\ninitial begin\n'+'\n'.join(body)+'\nend\nendmodule\n')
    executable=output_dir/'public_probe.vvp'
    commands=([[iverilog,'-g2012','-s',probe,'-o',str(executable),str(Path(source_path).resolve()),str(bench)],[vvp,str(executable)]] if iverilog and vvp else
              [[vivado[0],'--sv',str(Path(source_path).resolve()),str(bench)],[vivado[1],probe,'-s',probe],[vivado[2],probe,'-runall']])
    started=time.monotonic();out=''
    try:
        for i,command in enumerate(commands):
            remaining=budget_seconds-(time.monotonic()-started)
            if remaining<=0:return none('not_executed','diagnostic_timeout')
            result=run_owned_process(command,cwd=output_dir,timeout=remaining,grace=10)
            atomic_write_text(output_dir/f'phase_{i}.log',result.stdout+result.stderr)
            if result.returncode!=0:return none('not_executed','public_probe_tool_failure')
            out=result.stdout
    except OwnedProcessTimeout as exc:
        if not exc.cleaned:raise
        return none('not_executed','diagnostic_timeout_cleaned')
    except OSError:return none('not_executed','public_probe_tool_unavailable')
    if token+' DONE' not in out:return none('not_executed','incomplete_public_probe_output')
    actual={}
    for line in out.splitlines():
        match=re.fullmatch(re.escape(token)+r' (\d+) ([A-Za-z_][A-Za-z0-9_$]*) ([0-9a-fA-FxXzZ]+)',line.strip())
        if match:
            key=(int(match[1]),match[2])
            if key in actual:return none('not_executed','duplicate_public_probe_output')
            digits=match[3].lower()
            actual[key]=digits if re.search('[xz]',digits) else format(int(digits,16),'x')
    records=[]
    for case in cases:
        if any((case['case_id'],name) not in actual for name in case['expected']):return none('not_executed','incomplete_public_probe_output')
        pairs=lambda values:[{'signal':n,'value':format(v,'x')} for n,v in sorted(values.items())]
        observed=[{'signal':name,'value':actual[(case['case_id'],name)]} for name in sorted(case['expected'])]
        matches=all(not re.search('[xz]',v['value']) and int(v['value'],16)==case['expected'][v['signal']] for v in observed)
        records.append({**{k:case[k] for k in ('case_id','requirement_refs')},'inputs':pairs(case['inputs']),'expected':pairs(case['expected']),'actual':observed,'matches':matches})
    return {'status':'executed','reason':'literal_public_cases_only_not_authoritative_acceptance','cases':records}
