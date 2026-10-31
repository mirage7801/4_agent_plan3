"""Project-local repair knowledge for candidate search."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from .diagnostics import failure_kind


@dataclass(frozen=True)
class RepairStrategy:
    name: str
    instructions: str


_STRATEGIES = {
    name: RepairStrategy(name, text) for name, text in {
        "syntax": "Correct supported syntax errors while preserving the original interface and semantics.",
        "interface": "Restore the locked public interface; do not change task facts.",
        "simulation": "Compare the candidate against the public specification and available observations.",
        "reset_timing": "Investigate the reported reset behavior only if the task requires it.",
        "latency": "Investigate output timing only when a required timing relationship is known.",
        "priority": "Investigate simultaneous conditions only against the specified ordering.",
        "width_sign": "Compare arithmetic widths and signedness with the public interface and behavior.",
        "fsm": "Compare the requested transition/output logic with the public state specification.",
        "latch": "Check incomplete assignments against the requested storage behavior; do not invent initialization.",
        "synthesis": "Address the reported structural failure while preserving required storage and behavior.",
        "timeout": "Investigate tool or candidate complexity using the actual timeout evidence.",
        "general": "Use the public specification and observations to identify a supported minimal repair.",
    }.items()
}


def classify_failure(stage: str | None, error_type: str | None,
                     warnings: list[str] | None = None,
                     diagnostics: dict[str, Any] | None = None) -> RepairStrategy:
    kind = failure_kind(stage, error_type, warnings, diagnostics)
    mapping = {
        "PARSE_ERROR": "syntax", "ELABORATION_ERROR": "interface",
        "WIDTH_OR_SIGN_ERROR": "width_sign", "RESET_TIMING_ERROR": "reset_timing",
        "OUTPUT_LATENCY_ERROR": "latency", "PRIORITY_ERROR": "priority",
        "STATE_TRANSITION_ERROR": "fsm", "UNINITIALIZED_OR_LATCH": "latch",
        "MULTIPLE_DRIVER": "synthesis", "SYNTHESIS_ONLY_ERROR": "synthesis",
        "TIMEOUT": "timeout", "SIMULATION_ERROR": "simulation",
    }
    return _STRATEGIES[mapping.get(kind, "general")]


# A small conditional rule table, not a separate routing framework.
_CHECKS = (
    ("locked_interface", "interface", "Keep the locked public interface unchanged."),
    ("combinational_scope", "scope", "Preserve the explicitly combinational scope; add no state storage."),
    ("complete_comb_assignments", "scope", "Check complete assignments in the requested combinational logic."),
    ("public_table_rows", "public_table", "Check every referenced public table row."),
    ("reset_behavior", "reset_behavior", "Check only the reset behavior explicitly specified by the task; add no initialization feature."),
    ("reset_priority", "reset_priority", "Check the explicitly stated reset priority."),
    ("priority_order", "priority", "Check multiple asserted conditions against the specified order; do not assume MSB or LSB priority."),
    ("enable_behavior", "enable", "Check exactly the specified enabled and disabled behavior."),
    ("output_timing", "output_latency", "Check the specified output timing relationship; do not add pipeline stages."),
    ("illegal_states", "illegal_states", "Check illegal-state behavior only as explicitly required."),
    ("parameter_range", "parameter_range", "Check parameters within the public legal range; do not assume a minimum value."),
    ("collision_behavior", "collision", "Check the specified simultaneous read/write behavior; do not choose a default policy."),
    ("state_transitions", "state_transitions", "Check the requested state transitions without adding unrequested state storage."),
)


def applicable_checks(facts: dict[str, Any], profile: dict[str, Any], stage: str) -> dict[str, Any]:
    enabled, skipped = [], []
    for check_id, feature, instruction in _CHECKS:
        if feature == "interface":
            refs = list(dict.fromkeys(r for p in facts["interface"]["ports"] for r in p["source_refs"]))
            state = "satisfied" if refs else "unknown"
        elif feature == "scope":
            item = profile["implementation_scope"]; refs = item["requirement_refs"]
            state = "satisfied" if item["value"] == "combinational" else "unknown" if item["value"] == "unknown" else "not_applicable"
        else:
            item = profile["features"][feature]; refs = item["requirement_refs"]
            state = ("satisfied" if item["status"] == "source_checked" and item["value"] is True
                     else "not_applicable" if item["status"] == "not_applicable" else "unknown")
        if state == "satisfied":
            enabled.append({"check_id": check_id, "requirement_refs": refs, "instruction": instruction})
        else:
            skipped.append({"check_id": check_id, "applicability": state,
                            "requirement_refs":refs,
                            "reason": "explicitly_not_required_or_outside_scope" if state == "not_applicable" else "no_checked_source_requirement"})
    return {"schema_version":"1.0", "stage":stage,"facts_ref":facts["facts_id"],
            "enabled":enabled,"skipped":skipped,"execution_status":"suggestions_not_executed_checks"}


def strategy_context(strategy: RepairStrategy, profile: dict[str, Any] | None = None) -> str:
    feature = {"reset_timing":"reset_behavior","latency":"output_latency","priority":"priority","fsm":"state_transitions"}.get(strategy.name)
    if feature and (profile is None or profile["features"][feature]["status"] != "source_checked"):
        return "Unconfirmed failure label: " + strategy.name + ". " + _STRATEGIES["general"].instructions
    return "Failure label (not a proven root cause): " + strategy.name + ". " + strategy.instructions


