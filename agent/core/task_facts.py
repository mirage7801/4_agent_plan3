"""Source-backed task facts. Frozen content is checked before every handoff."""
from __future__ import annotations

import copy
import hashlib
import json
import re
from pathlib import Path
from typing import Any

from .storage import atomic_write_json
from model.rtl_lex import mask_noncode, module_header, module_declarations, constant_integer, preprocessing_sensitive
from ..contracts.schemas import check, loads, validate_references, ContractError
from .task_profile import extract_profile, profile_for


class FactsError(ValueError):
    """Facts are inconsistent, modified, or do not match a candidate binding."""


def content_hash(value: Any) -> str:
    return hashlib.sha256(json.dumps(value, ensure_ascii=False, sort_keys=True,
                                    separators=(",", ":")).encode("utf-8")).hexdigest()


def parse_ports(text: str) -> list[dict[str, Any]]:
    """Conservative public-interface parser; unresolved syntax stays in source."""
    ports: dict[str, dict[str, Any]] = {}
    has_bullets = bool(re.search(r"^\s*[-*]\s*(?:input|output|inout)\b", text, re.M))
    has_ports_line = bool(re.search(r"^\s*Ports\s*:", text, re.M | re.I))
    # Both public bullet lists and ANSI/Ports: declarations are supported.
    for line_no, line in enumerate(text.splitlines(), 1):
        if has_bullets and not re.match(r"\s*[-*]\s*(?:input|output|inout)\b", line):
            continue
        if not has_bullets and has_ports_line and not re.match(r"\s*Ports\s*:", line, re.I):
            continue
        if not re.search(r"^\s*(?:[-*]\s*)?(?:input|output|inout)\b|^\s*Ports\s*:", line, re.I) and not module_declarations(line):
            continue
        pattern = r"\b(input|output|inout)\s+([^;\n]+?)(?=\b(?:input|output|inout)\b|;|$)"
        for match in re.finditer(pattern, line):
            direction, body = match.groups()
            signed = bool(re.search(r"\bsigned\b", body))
            body = re.sub(r"\b(?:wire|reg|logic|unsigned|signed)\b", "", body).strip()
            width: int | str = 1
            width_match = re.search(r"\[\s*([^]:]+)\s*:\s*([^]]+)\]", body)
            if width_match:
                left, right = (x.strip() for x in width_match.groups())
                a,b=constant_integer(left),constant_integer(right)
                width = abs(a-b)+1 if a is not None and b is not None else width_match.group(0)
                body = body[:width_match.start()] + body[width_match.end():]
            bit_match = re.search(r"\(\s*(\d+)\s+bits?\s*\)", body, re.I)
            if bit_match:
                width = int(bit_match.group(1)); body = body[:bit_match.start()]
            # Avoid parsing surrounding prose or the module closing punctuation.
            for name in body.rstrip(" .)").split(","):
                name = name.strip()
                if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*", name): continue
                port = {"name": name, "direction": direction, "width": width,
                        "signed": signed, "source_refs": [f"R{line_no:04d}"]}
                if name in ports and any(ports[name][k] != port[k] for k in ("direction", "width", "signed")):
                    raise FactsError(f"conflicting public port declarations: {name}")
                ports[name] = port
    return list(ports.values())


def build_task_facts(public: dict[str, Any], version: int = 1) -> dict[str, Any]:
    text = str(public["public_problem"])
    requirements = [{"id": f"R{i:04d}", "source_lines": [i, i], "status": "explicit_source"}
                    for i, line in enumerate(text.splitlines(), 1) if line.strip()]
    ports = parse_ports(text)
    profile = extract_profile(text, ports)
    kind = profile["implementation_scope"]["value"]
    facts = {
        "schema_version": "2.0", "facts_version": version,
        "source": {"raw_text": text, "sha256": hashlib.sha256(text.encode()).hexdigest(),
                   "task_version": public.get("task_version", "unversioned")},
        "interface": {"module": public["top_module"], "language": public["language"],
                      "ports": ports, "ports_status": "parsed" if ports else "unresolved"},
        "scope": {"implementation_kind": kind if kind != "unknown" else "unspecified",
                  "source_refs": profile["implementation_scope"]["requirement_refs"]},
        "requirements": requirements,
        # Tables and examples remain losslessly in raw_text; references avoid
        # storing a second, potentially divergent transcription.
        "explicit_tables": [r["id"] for r in requirements if "|" in text.splitlines()[r["source_lines"][0]-1]],
        "explicit_examples": [r["id"] for r in requirements if re.search(r"example|e\.g\.", text.splitlines()[r["source_lines"][0]-1], re.I)],
        "unresolved_questions": [] if ports else [{"kind": "interface_parse", "action": "use_original_interface_text"}],
        "verification": {"method": "deterministic_public_source", "source_preserved": True,
                         "interface_checked": bool(ports), "semantic_completeness_proven": False},
    }
    facts["facts_id"] = content_hash(facts)
    verify_facts(facts)
    return facts


def verify_facts(facts: dict[str, Any], expected_id: str | None = None) -> None:
    try:
        check("task_facts",facts)
        validate_references(facts,facts)
        ids=[x["id"] for x in facts["requirements"]]
        if len(ids)!=len(set(ids)): raise ContractError("duplicate requirement id")
        lines=facts["source"]["raw_text"].splitlines()
        for item in facts["requirements"]:
            start,end=item["source_lines"]
            if not 1<=start<=end<=len(lines): raise ContractError("source line range out of bounds")
        if any(x not in ids for x in facts["explicit_tables"]+facts["explicit_examples"]): raise ContractError("invalid table/example reference")
        names=[x["name"] for x in facts["interface"]["ports"]]
        if len(names)!=len(set(names)): raise ContractError("duplicate port name")
    except ContractError as exc: raise FactsError(str(exc)) from exc
    body = {k: v for k, v in facts.items() if k != "facts_id"}
    if facts.get("facts_id") != content_hash(body) or (expected_id and expected_id != facts.get("facts_id")):
        raise FactsError("task facts content/version mismatch")
    if hashlib.sha256(facts["source"]["raw_text"].encode()).hexdigest() != facts["source"]["sha256"]:
        raise FactsError("original public source hash mismatch")


def freeze_facts(path: Path, facts: dict[str, Any]) -> None:
    verify_facts(facts)
    if path.exists():
        current = loads(path.read_text(encoding="utf-8"))
        if current != facts: raise FactsError("cannot overwrite frozen task facts; create a new version")
        return
    atomic_write_json(path, facts)


def source_for(facts: dict[str, Any], refs: list[str]) -> str:
    indexed = {r["id"]: r for r in facts["requirements"]}
    lines = facts["source"]["raw_text"].splitlines()
    return "\n".join("\n".join(lines[indexed[r]["source_lines"][0]-1:indexed[r]["source_lines"][1]])
                     for r in refs if r in indexed)


def normalized_source(text):
    """Normalize layout only; preserve every non-whitespace character."""
    return " ".join(text.split())


def source_quote_matches(facts, refs, quote):
    """Match inside a single continuous union of referenced source lines."""
    indexed = {r["id"]: r["source_lines"] for r in facts["requirements"]}
    ranges = sorted(set(tuple(indexed[r]) for r in refs if r in indexed))
    spans = []
    for start, end in ranges:
        if spans and start <= spans[-1][1] + 1:
            spans[-1][1] = max(spans[-1][1], end)
        else:
            spans.append([start, end])
    lines = facts["source"]["raw_text"].splitlines()
    target = normalized_source(quote)
    return bool(target) and any(target in normalized_source("\n".join(lines[start-1:end])) for start, end in spans)


def build_derived(facts: dict[str, Any], proposal: dict[str, Any] | None, version: int = 1) -> dict[str, Any]:
    """Check source provenance per item; never certify model semantics or examples."""
    notes, ambiguities, rejected = [], [], []
    if proposal is not None:
        check("rebuild" if "reassessment" in proposal else "analyst", proposal)
    proposal = proposal or {}
    known = {r["id"] for r in facts["requirements"]}
    for collection, accepted in (("implementation_notes", notes), ("ambiguities", ambiguities)):
        for index, item in enumerate(proposal.get(collection, [])):
            refs, quote = item["requirement_refs"], item["source_quote"]
            reason = ("unknown_requirement_reference" if any(r not in known for r in refs) else
                      "source_quote_mismatch" if not source_quote_matches(facts, refs, quote) else None)
            if reason:
                # Raw rejected content stays in call audit/answer, never in model context.
                rejected.append({"collection": collection, "index": index, "reason": reason})
                continue
            exact = quote in source_for(facts, refs)
            accepted.append({**copy.deepcopy(item),
                             "source_check": "exact_source_match" if exact else "source_match_whitespace_normalized",
                             "semantic_status": "unverified"})
    result = {"schema_version": "3.0", "derived_version": version, "facts_ref": facts["facts_id"],
              "implementation_notes": notes, "ambiguities": ambiguities,
              "reassessment": copy.deepcopy(proposal.get("reassessment")),
              "rejected": rejected, "task_profile": profile_for(facts)}
    check("derived_spec", result)
    validate_references(result, facts)
    return result



def candidate_interface_report(source: str, facts: dict[str, Any]) -> dict[str, Any]:
    """Only complete, supported declarations can prove an interface mismatch."""
    unknown=lambda reason: {"status":"unknown","issues":[],"reason":reason}
    if preprocessing_sensitive(source): return unknown("requires_preprocessing")
    header=module_header(source,facts["interface"]["module"])
    expected=facts["interface"]["ports"]
    if header is None or not expected: return unknown("unresolved_public_or_candidate_interface")
    # Split commas outside dimensions/expressions. No partial-list comparisons.
    chunks=[];start=depth=0
    for i,char in enumerate(header):
        if char in '([': depth+=1
        elif char in ')]': depth-=1
        elif char==',' and depth==0: chunks.append(header[start:i]);start=i+1
    chunks.append(header[start:])
    actual=[];direction=None;width=1;signed=False
    for chunk in chunks:
        match=re.fullmatch(r"\s*(?:(input|output|inout)\s+)?(?:(wire|reg|logic)\s+)?(?:(signed|unsigned)\s+)?(\[[^]\n]+\]\s*)?([A-Za-z_][A-Za-z0-9_$]*)\s*",chunk)
        if not match: return unknown("unsupported_or_partial_port_declaration")
        d,typ,sign,dimension,name=match.groups()
        if d:
            direction=d;signed=sign=='signed';width=1
            if dimension:
                parts=dimension.strip()[1:-1].split(':')
                if len(parts)!=2: return unknown("unsupported_dimension")
                left,right=map(constant_integer,parts)
                if left is None or right is None: return unknown("unresolved_width")
                width=abs(left-right)+1
        elif direction is None or typ or sign or dimension: return unknown("non_ansi_or_unsupported_inheritance")
        actual.append({"name":name,"direction":direction,"width":width,"signed":signed})
    if any(type(p['width']) is not int for p in expected): return unknown("unresolved_public_width")
    errors=[]
    if len({p['name'] for p in actual})!=len(actual): return unknown("duplicate_port_declaration")
    if {p['name'] for p in expected}!={p['name'] for p in actual}: errors.append("public interface port names changed")
    amap={p['name']:p for p in actual}
    for port in expected:
        other=amap.get(port['name'])
        if other and any(port[k]!=other[k] for k in ('direction','width','signed')):
            errors.append(f"public interface changed: {port['name']}")
    return {"status":"mismatch" if errors else "match","issues":errors,"reason":"complete_supported_ansi_interface"}


def check_candidate_interface(source: str, facts: dict[str, Any]) -> list[str]:
    errors=candidate_interface_report(source,facts)['issues'][:]
    if not preprocessing_sensitive(source) and facts['scope']['implementation_kind']=='combinational' and re.search(r"\b(?:posedge|negedge|always_ff|always_latch)\b",mask_noncode(source)):
        errors.append("R_SCOPE: combinational request cannot add sequential or latch logic")
    return errors


def validate_candidate_binding(candidate: str, binding: dict[str, Any]) -> None:
    """Validate a controller-authored identity against the exact immutable source."""
    check("candidate_binding", binding)
    if not isinstance(candidate, str) or hashlib.sha256(candidate.encode("utf-8")).hexdigest() != binding["source_hash"]:
        raise FactsError("candidate source hash mismatch")


def filter_review(review: dict[str, Any] | None, facts: dict[str, Any], candidate: str | None = None,
                  *, candidate_binding: dict[str, Any] | None = None) -> dict[str, Any]:
    """Accept provenance and locations per item, never certify a model's diagnosis."""
    accepted, rejected = [], []
    if candidate_binding is not None:
        validate_candidate_binding(candidate, candidate_binding)
    if review is not None:
        check("reviewer", review)
        if candidate_binding is None:
            raise FactsError("review requires a bound candidate")
        known = {r["id"] for r in facts["requirements"]}
        lines = candidate.replace("\r\n", "\n").replace("\r", "\n").splitlines()
        seen = set()
        for index, issue in enumerate(review["issues"]):
            refs, quote, loc = issue["requirement_refs"], issue["source_quote"], issue["candidate_location"]
            excerpt = issue["candidate_excerpt"].replace("\r\n", "\n").replace("\r", "\n")
            reason = None
            if issue["id"] in seen: reason = "duplicate_issue_id"
            elif any(r not in known for r in refs): reason = "unknown_requirement_reference"
            elif not source_quote_matches(facts, refs, quote): reason = "source_quote_mismatch"
            elif not 1 <= loc["start_line"] <= loc["end_line"] <= len(lines): reason = "invalid_candidate_location"
            elif not excerpt.strip() or excerpt not in "\n".join(lines[loc["start_line"]-1:loc["end_line"]]): reason = "candidate_excerpt_mismatch"
            elif not all(issue[k].strip() for k in ("trigger_condition","expected_behavior","predicted_behavior","reasoning")): reason = "empty_issue_content"
            if reason is None and facts["scope"]["implementation_kind"] == "combinational":
                # Retain the existing conservative scope guard; it is not a semantic proof.
                claim_text = issue["expected_behavior"] + " " + issue["reasoning"]
                clock_change = re.search(r"\b(?:add|introduce|missing|lack\w*)\b.{0,45}\b(?:clock|clk)\b", claim_text, re.I)
                reset_change = re.search(r"\b(?:add|introduce|missing|lack\w*)\b.{0,45}\b(?:reset|rst)\b", claim_text, re.I)
                reset_required = profile_for(facts)["features"]["reset_behavior"]["status"] == "source_checked"
                if clock_change or (reset_change and not reset_required): reason = "conflicts_with_combinational_scope"
            seen.add(issue["id"])
            if reason:
                rejected.append({"index": index, "id": issue["id"], "reason": reason})
                continue
            accepted.append({**copy.deepcopy(issue),
                             "source_check": "exact_source_match" if quote in source_for(facts, refs) else "source_match_whitespace_normalized",
                             "candidate_check": "exact_candidate_excerpt", "semantic_status": "unverified"})
    result = {"status": "unavailable" if review is None else "findings_available" if accepted else "no_supported_findings",
              "candidate_binding": copy.deepcopy(candidate_binding), "issues": accepted,
              "limitations": copy.deepcopy(review["limitations"]) if review is not None else [], "rejected_issues": rejected}
    check("filtered_review", result)
    validate_references(result, facts)
    return result
