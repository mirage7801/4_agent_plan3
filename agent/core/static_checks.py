"""Cheap, public-source-only RTL checks run before Vivado."""

from __future__ import annotations

import re
from typing import Any


from model.rtl_lex import mask_noncode, module_declarations, preprocessing_sensitive


def check_rtl(source: str, top_module: str) -> dict[str, Any]:
    if preprocessing_sensitive(source):
        return {"status":"PASS","issues":[],"warnings":["raw structural checks deferred: preprocessing required"],"checks":[],"structural_status":"unknown"}
    names = {m["name"] for m in module_declarations(source)}
    source = mask_noncode(source)
    issues: list[dict[str, Any]] = []
    warnings: list[str] = []

    def issue(kind: str, message: str) -> None:
        issues.append({"kind": kind, "message": message})

    if top_module not in names:
        issue("top_module", f"top module {top_module!r} is missing")
    if len(re.findall(r"\bmodule\b", source)) != len(re.findall(r"\bendmodule\b", source)):
        issue("module_balance", "module/endmodule count is unbalanced")
    for opening, closing, label in (("(", ")", "parentheses"), ("[", "]", "brackets"), ("{", "}", "braces")):
        if source.count(opening) != source.count(closing):
            issue("delimiter_balance", f"{label} are unbalanced")
    if re.search(r"\b(always_comb|always @\*|always @\(\*\))\b", source) and re.search(r"\bif\b|\bcase\b", source):
        if not re.search(r"\b(default|else)\b", source):
            warnings.append("combinational process may have an incomplete assignment/latch")
    if len(re.findall(r"\balways_ff\b|\balways\s*@\s*\(\s*posedge", source)) > 1:
        warnings.append("multiple sequential processes present; check for multiple drivers")
    if re.search(r"\b(always_ff|always)\b[^\n]*posedge\s+\w+\s*or\s*posedge", source, re.I):
        warnings.append("asynchronous reset sensitivity detected; confirm the public contract")
    if re.search(r"\bparameter\b", source) and re.search(r"\[[^\]]*WIDTH\s*-\s*2", source, re.I):
        warnings.append("parameterized slice may become zero/negative width at WIDTH=1")
    return {"status": "PASS" if not issues else "BLOCK", "issues": issues, "warnings": warnings,
            "checks": ["top_module", "module_balance", "delimiter_balance", "basic_latch", "driver_shape"]}


def syntax_check(source_path, top_module, output_dir, *, config=None):
    """Invoke an installed HDL frontend; regex checks never count as parsing."""
    import shutil
    from .eda_adapter import run_owned_process, OwnedProcessTimeout
    from pathlib import Path
    from .storage import atomic_write_text
    tool=shutil.which("iverilog") or shutil.which("verilator")
    if tool is None:
        return {"status":"not_executed","tool":None,"reason":"no_standalone_parser; compilation deferred to configured EDA validator"}
    output_dir=Path(output_dir); output_dir.mkdir(parents=True,exist_ok=True)
    if Path(tool).stem.lower()=="iverilog":
        command=[tool,"-g2012","-t","null","-s",top_module,str(source_path)]
    else:
        command=[tool,"--lint-only","--timing","-Wno-fatal","--top-module",top_module,"--Mdir",str(output_dir/"verilator"),str(source_path)]
    try:
        proc=run_owned_process(command,cwd=output_dir,timeout=30,grace=(config or {}).get("agent",{}).get("worker_watchdog",{}).get("termination_grace_seconds",10))
        atomic_write_text(output_dir/"syntax.log",proc.stdout+proc.stderr)
        return {"status":"passed" if proc.returncode==0 else "failed","tool":tool,"exit_code":proc.returncode,"log_file":str(output_dir/"syntax.log"),
                "candidate_errors": syntax_diagnostics(proc.stdout+proc.stderr, source_path, Path(tool).stem, work_dir=output_dir)}
    except OwnedProcessTimeout as exc:
        atomic_write_text(output_dir/"syntax.log",str(exc))
        if not exc.cleaned:
            if config is not None:
                from agent.runtime.worker_boundary import worker_barrier_path
                from .storage import atomic_write_json
                atomic_write_json(worker_barrier_path(config),{"kind":"syntax_frontend_cleanup_unknown","pid":exc.pid,"cleanup_detail":exc.cleanup_detail})
            raise
        return {"status":"not_executed","tool":tool,"reason":"frontend_timeout_cleaned","log_file":str(output_dir/"syntax.log")}
    except OSError as exc:
        atomic_write_text(output_dir/"syntax.log",str(exc))
        return {"status":"not_executed","tool":tool,"reason":type(exc).__name__,"log_file":str(output_dir/"syntax.log")}


def syntax_diagnostics(output, source_path, tool, *, work_dir=None):
    """Resolve diagnostic locations against the actual frontend cwd; never basename-match."""
    import os
    from pathlib import Path
    path = Path(source_path).resolve()
    base = Path(work_dir).resolve() if work_dir is not None else Path.cwd()
    records, seen = [], set()
    for text in output.splitlines():
        match = re.match(r"^(?P<prefix>%Error(?:-[A-Za-z0-9_]+)?:\s*)?(?P<path>.+?):(?P<line>\d+)(?::\d+)?\s*:\s*(?P<message>.*)$", text.strip())
        if not match:
            continue
        location = Path(match['path'].strip().strip('"'))
        resolved = (location if location.is_absolute() else base / location).resolve()
        if os.path.normcase(str(resolved)) != os.path.normcase(str(path)):
            continue
        line, message = int(match['line']), match['message']
        code_match = re.search(r"%Error(?:-([A-Za-z0-9_]+))?", match['prefix'] or '')
        if line < 1 or (not code_match and not re.search(r"\b(?:error|syntax|sorry)\b", message, re.I)):
            continue
        code = code_match.group(1) if code_match else None
        if code in {'UNSUPPORTED'} or re.search(r"\bunsupported\b|not supported|sorry", message, re.I):
            kind = 'unsupported_frontend'
        elif code in {'PINMISSING','PINNOTFOUND','MODMISSING'} or re.search(r"unknown module|unable to bind|not a port|port.*not found", message, re.I):
            kind = 'elaboration_error'
        elif code == 'SYNTAX' or re.search(r"syntax error|unexpected token", message, re.I):
            kind = 'syntax_error'
        else:
            kind = 'frontend_error'
        message = re.sub(r"(?:[A-Za-z]:[\\/]|/|\\)[^\s,;]+", "<file>", message)
        message = " ".join(message.split())[:700]
        key = (line, message)
        if key in seen:
            continue
        seen.add(key)
        record = {"kind":kind, "tool":tool, "line":line, "message":message}
        if code:
            record['code'] = code
        records.append(record)
        if len(records) == 8:
            break
    return records
