"""Fine-grained failure taxonomy used by repair and search decisions."""

from __future__ import annotations

import re
from typing import Any


def failure_kind(stage: str | None, error_type: str | None,
                 warnings: list[str] | None = None,
                 diagnostics: dict[str, Any] | None = None) -> str:
    text = " ".join(str(x) for x in [stage, error_type, *(warnings or [])]).lower()
    diagnostics = diagnostics or {}
    if diagnostics.get("multiple_driver") or "multiple driver" in text or "multi-driven" in text or "should not be driven" in text:
        return "MULTIPLE_DRIVER"
    candidate_kinds = {item.get("kind") for item in diagnostics.get("candidate_errors", []) if isinstance(item, dict)}
    if "unsupported_frontend" in candidate_kinds:
        return "UNKNOWN"
    if "elaboration_error" in candidate_kinds:
        return "ELABORATION_ERROR"
    if "frontend_error" in candidate_kinds:
        return "UNKNOWN"
    if "syntax_error" in candidate_kinds:
        return "PARSE_ERROR"
    if "interface_or_scope" in candidate_kinds or "top_module" in candidate_kinds:
        return "ELABORATION_ERROR"
    if "timeout" in text:
        return "TIMEOUT"
    if "syntax" in text or str(stage).lower() == "compile":
        return "PARSE_ERROR"
    # Match diagnostic phrases, not substrings such as the "port" in
    # "unsupported". Underscores also delimit structured error names.
    diagnostic_text = text.replace("_", " ")
    port_error = re.search(
        r"\bports?\s+(?:error|mismatch|missing|not\s+found|does\s+not\s+exist|"
        r"connection\s+(?:error|mismatch)|width\s+mismatch)\b"
        r"|\b(?:missing|unknown|unconnected|undeclared)\s+ports?\b"
        r"|\b(?:cannot|could\s+not)\s+find\s+port\b"
        r"|\bport\s+\S+\s+(?:not\s+found|does\s+not\s+exist|is\s+not\s+a\s+port)\b",
        diagnostic_text,
    )
    if str(stage).lower() in {"elaborate", "elaboration"} or port_error or "width mismatch" in diagnostic_text:
        return "ELABORATION_ERROR"
    if any(token in text for token in ("signed", "unsigned", "width", "overflow", "truncat", "extend")):
        return "WIDTH_OR_SIGN_ERROR"
    if any(token in text for token in ("reset", "reset timing", "reset-cycle")):
        return "RESET_TIMING_ERROR"
    if any(token in text for token in ("latency", "one cycle", "cycle early", "cycle late")):
        return "OUTPUT_LATENCY_ERROR"
    if any(token in text for token in ("priority", "enable", "simultaneous", "collision")):
        return "PRIORITY_ERROR"
    if any(token in diagnostic_text for token in ("latch", "uninitialized", "uninitialised", "x state")):
        return "UNINITIALIZED_OR_LATCH"
    if any(token in text for token in ("state", "fsm", "transition", "sequence")):
        return "STATE_TRANSITION_ERROR"
    if str(stage).lower() == "synthesis" or "synthesis" in text:
        return "SYNTHESIS_ONLY_ERROR"
    if str(stage).lower() == "simulation" or "functional" in text or diagnostics.get("functional_mismatch"):
        return "SIMULATION_ERROR"
    return "UNKNOWN"
