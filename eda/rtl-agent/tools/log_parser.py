"""Classify Vivado/xsim diagnostics and produce bounded, actionable summaries."""
from __future__ import annotations

from pathlib import Path
import re

from .result_schema import short_summary


SIMULATION_KINDS = {
    "functional_mismatch",
    "reset_behavior_error",
    "latency_mismatch",
    "simulation_timeout",
    "unknown_value",
}

_LOCATION_RE = re.compile(
    r"\[(?P<path>(?:[A-Za-z]:)?[^]\r\n]*?):(?P<line>\d+)(?::(?P<column>\d+))?\]"
)
_FILE_LINE_RE = re.compile(
    r"(?:File|file):\s*(?P<path>.+?)\s+(?:Line|line):\s*(?P<line>\d+)"
)
_TRAILING_LOCATION_RE = re.compile(
    r"(?P<path>(?:[A-Za-z]:)?[^\s\]\)]+\.(?:v|sv|vh|vhd|vhdl)):(?P<line>\d+)(?::(?P<column>\d+))?"
)
_TB_FAIL_RE = re.compile(r"\bTB_FAIL\b(?P<body>.*)", re.I)
_FIELD_RE = re.compile(r"(?P<key>[A-Za-z_]\w*)=(?P<value>[^\s]+)")


def parse_tb_fail(text: str) -> dict[str, str] | None:
    """Return fields from the first structured TB_FAIL line, if present."""
    for line in text.splitlines():
        match = _TB_FAIL_RE.search(line)
        if not match:
            continue
        fields = {item.group("key"): item.group("value") for item in _FIELD_RE.finditer(match.group("body"))}
        if fields:
            return fields
    return None


def _location(line: str) -> tuple[str, int, int | None] | None:
    match = _LOCATION_RE.search(line) or _FILE_LINE_RE.search(line) or _TRAILING_LOCATION_RE.search(line)
    if not match:
        return None
    return match.group("path"), int(match.group("line")), int(match.group("column")) if match.groupdict().get("column") else None


def _same_path(left: str | Path, right: str | Path) -> bool:
    try:
        return Path(left).resolve().as_posix().lower() == Path(right).resolve().as_posix().lower()
    except OSError:
        return str(left).replace("\\", "/").lower() == str(right).replace("\\", "/").lower()


def _mapped_location(
    path: str,
    *,
    source_path: str | Path | None,
    testbench_path: str | Path | None,
) -> tuple[str, str]:
    """Map staged paths and label testbench locations without exposing staging paths."""
    normalized = path.replace("\\", "/")
    name = Path(normalized).name.lower()
    if source_path and (name in {"source.v", "source.sv"} or _same_path(normalized, source_path)):
        return str(source_path), "candidate RTL"
    if testbench_path and (name in {"testbench.sv", "testbench.v"} or _same_path(normalized, testbench_path)):
        return str(testbench_path), "validation environment/testbench"
    if name.startswith("tb_") or "testbench" in name:
        return path, "validation environment/testbench"
    return path, "tool diagnostic"


def _candidate_snippet(path: str | Path, line: int) -> str | None:
    try:
        lines = Path(path).read_text(encoding="utf-8").splitlines()
    except (OSError, UnicodeError):
        return None
    if not 1 <= line <= len(lines):
        return None
    first = max(1, line - 2)
    last = min(len(lines), line + 2)
    return " | ".join(f"{number}:{lines[number - 1].strip()}" for number in range(first, last + 1))


def _relocate_line(
    line: str,
    *,
    source_path: str | Path | None,
    testbench_path: str | Path | None,
) -> str:
    location = _location(line)
    if not location:
        return short_summary(line)
    path, line_number, column = location
    mapped, _ = _mapped_location(path, source_path=source_path, testbench_path=testbench_path)
    suffix = f":{line_number}" + (f":{column}" if column is not None else "")
    return short_summary(line.replace(f"{path}:{line_number}" + (f":{column}" if column is not None else ""), f"{mapped}{suffix}"))


def warnings_from(
    text: str,
    *,
    source_path: str | Path | None = None,
    testbench_path: str | Path | None = None,
) -> list[str]:
    warnings = []
    for line in text.splitlines():
        if re.search(r"\b(?:WARNING|CRITICAL WARNING)\b", line, re.I):
            value = _relocate_line(line, source_path=source_path, testbench_path=testbench_path)
            if value not in warnings:
                warnings.append(value)
    return warnings[:50]


def _has_unknown_value(fields: dict[str, str] | None, text: str) -> bool:
    if fields:
        for key, value in fields.items():
            if key in {"actual", "value", "output", "data"} and re.search(r"[xXzZ]", value):
                return True
    return bool(re.search(r"\b(?:actual|value|output|data)=[^\s]*[xXzZ]", text, re.I))


def _diagnostic_lines(text: str) -> tuple[list[str], list[str]]:
    errors = [line.strip() for line in text.splitlines() if re.search(r"\b(?:ERROR|FATAL|TEST_FAIL)\b", line, re.I)]
    warnings = [line.strip() for line in text.splitlines() if re.search(r"\b(?:WARNING|CRITICAL WARNING)\b", line, re.I)]
    return errors, warnings


def _primary_diagnostic(stage: str, text: str, fields: dict[str, str] | None) -> str:
    errors, warnings = _diagnostic_lines(text)
    if fields:
        for line in text.splitlines():
            if _TB_FAIL_RE.search(line):
                return line.strip()
    patterns = {
        "compile": r"syntax error|unexpected|incorrect context|cannot find.*module|module.*not found|port.*(?:mismatch|not found)|actual bit length|width",
        "elaborate": r"module.*(?:not found|not defined)|port.*(?:mismatch|not found)|actual bit length|width|elaborat",
        "synthesis": r"multi.driven|multiple.driver|latch|combinational loop|not synthesizable|syntax error|error",
    }
    preferred = [line for line in errors if re.search(patterns.get(stage, r"."), line, re.I)]
    if preferred:
        return preferred[0]
    useful = [line for line in errors if not re.search(r"ignored due to previous errors|previous error", line, re.I)]
    return useful[0] if useful else (errors[0] if errors else (warnings[0] if warnings else ""))


def _summary(
    kind: str,
    diagnostic: str,
    *,
    source_path: str | Path | None,
    testbench_path: str | Path | None,
) -> str:
    location = _location(diagnostic)
    if not location:
        return short_summary(f"{kind}: 位置未知; {diagnostic or 'inspect raw log'}")
    path, line_number, column = location
    mapped, label = _mapped_location(path, source_path=source_path, testbench_path=testbench_path)
    suffix = f":{line_number}" + (f":{column}" if column is not None else "")
    message = _relocate_line(diagnostic, source_path=source_path, testbench_path=testbench_path)
    if label == "candidate RTL" and source_path:
        snippet = _candidate_snippet(source_path, line_number)
        if snippet:
            return short_summary(f"{kind} at candidate RTL {mapped}{suffix}: {message}; code {snippet}")
        return short_summary(f"{kind} at candidate RTL {mapped}{suffix}: {message}")
    if label == "validation environment/testbench":
        return short_summary(f"{kind} at validation environment/testbench {mapped}{suffix}: {message}")
    return short_summary(f"{kind} at {mapped}{suffix}: {message}")


def classify(
    stage: str,
    text: str,
    *,
    timed_out: bool = False,
    source_path: str | Path | None = None,
    testbench_path: str | Path | None = None,
) -> tuple[str, str]:
    fields = parse_tb_fail(text) if stage == "simulation" else None
    if timed_out:
        return ("simulation_timeout" if stage == "simulation" else "timeout", f"{stage} exceeded its configured timeout")
    diagnostic_lines, warning_lines = _diagnostic_lines(text)
    evidence = "\n".join(diagnostic_lines + warning_lines)
    if stage == "simulation":
        if not fields and not re.search(r"TEST_FAIL|Fatal:", text, re.I):
            diagnostic = _primary_diagnostic(stage, text, None)
            message = _summary("unknown_error", diagnostic or "simulation tool failed", source_path=source_path, testbench_path=testbench_path)
            return "unknown_error", short_summary(f"simulation tool failure; no candidate RTL evidence; {message}")
        if fields and fields.get("kind") in SIMULATION_KINDS:
            kind = fields["kind"]
        elif re.search(r"(?:simulation|watchdog).*timeout|TEST_FAIL[^\n]*\btimeout\b", text, re.I):
            kind = "simulation_timeout"
        elif _has_unknown_value(fields, text):
            kind = "unknown_value"
        elif re.search(r"latency|timing\s+(?:offset|shift)|one\s+cycle\s+(?:late|early)", evidence, re.I):
            kind = "latency_mismatch"
        elif (re.search(r"(?:case|test_case)=(?:initial_reset|runtime_reset)", evidence, re.I) or (re.search(r"\brst=1\b", evidence, re.I) and re.search(r"reset", evidence, re.I)) or re.search(r"\bTEST_FAIL\s+reset\b", evidence, re.I)):
            kind = "reset_behavior_error"
        else:
            kind = "functional_mismatch"
        diagnostic = _primary_diagnostic(stage, text, fields)
        return kind, _summary(kind, diagnostic or "simulation failed; inspect raw log", source_path=source_path, testbench_path=testbench_path)
    rules = [
        (r"license|licen[sc]e checkout|no valid.*licen", "license_error"),
        (r"unsupported part|part.*not found|invalid part", "unsupported_part"),
        (r"multiple.driver|multi.driven|multiple.*driver|multi-source", "multiple_driver"),
        (r"latch.*infer|inferred.*latch", "latch_inferred"),
        (r"combinational loop|combinatorial loop", "combinational_loop"),
        (r"not synthesizable|unsupported.*construct|non.synthesizable", "unsynthesizable_construct"),
        (r"width.*mismatch|mismatch.*width|truncat|padding.*port", "width_mismatch"),
        (r"actual bit length.*differs from formal bit length", "width_mismatch"),
        (r"port.*(?:mismatch|not found|does not exist)|(?:missing|unknown).*port", "port_mismatch"),
        (r"module.*(?:not found|not defined|does not exist)|cannot find.*module|cannot find design unit", "module_not_found"),
        (r"syntax error|near.*syntax|unexpected token|missing.*semicolon", "syntax_error"),
        (r"unknown value|\b[0-9]+'[bhd][xXzZ]+\b", "unknown_value"),
    ]
    for pattern, kind in rules:
        if re.search(pattern, evidence, re.I):
            break
    else:
        kind = {"compile": "syntax_error", "elaborate": "elaboration_error", "simulation": "functional_mismatch", "synthesis": "synthesis_error"}.get(stage, "unknown_error")
    diagnostic = _primary_diagnostic(stage, text, None)
    return kind, _summary(kind, diagnostic or f"{stage} failed; inspect raw log", source_path=source_path, testbench_path=testbench_path)
