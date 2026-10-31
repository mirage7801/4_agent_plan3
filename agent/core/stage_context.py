"""One prompt assembly path; persisted handoffs contain increments and references."""
from __future__ import annotations

import copy
import hashlib
import json
from pathlib import Path
from typing import Any

from .storage import atomic_write_json
from .task_facts import FactsError, verify_facts, validate_candidate_binding
from .task_profile import validate_profile
from .feedback import diagnostic_warning_view
from ..contracts.schemas import check as schema_check, loads, validate_references, ROLE_KEYS


AUTHORITY = """AUTHORITY AND CONTEXT RULES
Original public specification and interface > independently source-checked constraints > model analysis, reviewer, templates and memory.
Do not add ports, clocks, resets, latency or triggering conditions without source support.
If sources conflict, report the conflict; never silently change the task facts.
Validation evidence records observations about a candidate; it does not redefine the specification.
All Analyst implementation_notes, examples, ambiguities, reassessments and reviewer findings are advisory, not requirements.
Evidence diagnostic_coverage describes only available safe warning messages. Partial means omitted or shortened information; never claim all errors were inspected. Shortened messages may lose detail; do not invent missing content. Explicit required_warning_lines survive every later compression.
Structured signal values use hexadecimal digits without a prefix; x/z are allowed.
execution_trace is supplied only by the validator safe projection; missing initialization, ordering or sampling leaves replay insufficient. Public diagnostics are executed literal public cases only, never whole-task acceptance. relationship_summary records unverified intent, not certified implementation behavior.
source_check certifies quote provenance only; semantic_status=unverified means no implication or example correctness was proved.
An Analyst ambiguity is not a new requirement. Never treat an Analyst example as a validated test.
The specification source.numbered_text uses stable requirement IDs before " | "; these prefixes are display labels, not source text. Copy quotes without labels. L labels denote blank source lines and are not requirement IDs.
Do not restate task facts in handoffs; reference requirement IDs and return only new findings.
"""

_ALLOWED = {role: set(keys) for role, keys in ROLE_KEYS.items()}


def numbered_candidate(candidate):
    return "\n".join(f"{index}: {line}" for index, line in enumerate(candidate.replace("\r\n", "\n").replace("\r", "\n").splitlines(), 1))


def model_delta(delta):
    """Bound model-only feedback after all structured diagnostics were extracted."""
    delta = copy.deepcopy(delta)
    evidence = delta.get("evidence")
    if evidence:
        diagnostic_warning_view(evidence)
    return delta


def compact_prompt(prompt, level):
    """Drop optional guidance only; original task, candidate and core evidence stay."""
    prefix, rest = prompt.split("\nTASK_FACTS\n", 1)
    facts_text, rest = rest.split("\n\nDERIVED_SPEC\n", 1)
    derived_text, delta_text = rest.split("\n\nSTAGE_DELTA\n", 1)
    facts, derived, delta = loads(facts_text), loads(derived_text), model_delta(loads(delta_text))
    if "candidate" in delta:
        delta.pop("candidate_numbered", None)
    delta.pop("memory", None)
    if level >= 2:
        derived["implementation_notes"] = []
        derived["ambiguities"] = []
        if "evidence" in delta:
            old = delta["evidence"].get("warnings", [])
            delta["evidence"]["warnings"] = []
            delta["evidence"]["warnings_omitted"] = delta["evidence"].get("warnings_omitted", 0) + len(old)
            coverage=delta["evidence"].get("diagnostic_coverage")
            if old and coverage:
                required=delta["evidence"]["required_warning_lines"]
                # Original retained ordering is required-first by rank, except
                # the fallback first warning. Identify omitted metadata by index.
                kept_count=len(required)
                dropped=coverage['retained'][kept_count:]
                coverage['retained']=coverage['retained'][:kept_count]
                coverage['omitted_ids']=(coverage['omitted_ids']+[r['id'] for r in dropped])[:136]
                coverage['retained_count']=len(coverage['retained'])
                coverage['shortened_count']=sum(r['shortened'] for r in coverage['retained'])
                coverage['omitted_count']+=len(dropped)
                coverage['status']='partial'
                if 'optional_context_compaction' not in coverage['reasons']:coverage['reasons'].append('optional_context_compaction')
    return prefix + "\nTASK_FACTS\n" + json.dumps(facts,ensure_ascii=False,separators=(",",":")) + "\n\nDERIVED_SPEC\n" + json.dumps(derived,ensure_ascii=False,separators=(",",":")) + "\n\nSTAGE_DELTA\n" + json.dumps(delta,ensure_ascii=False,separators=(",",":"))


def compact_memory(items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    # Stored original tasks and run paths are not transferable knowledge.
    return [{k: item[k] for k in ("error_type", "stage", "summary") if k in item}
            for item in items[:3] if isinstance(item, dict)]


class StageContext:
    def __init__(self, facts_path: Path):
        self.path = Path(facts_path)
        self.facts_id = self.load()["facts_id"]

    def load(self) -> dict[str, Any]:
        facts = loads(self.path.read_text(encoding="utf-8"))
        verify_facts(facts, getattr(self, "facts_id", None))
        return facts

    def render(self, stage: str, instruction: str, derived: dict[str, Any] | None = None,
               delta: dict[str, Any] | None = None, *, handoff_path: Path | None = None, include_analyst: bool = True) -> str:
        facts = self.load()
        if stage not in _ALLOWED: raise FactsError(f"unsupported stage: {stage}")
        delta = copy.deepcopy(delta or {})
        if 'execution_trace' in delta.get('evidence',{}):
            from .failure_evidence import trace_readiness
            delta['evidence']['replay']=trace_readiness(delta['evidence']['execution_trace'],[p['name'] for p in facts['interface']['ports'] if p['direction']=='input'])
        if stage == "reviewer" and "candidate" in delta:
            expected = numbered_candidate(delta["candidate"])
            if "candidate_numbered" in delta and delta["candidate_numbered"] != expected:
                raise FactsError("candidate numbered view mismatch")
            delta["candidate_numbered"] = expected
        if set(delta) - _ALLOWED[stage]: raise FactsError(f"unexpected {stage} handoff fields")
        if derived:
            schema_check("derived_spec",derived); validate_references(derived,facts)
            validate_profile(derived["task_profile"], facts)
        if derived and (derived.get("facts_ref") != facts["facts_id"] or derived["task_profile"]["facts_ref"] != facts["facts_id"]):
            raise FactsError("derived specification belongs to another facts version")
        # Control artifacts and repeated original task/ports never enter deltas.
        forbidden = {"public_problem", "raw_text", "interface", "ports", "requirements", "testbench", "constraints"}
        def check(value: Any, path: tuple = ()) -> None:
            if isinstance(value, dict):
                if forbidden & set(value): raise FactsError("handoff duplicates facts or includes private asset keys")
                for key, item in value.items(): check(item, path + (key,))
            elif isinstance(value, list):
                for index, item in enumerate(value): check(item, path + (index,))
            elif isinstance(value, str) and facts["source"]["raw_text"].strip() and facts["source"]["raw_text"].strip() in value:
                # A required, bounded review source quote may equal an entire short task.
                # Other delta fields still cannot duplicate the original specification.
                review_quote = (stage == "repairer" and len(path) == 4 and path[:2] == ("review", "issues")
                                and isinstance(path[2], int) and path[3] == "source_quote")
                if not review_quote:
                    raise FactsError("handoff duplicates the original task")
        check(delta)
        binding = {"facts_ref": facts["facts_id"], "facts_version": facts["facts_version"],
                   "derived_ref": derived.get("derived_version") if derived else None}
        handoff={"schema_version":"2.0","stage":stage,**binding,"delta":delta}
        schema_check("handoff_"+stage,handoff)
        validate_references(handoff,facts)
        if stage in {"reviewer", "repairer"}:
            validate_candidate_binding(delta["candidate"], delta["candidate_binding"])
            if "review" in delta and delta["review"]["candidate_binding"] != delta["candidate_binding"]:
                raise FactsError("review belongs to another candidate revision")
        if stage == "rebuild" or "previous_attempt" in delta:
            previous = delta["previous_attempt"]
            if hashlib.sha256(previous["candidate"].encode("utf-8")).hexdigest() != previous["source_hash"]:
                raise FactsError("rebuild previous candidate hash mismatch")
            if "evidence" not in delta:
                raise FactsError("previous candidate requires bound failure evidence")
        if "evidence" in delta:
            previous = delta.get("previous_attempt", {})
            expected_binding = delta.get("candidate_binding") or {k:previous.get(k) for k in ("revision_id","source_hash")}
            if delta["evidence"].get("candidate_binding") != expected_binding or not delta["evidence"].get("validation_id"):
                raise FactsError("failure evidence belongs to another candidate or lacks validation identity")
        if handoff_path:
            atomic_write_json(handoff_path,handoff)
        # Full facts/derived and the full handoff remain on disk. This is a model view.
        fact_view = {k:facts[k] for k in ("facts_id","facts_version","source","interface","scope","requirements")}
        by_line = {r["source_lines"][0]: r["id"] for r in facts["requirements"]}
        fact_view["source"] = {"numbered_text":"\n".join(f"{by_line.get(i, f'L{i:04d}')} | {line}" for i,line in enumerate(facts["source"]["raw_text"].splitlines(),1))}
        derived_view = {k:copy.deepcopy(v) for k,v in (derived or {}).items() if k != "rejected"}
        if derived:
            profile = derived["task_profile"]
            keys = ("implementation_scope", "functional_family", "clocking", "reset")
            if stage in {"analyst", "rebuild", "synthesizer"}: keys += ("requested_component",)
            view = {k:copy.deepcopy(profile[k]) for k in keys}
            view["features"] = {k:copy.deepcopy(v) for k,v in profile["features"].items() if v["status"] != "unknown"}
            view["omitted_feature_status"] = "unknown"
            view["semantic_completeness_proven"] = False
            derived_view["task_profile"] = view
        if stage == "reviewer" or not include_analyst:
            derived_view["implementation_notes"] = []
            derived_view["ambiguities"] = []
            derived_view["reassessment"] = None
        return (instruction + "\n\n" + AUTHORITY + "\nTASK_FACTS\n" + json.dumps(fact_view, ensure_ascii=False,separators=(",",":"))
                + "\n\nDERIVED_SPEC\n" + json.dumps(derived_view, ensure_ascii=False,separators=(",",":"))
                + "\n\nSTAGE_DELTA\n" + json.dumps(model_delta({k:v for k,v in delta.items() if stage != "reviewer" or k != "candidate"}), ensure_ascii=False,separators=(",",":")))

    def binding(self, derived: dict[str, Any] | None = None) -> dict[str, Any]:
        facts = self.load()
        return {"facts_ref": facts["facts_id"], "facts_version": facts["facts_version"],
                "derived_ref": derived.get("derived_version") if derived else None}
