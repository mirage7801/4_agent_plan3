"""One immutable RTL attempt, four real Vivado stages, one machine-readable result."""
from __future__ import annotations

import json
import locale
import os
import re
import signal
import shutil
import subprocess
import tempfile
import time
import uuid
from pathlib import Path

from .log_parser import classify, warnings_from
from .result_schema import ROOT, new_result, short_summary, validate_result

DEFAULT_PART = "xczu3eg-sbva484-1-e"
DEFAULT_TIMEOUTS = {"compile_seconds": 60, "elaborate_seconds": 60, "simulation_seconds": 120, "synthesis_seconds": 300}


def _decode(output: bytes) -> str:
    for codec in ("utf-8-sig", locale.getpreferredencoding(False)):
        try:
            return output.decode(codec)
        except UnicodeDecodeError:
            continue
    return output.decode("utf-8", errors="replace")


def _resolve(value: str | Path) -> Path:
    path = Path(value)
    return (path if path.is_absolute() else ROOT / path).resolve()


def _tool_bin(explicit: str | Path | None) -> Path | None:
    if explicit:
        return _resolve(explicit)
    environment = os.environ.get("RTL_AGENT_VIVADO_BIN")
    if environment:
        return Path(environment).resolve()
    found = shutil.which("vivado.bat" if os.name == "nt" else "vivado")
    if found:
        return Path(found).resolve().parent
    if os.name == "nt":
        for drive in ("C", "D", "E"):
            for vendor in ("AMDDesignTools", "AMD", "Xilinx"):
                candidate = Path(f"{drive}:/{vendor}/2026.1/Vivado/bin")
                if (candidate / "vivado.bat").is_file():
                    return candidate.resolve()
    return None


def _tool(bin_dir: Path, name: str) -> Path:
    return bin_dir / (name + (".bat" if os.name == "nt" else ""))


def _synthesis_command(bin_dir: Path, source_name: str, top: str, part: str, has_constraints: bool) -> list[str]:
    # Vivado's Windows batch launcher can mishandle drive-qualified Tcl arguments.
    # All staged files live in the process cwd, so use relative names throughout.
    return [str(_tool(bin_dir, "vivado")), "-mode", "batch", "-nolog", "-nojournal", "-notrace",
            "-source", "synth.tcl", "-tclargs", source_name, top, part,
            "constraints.xdc" if has_constraints else "NO_CONSTRAINTS", "synth_netlist.v"]


def _reserve_output(requested: Path, overwrite: bool) -> Path:
    if requested.exists() and any(requested.iterdir()) and not overwrite:
        requested = requested.parent / f"{requested.name}_run_{time.strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}"
    requested.mkdir(parents=True, exist_ok=True)
    return requested


def _execute(command: list[str], directory: Path, log_file: Path, timeout: float) -> tuple[int | None, str, bool, float]:
    start = time.monotonic()
    timed_out = False
    try:
        process = subprocess.Popen(command, cwd=directory, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if os.name == "nt" else 0,
                                   start_new_session=os.name != "nt")
        try:
            stdout_bytes, stderr_bytes = process.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
            if os.name == "nt":
                subprocess.run(["taskkill", "/PID", str(process.pid), "/T", "/F"], capture_output=True, timeout=10)
            else:
                os.killpg(process.pid, signal.SIGKILL)
            stdout_bytes, stderr_bytes = process.communicate(timeout=10)
        stdout = _decode(stdout_bytes)
        stderr = _decode(stderr_bytes)
        code = None if timed_out else process.returncode
    except subprocess.TimeoutExpired as exc:
        timed_out = True
        stdout = _decode(exc.stdout or b"")
        stderr = _decode(exc.stderr or b"")
        code = None
    except OSError as exc:
        stdout, stderr, code = "", str(exc), None
    duration = round(time.monotonic() - start, 3)
    log_file.write_text(json.dumps({"argv": command, "cwd": str(directory), "returncode": code,
                                   "timed_out": timed_out, "elapsed_seconds": duration}, ensure_ascii=False)
                        + "\n--- STDOUT ---\n" + stdout + "\n--- STDERR ---\n" + stderr, encoding="utf-8")
    return code, stdout + "\n" + stderr, timed_out, duration


def validate_rtl(source: str | Path, testbench: str | Path, top: str,
                 part: str = DEFAULT_PART, clock_period_ns: float = 5.0,
                 output_dir: str | Path = "outputs/validation", *,
                 timeouts: dict | None = None, synth_on_sim_failure: bool = False,
                 overwrite: bool = False, vivado_bin: str | Path | None = None,
                 constraints: str | Path | None = None) -> dict:
    """Return schema 1.0 dict. Never writes to source/testbench; output runs are isolated."""
    start = time.monotonic()
    result = new_result(str(_resolve(source)), str(_resolve(testbench)), top, part, clock_period_ns)
    out = None
    work = None
    staged_source = None

    def finish(stage: str, error: str, message: str, passed: bool = False) -> dict:
        if staged_source is not None:
            message = message.replace(str(staged_source), str(source_file)).replace(staged_source.as_posix(), source_file.as_posix())
        result.update(passed=passed, stage=stage, error_type=error, summary=short_summary(message))
        result["timings"]["total_seconds"] = round(time.monotonic() - start, 3)
        validate_result(result)
        if out is not None:
            (out / "result.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        return result

    try:
        source_file, tb_file = _resolve(source), _resolve(testbench)
        out = _reserve_output(_resolve(output_dir), overwrite)
        result["output_dir"] = str(out)
        if not source_file.is_file() or not tb_file.is_file():
            return finish("environment", "tool_not_found", "source or testbench file not found")
        if not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9$]*", top) or not part or float(clock_period_ns) <= 0:
            return finish("environment", "unknown_error", "invalid top, part, or clock period")
        limits = {**DEFAULT_TIMEOUTS, **(timeouts or {})}
        if any(float(value) <= 0 for value in limits.values()):
            return finish("environment", "unknown_error", "timeouts must be positive")
        bin_dir = _tool_bin(vivado_bin)
        names = ("xvlog", "xelab", "xsim", "vivado")
        if bin_dir is None or any(not _tool(bin_dir, name).is_file() for name in names):
            return finish("environment", "tool_not_found", "Vivado 2026.1 toolchain not found")

        version_cmd = [str(_tool(bin_dir, "vivado")), "-version"]
        code, version_text, expired, _ = _execute(version_cmd, out, out / "environment.log", 30)
        result["commands"].append({"stage": "environment", "argv": version_cmd, "returncode": code})
        result["log_files"].append(str(out / "environment.log"))
        match = re.search(r"vivado v(\d{4}\.\d+)", version_text, re.I)
        result["vivado_version"] = match.group(1) if match else None
        # The Windows 2026.1 launcher returns 1 for the informational -version switch.
        # Trust the parsed version text, but preserve the observed return code in the log.
        if expired or result["vivado_version"] != "2026.1":
            return finish("environment", "tool_not_found", "Vivado 2026.1 version check failed")

        # Vivado 2026.1's Windows synthesis launcher has crashed on Unicode cwd/source
        # paths. Stage byte-identical inputs in a private ASCII temporary workdir.
        work = Path(tempfile.mkdtemp(prefix="rtl_agent_"))
        staged_source = work / ("source.sv" if source_file.suffix.lower() == ".sv" else "source.v")
        staged_tb = work / "testbench.sv"
        staged_sim_tcl = work / "run_xsim.tcl"
        staged_synth_tcl = work / "synth.tcl"
        for original, staged in ((source_file, staged_source), (tb_file, staged_tb),
                                 (ROOT / "tools/vivado/run_xsim.tcl", staged_sim_tcl),
                                 (ROOT / "tools/vivado/synth.tcl", staged_synth_tcl)):
            shutil.copy2(original, staged)
        snapshot = "rtl_agent_snapshot"
        tb_top = "tb_" + top
        stages = [
            ("compile", [str(_tool(bin_dir, "xvlog")), "-sv", "-work", "work", str(staged_source), str(staged_tb)]),
            ("elaborate", [str(_tool(bin_dir, "xelab")), f"work.{tb_top}", "-s", snapshot, "-debug", "typical"]),
            ("simulation", [str(_tool(bin_dir, "xsim")), snapshot, "-tclbatch", staged_sim_tcl.as_posix()]),
        ]
        sim_failed = False
        for stage, command in stages:
            code, log, expired, seconds = _execute(command, work, out / f"{stage}.log", float(limits[f"{stage}_seconds"]))
            result["commands"].append({"stage": stage, "argv": command, "returncode": code})
            result["log_files"].append(str(out / f"{stage}.log"))
            result["warnings"].extend(warnings_from(log, source_path=source_file, testbench_path=tb_file))
            result["timings"][f"{stage}_seconds"] = seconds
            if expired or code != 0 or (stage == "simulation" and ("TEST_PASS" not in log or "TEST_FAIL" in log or "couldn't read file" in log)):
                error, message = classify(stage, log + "\n" + "\n".join(result["warnings"]), timed_out=expired, source_path=source_file, testbench_path=tb_file)
                if stage != "simulation" or not synth_on_sim_failure:
                    return finish(stage, error, message)
                sim_failed = True
                result.update(stage=stage, error_type=error, summary=message)
                break

        xdc = _resolve(constraints) if constraints else tb_file.parent / "constraints.xdc"
        if constraints and not xdc.is_file():
            return finish("environment", "unknown_error", f"constraints file not found: {xdc}")
        if xdc is not None and not xdc.is_file():
            xdc = None
        if xdc:
            staged_xdc = work / "constraints.xdc"
            shutil.copy2(xdc, staged_xdc)
            original_xdc = staged_xdc.read_text(encoding="utf-8")
            if not re.search(r"create_clock\s+-period\s+[\d.]+", original_xdc):
                return finish("environment", "unknown_error", "clocked task XDC lacks create_clock -period")
            updated_xdc = re.sub(r"(create_clock\s+-period\s+)[\d.]+", lambda match: match.group(1) + str(float(clock_period_ns)), original_xdc)
            staged_xdc.write_text(updated_xdc, encoding="utf-8")
            xdc = staged_xdc
        netlist = out / "synth_netlist.v"
        staged_netlist = work / "synth_netlist.v"
        command = _synthesis_command(bin_dir, staged_source.name, top, part, xdc is not None)
        code, log, expired, seconds = _execute(command, work, out / "synthesis.log", float(limits["synthesis_seconds"]))
        result["commands"].append({"stage": "synthesis", "argv": command, "returncode": code})
        result["log_files"].append(str(out / "synthesis.log"))
        result["warnings"].extend(warnings_from(log, source_path=source_file, testbench_path=tb_file))
        result["timings"]["synthesis_seconds"] = seconds
        if staged_netlist.is_file():
            shutil.copy2(staged_netlist, netlist)
            result["artifacts"].append(str(netlist))
        if sim_failed:
            return finish(result["stage"], result["error_type"], result["summary"])
        critical_structure = re.search(r"CRITICAL WARNING:.*(?:multi.driven|multiple.driver|combinational loop|latch.*infer)", log, re.I)
        if expired or code != 0 or "SYNTH_DESIGN_SUCCESS" not in log or re.search(r"\bERROR\b", log) or critical_structure or not netlist.is_file() or not netlist.stat().st_size:
            error, message = classify("synthesis", log, timed_out=expired, source_path=source_file, testbench_path=tb_file)
            return finish("synthesis", error, message)
        return finish("complete", "none", "编译、详细描述、仿真和目标器件综合均通过", True)
    except (ValueError, OSError) as exc:
        return finish("environment", "unknown_error", str(exc))
    finally:
        if work is not None and work.is_dir() and work.name.startswith("rtl_agent_") and work.parent == Path(tempfile.gettempdir()):
            shutil.rmtree(work, ignore_errors=True)
