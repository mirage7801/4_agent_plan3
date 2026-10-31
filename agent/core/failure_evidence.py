"""Normalize first-failure and waveform evidence without exposing private assets."""

from __future__ import annotations

import re
from typing import Any


def build_failure_evidence(result: dict[str, Any], feedback: dict[str, Any]) -> dict[str, Any]:
    diagnostics = feedback.get("diagnostics", {}) if isinstance(feedback.get("diagnostics", {}), dict) else {}
    functional = diagnostics.get("functional_mismatch", []) if isinstance(diagnostics, dict) else []
    first: dict[str, Any] = {}
    if isinstance(functional, list) and functional:
        first = functional[0] if isinstance(functional[0], dict) else {}
    public=feedback.get('public_diagnostics',{})
    if not first and public.get('status')=='executed' and public.get('cases'):
        first=next((case for case in public['cases'] if not case['matches']),public['cases'][0])
    cycle = first.get("cycle")
    if cycle is None:
        match = re.search(r"\bcycle\s*[=:]?\s*(\d+)\b", str(feedback.get("summary", "")), re.I)
        cycle = int(match.group(1)) if match else None
    signals = []
    for key in ("signal", "signals"):
        value = feedback.get(key)
        if isinstance(value, str) and value:
            signals.append(value)
        elif isinstance(value, list):
            signals.extend(str(item) for item in value)
    evidence = {
        "first_bad_cycle": int(cycle) if str(cycle).isdigit() else None,
        "signals": list(dict.fromkeys(signals)),
        "expected": first.get("expected") if first.get("expected") is not None else feedback.get("expected"),
        "actual": first.get("actual") if first.get("actual") is not None else feedback.get("actual"),
        "inputs": first.get("inputs") if first.get("inputs") is not None else feedback.get("inputs"),
        "has_io_example": bool((first.get("inputs") if first.get("inputs") is not None else feedback.get("inputs")) is not None and (first.get("expected") if first.get("expected") is not None else feedback.get("expected")) is not None),
        "replay_status": "insufficient",
        "missing_replay_fields": ["initialization", "ordered_input_sequence", "sampling_point"],
        "waveform_artifacts": [str(item) for item in result.get("artifacts", []) if item],
        "log_artifacts": [str(item) for item in result.get("log_files", []) if item],
    }
    evidence.update(feedback.get('replay') or trace_readiness(feedback.get('execution_trace')))
    for key in ('candidate_binding','validation_id','execution_trace','public_diagnostics'):
        if key in feedback:evidence[key]=feedback[key]
    return {key: value for key, value in evidence.items() if value not in (None, [], "")}


def trace_readiness(trace, required_inputs=None):
    """A declared complete safe trace is replay input, never a certified root cause."""
    from agent.contracts.schemas import validate, EXECUTION_TRACE, ContractError
    missing=[]
    try: validate(trace,EXECUTION_TRACE)
    except ContractError:
        return {'replay_status':'insufficient','missing_replay_fields':['initialization','ordered_input_sequence','sampling_point']}
    if trace['initialization']['status']!='known' or not trace['initialization']['inputs'] or trace['initialization']['reset_cycles']<1: missing.append('initialization')
    events=trace['events']
    names={p['signal'] for p in trace['initialization']['inputs']}
    if (required_inputs is not None and names!=set(required_inputs)) or len(names)!=len(trace['initialization']['inputs']):missing.append('initialization')
    if not events or any(e['edge']=='unknown' or e.get('clock_signal') not in names or {p['signal'] for p in e['inputs']}!=names or len({p['signal'] for p in e['inputs']})!=len(e['inputs']) for e in events): missing.append('ordered_input_sequence')
    if any(events[i]['cycle']>=events[i+1]['cycle'] for i in range(len(events)-1)): missing.append('ordered_input_sequence')
    if trace['sampling_point']=='unknown': missing.append('sampling_point')
    return {'replay_status':'insufficient' if missing else 'ready','missing_replay_fields':list(dict.fromkeys(missing))}


def public_table_cases(facts):
    """Literal numeric combinational Markdown tables only; no inferred defaults."""
    if facts['scope']['implementation_kind']!='combinational': return []
    ports=facts['interface']['ports'];by_name={p['name']:p for p in ports}
    inputs={p['name'] for p in ports if p['direction']=='input'}
    if not inputs or any(type(p['width']) is not int or p['width']>64 or p['signed'] for p in ports):return []
    lines=facts['source']['raw_text'].splitlines();cases=[];header=None;header_line=0;seen={}
    def number(cell,width):
        cell=cell.strip().strip('`')
        if re.fullmatch(r"[0-9]+",cell):value=int(cell)
        elif re.fullmatch(r"0[bB][01]+",cell):value=int(cell,2)
        elif re.fullmatch(r"0[xX][0-9a-fA-F]+",cell):value=int(cell,16)
        else:return None
        return value if 0<=value<2**width else None
    for i,line in enumerate(lines,1):
        if not line.strip().startswith('|') or not line.strip().endswith('|'):header=None;continue
        cells=[c.strip().strip('`') for c in line.strip()[1:-1].split('|')]
        if set(cells)<=set(by_name) and len(set(cells))==len(cells) and inputs<=set(cells) and any(by_name[c]['direction']=='output' for c in cells) and all(by_name[c]['direction'] in {'input','output'} for c in cells):
            header=cells;header_line=i;continue
        if header is None or all(re.fullmatch(r':?-+:?',c) for c in cells):continue
        if len(cells)!=len(header):header=None;continue
        values=[number(c,by_name[n]['width']) for n,c in zip(header,cells)]
        if any(v is None for v in values):continue
        pairs=dict(zip(header,values));given={n:v for n,v in pairs.items() if n in inputs};expected={n:v for n,v in pairs.items() if n not in inputs}
        key=tuple(sorted(given.items()))
        if key in seen and seen[key]!=expected:return []
        seen[key]=expected
        cases.append({'case_id':len(cases),'requirement_refs':[f'R{header_line:04d}',f'R{i:04d}'],'inputs':given,'expected':expected})
    return cases[:8]


def compare_public_behaviors(attempts):
    """Different on observed public cases does not establish global equivalence."""
    import itertools
    result=[]
    for a,b in itertools.combinations(attempts,2):
        def observations(attempt):
            diagnostic=attempt.get('validation',{}).get('public_diagnostics',{})
            if diagnostic.get('status')!='executed':return {}
            return {tuple((p['signal'],p['value']) for p in c['inputs']):c['actual'] for c in diagnostic['cases']}
        x,y=observations(a),observations(b);common=x.keys()&y.keys()
        if common:result.append({'left_revision':a['revision_id'],'right_revision':b['revision_id'],'compared_cases':len(common),'relation':'different_on_observed_cases' if any(x[k]!=y[k] for k in common) else 'same_on_observed_cases','global_equivalence':'not_established'})
    return result
