"""Validator-side candidate-safe feedback projection.

The validator owns this first projection.  Only the resulting structured
fields may cross into the agent repair context; private testbench/reference
fixtures, constraint paths and raw logs remain local to the validator.
"""

from __future__ import annotations

import re
from typing import Any


def _redact(text: Any, result: dict[str, Any]) -> str:
    value = str(text or "")
    source = str(result.get("source", ""))
    testbench = str(result.get("testbench", ""))
    for original in (source, source.replace("\\", "/"), testbench, testbench.replace("\\", "/")):
        if original:
            replacement = (
                "<candidate_rtl>"
                if original in {source, source.replace("\\", "/")}
                else "<private_testbench>"
            )
            value = value.replace(original, replacement)
    value = re.sub(r"(?i)(?:[A-Za-z]:)?[^\r\n;]*?\.xdc", "<private_validation_file>", value)
    value = re.sub(
        r"(?i)(?:[A-Za-z]:)?[^\s;]*[\\/](?:tb_[^\\/\s]+|tb|testbench)\.(?:sv|v)",
        "<private_testbench>",
        value,
    )
    value = re.sub(
        r"(?i)(?:[A-Za-z]:)?[^\s;]*[\\/](?:(?:reference|ref)\.(?:v|sv)|faults[\\/][^\s;]+)",
        "<private_validation_fixture>",
        value,
    )
    return " ".join(value.split())[:1000]


def team_two_feedback(result: dict[str, Any]) -> dict[str, Any]:
    """Return the validator-owned, candidate-safe feedback schema."""

    source = str(result.get("source", "")).replace("\\", "/").lower()
    private_fixture = source.endswith("/reference.v") or "/faults/" in source
    error_type = str(result.get("error_type", "unknown_error"))
    environment = bool(result.get("environment_failure")) or "environment" in error_type.lower()
    if "no candidate rtl evidence" in str(result.get("summary", "")).lower():
        environment = True
    summary = _redact(result.get("summary", ""), result)
    if private_fixture:
        summary = f"{error_type}: private validation fixture details withheld"
    return {
        "stage": result.get("stage"),
        "error_type": result.get("error_type"),
        "summary": summary,
        "warnings": [] if environment or private_fixture else [
            _redact(item, result) for item in result.get("warnings", [])
        ],
        "candidate_feedback_allowed": not environment and not private_fixture,
    }
