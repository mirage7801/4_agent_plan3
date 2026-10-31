"""Conservative source-backed features; model suggestions cannot set routing facts."""
from __future__ import annotations

import re
from typing import Any


def _statements(text: str) -> list[tuple[str, list[str]]]:
    result, paragraph, refs = [], [], []
    def flush() -> None:
        if paragraph:
            for sentence in re.split(r"(?<=[.!?])\s+", " ".join(paragraph)):
                if re.match(r"(?:background\s*:|this module is (?:a )?part of|in the larger system)", sentence, re.I):
                    continue
                result.append((sentence, list(refs)))
        paragraph.clear(); refs.clear()
    for i, line in enumerate(text.splitlines(), 1):
        if not line.strip(): flush(); continue
        # Interface declarations alone never establish signal behavior.
        if re.match(r"\s*(?:[-*]\s*)?(?:input|output|inout)\b|\s*Ports\s*:", line, re.I):
            flush(); continue
        paragraph.append(line.strip()); refs.append(f"R{i:04d}")
    flush()
    return result


def extract_profile(text: str, ports: list[dict[str, Any]]) -> dict[str, Any]:
    statements = _statements(text)
    def find(pattern: str) -> list[str]:
        return list(dict.fromkeys(r for sentence, refs in statements
            if not re.search(r"\b(?:not|never|no)\s+(?:(?:a|on|the|at|update|sample|trigger|change)\s+)*(?:"+pattern+r")", sentence, re.I)
            and re.search(pattern, sentence, re.I) for r in refs))
    def field(value: Any, refs: list[str], status: str | None = None) -> dict[str, Any]:
        refs = list(dict.fromkeys(refs))
        return {"value": value, "status": status or ("source_checked" if refs else "unknown"), "requirement_refs": refs}

    comb = find(r"\b(?:pure(?:ly)?\s+combinational|combinational\s+(?:logic\s+)?(?:portion|part|circuit|logic))\b")
    comb_only = find(r"\b(?:implement|build|design)\s+only\b.{0,180}\bcombinational\b")
    edge = find(r"\b(?:posedge|negedge|rising edge|falling edge|positive edge|negative edge)\b")
    sequential = find(r"\b(?:sequential logic|clocked process|registered output|pipeline register|registers?\s+(?:for|to)\s+(?:state|storage))\b")
    if comb_only:
        scope = field("combinational", comb_only)
    elif edge or sequential:
        scope = field("sequential", edge+sequential)
    elif comb:
        scope = field("combinational", comb)
    else:
        scope = field("unknown", [])
    component_refs = find(r"\b(?:state transition logic|next.state logic|combinational logic portion)\b")
    component = field("next_state_logic", component_refs) if component_refs and scope["value"]=="combinational" else field("unknown", [])
    families = [
        ("popcount", r"\b(?:population count|popcount)\s+(?:circuit|function)|\bcount(?:s)?\s+the number of\s+['\"]?1"),
        ("priority_encoder", r"\bpriority encoder\b"),
        ("fifo", r"\b(?:implement|build|design)\b.{0,80}\b(?:fifo|queue)\b"),
        ("counter", r"\b(?:counter circuit|implement a counter|binary counter)|\bincrements?\b.{0,70}\bmodulo\b"),
        ("fsm", r"\b(?:state transition table|state transition logic|next.state logic|finite state machine)\b"),
    ]
    matches = [(name,find(pattern)) for name,pattern in families]
    matches = [(name,refs) for name,refs in matches if refs]
    family = field(matches[0][0],matches[0][1]) if len(matches)==1 else field("unknown", [], "conflict" if matches else "unknown")

    patterns = {
        "reset_behavior": r"\b(?:reset|rst|areset)\b.{0,90}\b(?:clear|zero|active|synchronous|asynchronous|assert|initial)|\b(?:synchronous|asynchronous|active.high|active.low)\b.{0,45}\b(?:reset|rst|areset)\b",
        "reset_priority": r"\breset\b.{0,65}\b(?:priority|overrides|takes precedence)|\b(?:priority|precedence)\b.{0,45}\breset\b",
        "priority": r"\b(?:highest|lowest|first)\b.{0,50}\b(?:priority|bit)|\bpriority encoder\b",
        "enable": r"\b(?:when|if|otherwise)\b.{0,55}\benable\b",
        "output_latency": r"\b(?:latency|one.cycle delay|delayed by|output.{0,35}cycles? later)\b",
        "illegal_states": r"\b(?:illegal|unused|invalid)\s+states?\b.{0,70}\b(?:must|shall|return|transition|set|output)|\b(?:must|shall)\b.{0,70}\b(?:illegal|unused|invalid)\s+states?\b",
        "parameter_range": r"\b(?:parameter|width|depth)\b.{0,65}\b(?:at least|between|range|minimum|maximum|>=|<=)\b",
        "collision": r"\b(?:simultaneous|same cycle|both)\b.{0,80}\b(?:read|write)\b.{0,80}\b(?:must|shall|accepted|ignored|return|hold|unchanged)\b",
        "state_transitions": r"\b(?:state transition table|state transition logic|next.state logic)\b",
        "overflow": r"\b(?:overflow|wraparound|wraps around)\b",
    }
    features = {name:field(True if (refs:=find(pattern)) else None,refs) for name,pattern in patterns.items()}
    table_refs = [f"R{i:04d}" for i,line in enumerate(text.splitlines(),1) if "|" in line]
    features["public_table"] = field(True if table_refs else None,table_refs)
    for feature, pattern in {
        "reset_behavior":r"\b(?:no reset|reset is not (?:required|used)|without (?:a )?reset)\b",
        "illegal_states":r"\b(?:illegal|invalid|unused) states?\b.{0,60}\b(?:unspecified|unconstrained|don't care|not required)\b",
    }.items():
        refs=find(pattern)
        if refs: features[feature]=field(None,refs,"not_applicable")

    # Resolve a named edge from source, not from a clock-looking port name.
    inputs = {p["name"] for p in ports if p.get("direction")=="input"}
    clocks=[]
    for sentence,refs in statements:
        for match in re.finditer(r"\b(posedge|negedge)\s+(\w+)|\b(rising|falling|positive|negative)\s+edge\s+(?:of\s+)?(?:the\s+)?(?:signal\s+)?(\w+)",sentence,re.I):
            if re.search(r"\b(?:not|never|no)\s+(?:(?:on|the|at|update|sample|trigger|change)\s+)*$",sentence[:match.start()],re.I):
                continue
            edge_word=match.group(1) or match.group(3); name=match.group(2) or match.group(4)
            if name in inputs:
                clocks.append({"signal":name,"edge":"rising" if edge_word.lower() in {"posedge","rising","positive"} else "falling", "requirement_refs":refs})
    if clocks and (comb_only or find(r"\bpure(?:ly)? combinational\b")):
        scope=field("unknown",scope["requirement_refs"]+edge,"conflict")
    if component["value"]=="unknown" and scope["value"]=="sequential":
        component=field("full_module",scope["requirement_refs"])
    if scope["status"] == "conflict":
        component = field("unknown", scope["requirement_refs"], "conflict")
    features["clocked"] = (field(None, scope["requirement_refs"], "conflict")
                           if scope["status"] == "conflict" else
                           field(True, scope["requirement_refs"]) if scope["value"] == "sequential" else
                           field(None, []))
    reset_refs=features["reset_behavior"]["requirement_refs"]
    reset={"status":features["reset_behavior"]["status"],"requirement_refs":reset_refs,
           "polarity":"unknown","synchrony":"unknown"}
    if reset["status"]=="source_checked":
        reset_text=" ".join(s for s,r in statements if set(r)&set(reset_refs))
        for key,options in {
            "polarity":[(r"\bactive.high\b","active_high"),(r"\bactive.low\b","active_low")],
            "synchrony":[(r"\bsynchronous\b","synchronous"),(r"\basynchronous\b","asynchronous")],
        }.items():
            values={value for pattern,value in options for match in re.finditer(pattern,reset_text,re.I)
                    if not re.search(r"\b(?:not|never)\s+$",reset_text[:match.start()],re.I)}
            reset[key]=next(iter(values)) if len(values)==1 else "unknown"
    return {"schema_version":"1.0","implementation_scope":scope,"requested_component":component,
            "functional_family":family,"clocking":clocks,"reset":reset,"features":features,
            "method":"deterministic_source_patterns","semantic_completeness_proven":False}


def profile_for(facts: dict[str, Any]) -> dict[str, Any]:
    profile=extract_profile(facts["source"]["raw_text"],facts["interface"]["ports"])
    profile["facts_ref"]=facts["facts_id"]
    validate_profile(profile, facts)
    return profile


def validate_profile(profile, facts):
    """Validate both shape and dependencies after all source conflicts resolve."""
    from ..contracts.schemas import validate, PROFILE, validate_references, ContractError
    validate(profile, PROFILE)
    validate_references(profile, facts)
    scope = profile["implementation_scope"]
    clocked = profile["features"]["clocked"]
    component = profile["requested_component"]
    if scope["status"] == "conflict":
        if clocked["value"] is not None or clocked["status"] != "conflict" or component["value"] != "unknown" or component["status"] != "conflict":
            raise ContractError("conflicting scope cannot retain confirmed clocked/component conclusions")
    elif scope["value"] == "sequential":
        if clocked["value"] is not True or clocked["status"] != "source_checked":
            raise ContractError("sequential scope requires source-checked clocked feature")
    elif clocked["value"] is True or component["value"] == "full_module":
        raise ContractError("non-sequential scope cannot assert sequential derived features")


def candidate_plan(profile: dict[str, Any], requested: list[str], limit: int) -> dict[str, Any]:
    """Config supplies preferences; incompatible or unknown strategies cannot run."""
    scope=profile["implementation_scope"]["value"]; family=profile["functional_family"]["value"]
    pool=[("direct", "Direct implementation of the original task; preserve all explicit semantics.")]
    if scope=="combinational":
        if family=="popcount":
            pool += [("popcount_loop","Combinational loop accumulation; preserve the public numeric range."),
                     ("popcount_tree","Equivalent combinational adder tree; do not add pipeline stages.")]
        elif family=="priority_encoder":
            pool += [("priority_chain","Conditional chain using exactly the priority order supported by the original task."),
                     ("priority_case","Equivalent complete case implementation; preserve the same public priority order.")]
        elif profile["features"]["public_table"]["value"] or profile["features"]["state_transitions"]["value"]:
            pool += [("table_case","Direct combinational implementation of every public table row; add no state storage."),
                     ("table_equations","Equivalent combinational equations preserving every public table row and encoding.")]
        else:
            pool += [("combinational_equations","Equivalent combinational expressions, preserving the public interface and behavior.")]
    elif scope=="sequential":
        if family=="counter": pool += [("counter_update","Explicit register-update equations matching the stated reset, enable and terminal behavior.")]
        elif family=="fsm": pool += [("fsm_explicit","Explicit state/update/output structure; preserve specified encoding and output cycles.")]
        else: pool += [("register_updates","Explicit register-update equations using only timing relationships required by the original task.")]
    else:
        pool += [("constraint_derivation", "Independently derive the relationships explicitly required for each output, boundaries and simultaneous conditions before implementation. Determine storage/timing only from the original source; unknown scope is not combinational or sequential by default. Add no clock, reset, state or latency.")]
    procedures = {
        "register_updates": " For each required register determine pre-edge value, current sampled inputs, next value, hold condition and output observation time. Resolve only source-specified reset/enable priority; do not add registers.",
        "counter_update": " Derive next-value equations including hold, terminal boundary, wrap and simultaneous controls where specified. Check expression width and observation cycle.",
        "fsm_explicit": " Enumerate every specified state's input conditions, transitions and output conditions. Distinguish current-state from next-state output and preserve specified encoding; do not invent illegal-state policy.",
        "table_case": " Cover each original table row and specified don't-care before simplifying; preserve requested storage scope.",
        "table_equations": " Independently derive each output's true conditions from all source rows, then check row coverage and overlap before simplifying.",
        "combinational_equations": " Derive each output's conditions and boundary values independently. For arithmetic, determine operand/expression widths, signed extension and assignment truncation. Add no storage.",
        "popcount_loop": " Establish the output numeric range and accumulator width; check zero and all-one inputs without pipeline latency.",
        "popcount_tree": " Derive intermediate and final sum ranges and widths at each tree level; check zero and all-one boundaries without pipeline stages.",
        "priority_chain": " Enumerate simultaneously asserted conditions and apply only the original stated ordering, including the specified no-hit result.",
        "priority_case": " Build complete, source-supported priority conditions and verify overlapping assertions preserve ordering.",
    }
    pool=[(name,instruction+procedures.get(name,"")) for name,instruction in pool]
    aliases={"direct behavioral RTL":"direct","explicit FSM/state machine":"fsm_explicit","counter/datapath decomposition":"counter_update"}
    indexed=dict(pool); rejected=[]; selected=[]
    for name in requested:
        name=aliases.get(name,name)
        if name=="auto":
            for item in pool:
                if item[0] not in [x[0] for x in selected]: selected.append(item)
        elif name in indexed:
            if name not in [x[0] for x in selected]: selected.append((name,indexed[name]))
        else: rejected.append({"strategy":name,"reason":"unknown_or_incompatible_with_source_profile"})
    if not selected: selected=[pool[0]]
    selected=selected[:max(1,min(limit,4))]
    return {"facts_ref":profile.get("facts_ref"),"scope":scope,"family":family,
            "selected":[{"id":name,"instruction":instruction} for name,instruction in selected],"rejected":rejected}
