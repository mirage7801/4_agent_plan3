"""Prompt assembly using only public task data and safe validator feedback."""

from __future__ import annotations

import json
from model.framing import output_contract
from typing import Any



def _model_task_context(public_problem: dict[str, Any]) -> dict[str, str]:
    """Return only task facts the model must consume, never run metadata.

    The runner, rather than the model, owns task/run identifiers, model
    identity, paths, target part and clock-period metadata.  A model still
    needs the public problem text, language and required top-module name in
    order to produce RTL, so those remain in its input.
    """

    return {
        "language": str(public_problem["language"]),
        "top_module": str(public_problem["top_module"]),
        "public_task": str(public_problem["public_problem"]).strip(),
    }


def _rtl_output_contract() -> str:
    """Keep code-generation output compact and machine-extractable."""

    from model.framing import output_contract
    return output_contract("rtl")



def build_initial_prompt(public_problem: dict[str, Any]) -> str:
    task_context = _model_task_context(public_problem)
    return (
        "Generate synthesizable RTL for the following public task.\n\n"
        + _rtl_output_contract()
        + "\nPUBLIC TASK CONTEXT\n"
        + json.dumps(task_context, ensure_ascii=False, indent=2)
        + "\n\nPUBLIC IMPLEMENTATION CHECKLIST\n"
        + "- Follow the public clock and reset timing exactly. If reset is synchronous, use only `posedge clk` in sequential sensitivity lists; never add `or posedge reset` or another asynchronous reset event.\n"
        + "- For a registered output defined from the input sampled on the current rising edge, compute the next state including that current input before updating the stored state.\n"
    )



# Candidate-search uses the single stage-context assembly path below.
def _stage_instruction(role: str) -> str:
    if role in {"analyst", "rebuild"}:
        opening = ("Analyze implementation-changing semantics in the public task. " if role == "analyst" else
                   "Reassess the failed candidate using its bound validation evidence and prior analysis. ")
        instruction = (
            opening + "Do not write RTL or repeat the interface or whole task. " + output_contract("analyst") +
            "Return implementation_notes and ambiguities arrays; empty arrays are valid. By default return 0-4 implementation-changing notes, with only essential ambiguities; empty arrays are valid. Retain only relationships that change RTL. Where genuinely supported, distinguish a plausible incorrect relationship from the source-supported one; do not manufacture a risk or contrast. Use an existing example only when it distinguishes these implementations. Omit generic reminders and repeated requirements. "
            "Focus on cycle/state relations, competing condition priorities, boundaries and short examples that distinguish plausible implementations. "
            "Each note requires statement, requirement_refs, source_quote, basis (explicit|inferred); optional example requires given and expected. "
            "Explicit means directly stated by the task; inferred means your reasoning, not a new requirement. "
            "Each ambiguity requires question, implementation_impact, requirement_refs and source_quote; include only unresolved source ambiguity that changes implementation. "
            "Copy source_quote from a continuous referenced source span, allowing whitespace differences only. Never paraphrase quotes or bridge unreferenced lines. "
            "Do not invent ports, reset behavior, latency or unspecified defaults. A matching quote proves provenance, not the statement or example. "
            "All semantic conclusions and examples remain advisory and are not validated tests. "
        )
        if role == "rebuild":
            instruction += (
                "Also return reassessment: prior_interpretation, feedback_observation, evidence_sufficient (boolean), "
                "interpretation_change, next_attempt_change. Use previous_attempt (candidate, revision_id, source_hash) and DERIVED_SPEC to distinguish observed code from your earlier assumptions. "
                "Say exactly what evidence contradicts the prior interpretation, what source supports the proposed change, and what the next implementation should change. "
                "If evidence is insufficient, set evidence_sufficient=false and explicitly state the uncertainty; do not fabricate a root cause. "
                "Read attempted_methods and do not repeat an unsuccessful derivation without new evidence. A strategy-name change alone is not a new interpretation."
            )
        return instruction
    if role == "synthesizer":
        return (
            "Implement exactly the requested module. Applicable checks are conditional suggestions, not executed validations. Keep the public interface unchanged. "
            "Use explicit truth/state tables literally before simplifying. Follow the supplied derivation procedure internally; do not output an extra analysis report. For source-supported sequential behavior derive next values, hold conditions, priority and output timing; for arithmetic check widths, signed extension and truncation. Apply only relationships actually present in the task. "
            
            "Use relevant implementation_notes and examples as advisory implementation guidance. Original source wins on conflict; ambiguities do not authorize invented requirements. If present, consider reassessment.next_attempt_change subject to its evidence limits.\n" + _rtl_output_contract()
        )
    if role == "reviewer":
        return (
            "Review the candidate for concrete specification violations relevant to its bound validation feedback. "
            "Do not rewrite RTL. Independently compare original source, candidate and observations; prior Analyst interpretations are intentionally hidden. candidate_numbered is a display view: line prefixes are not source, and candidate_excerpt must copy the original source lines without display prefixes. The complete source is supplied once in candidate_numbered. " + output_contract("reviewer") +
            "Return issues (at most 4) and limitations (at most 3). Empty arrays are valid; do not invent findings to fill a quota. "
            "Each issue requires id, requirement_refs, source_quote, candidate_location (integer start_line/end_line, 1-based inclusive), "
            "candidate_excerpt, trigger_condition, expected_behavior, predicted_behavior and reasoning. "
            "Explain the conflict between an explicit source requirement and this exact candidate, with a distinguishing condition. "
            "Copy source_quote from continuous referenced source lines (whitespace differences only). Copy candidate_excerpt exactly from the specified code lines, preserving spaces, operators and strings. "
            "Predicted behavior is your code-reading inference, not an executed observation. Actual observations come only from evidence. "
            "Prioritize the supplied failure evidence. Aggregate mismatch counts do not establish an input, signal, failing cycle or root cause; never fabricate one. "
            "Applicable checks are reminders, not the limit of the review; inspect other source-supported contradictions too. "
            "Analyst notes and examples are unverified advice, not grounds for a defect without original-source and candidate support. "
            "Report no style preferences, optional features or generic potential risks. Do not invent clock/reset/latency requirements. "
            "If you cannot localize a supported issue, return issues=[] and explain evidence limits in limitations. An empty review does not mean the candidate is correct."
        )
    if role == "repairer":
        return (
            "Repair the current candidate against the original task and structured validator evidence. Applicable checks are reminders, not the limit of the repair and not executed validations. Inspect other source-supported defects even when absent from the checklist. "
            "Use the sequence observed evidence -> root-cause hypothesis -> source-required relationship -> necessary code change. Distinguish a hypothesis from an observed fact; if evidence is insufficient, recheck source/code without inventing a failing signal or cycle. Preserve the public interface. Make the smallest necessary change, but do not retain an incorrect "
            "interpretation to minimize the diff. Reviewer findings and predicted_behavior are unverified hypotheses. Assess their source and code reasoning against the original task before editing; do not treat a matching quote or excerpt as proof. An unavailable or empty review does not mean the candidate passed. An aggregate mismatch "
            "count does not establish a signal, cycle or root cause. Do not invent one. "
            "Check that the edit introduces no unspecified state, latency, reset or priority change. Use relevant Analyst notes as advice, never as certified tests or requirements. Follow source-supported applicable checks.\n" + _rtl_output_contract()
        )
    raise ValueError(f"unsupported model role: {role}")


def stage_instruction(role: str) -> str:
    instruction=_stage_instruction(role)
    kind=role if role in {"analyst","rebuild"} else "reviewer" if role=="reviewer" else None
    if kind:
        from ..contracts.schemas import SCHEMAS
        instruction += "\nOUTPUT_SCHEMA (closed objects; all listed required fields must be present)\n"+json.dumps(SCHEMAS[kind],separators=(",",":"))
    return instruction
