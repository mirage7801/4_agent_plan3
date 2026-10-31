"""Safe validator feedback projection for repair prompts."""

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path
from collections.abc import Iterable, Mapping
from typing import Any

from .eda_adapter import is_environment_failure
from ..contracts.schemas import EVIDENCE, EXECUTION_TRACE, validate, ContractError
from .storage import atomic_write_json


def _redact_validation_assets(value: str, result: dict[str, Any]) -> str:
    text = str(value)
    candidate = str(result.get("source", ""))
    if candidate:
        # Candidate paths are local implementation details.  Preserve the
        # validator's line number while replacing both Windows and POSIX forms.
        for form in {candidate, candidate.replace("\\", "/")}:
            text = text.replace(form, "<candidate_rtl>")
    testbench = str(result.get("testbench", ""))
    if testbench:
        text = text.replace(testbench, "<private_testbench>")
        text = text.replace(testbench.replace("\\", "/"), "<private_testbench>")
    text = re.sub(
        r"(?i)(?:[A-Za-z]:)?[^\r\n;]*?\.xdc",
        "<private_validation_file>",
        text,
    )
    text = re.sub(
        r"(?i)(?:[A-Za-z]:)?[^\s;]*[\\/](?:tb_[^\\/\s;]+|tb|testbench)\.(?:sv|v)",
        "<private_testbench>",
        text,
    )
    text = re.sub(
        r"(?i)(?:[A-Za-z]:)?[^\s;]*[\\/](?:(?:reference|ref)\.(?:v|sv)|faults[\\/][^\s;]+)",
        "<private_validation_fixture>",
        text,
    )
    return " ".join(text.split())[:1000]


def warning_rank(text):
    return (0 if re.search(r"\berror\b|multi.driv|syntax", text, re.I) else
            1 if re.search(r"\bline\s*[:#]?\s*\d+|<candidate_rtl>:\d+", text, re.I) else
            2 if re.search(r"\bcritical\b|\blatch\b|\bwidth\b", text, re.I) else 3)


class EvidenceBudgetError(ValueError):
    """The caller-designated core evidence cannot fit the model warning view."""
    code = "CONTEXT_EVIDENCE_INCOMPLETE"


def diagnostic_warning_view(evidence):
    """One bounded warning projection, reused by rendering and token compaction.

    Only whitespace-identical messages merge. Different locations, codes or
    messages remain independent; no root-cause inference is performed.
    Metadata describes available safe warnings, not private/raw validator logs.
    """
    import hashlib
    warnings=list(dict.fromkeys(evidence.get('warnings',[])))
    prior=list(dict.fromkeys(evidence.get('required_warning_lines',[])))
    old=evidence.get('diagnostic_coverage')
    # A view already carries its full loss accounting. Compaction must neither
    # regenerate identities from shortened messages nor forget omitted roots.
    if old:
        return evidence
    if len(prior)>8 or sum(map(len,prior))>4000:
        raise EvidenceBudgetError('CONTEXT_EVIDENCE_INCOMPLETE: caller-required warning evidence exceeds the 8-line/4000-character view; no model request dispatched')
    raw=prior+[w for w in sorted(warnings,key=warning_rank) if w not in prior]
    unique=[];seen=set()
    for text in raw:
        normalized=' '.join(text.split())
        if normalized not in seen:unique.append(text);seen.add(normalized)
    selected=[];metadata=[];omitted=[];shortened=0;size=0
    for text in unique:
        identity=hashlib.sha256(' '.join(text.split()).encode()).hexdigest()
        core=text in prior
        # Never shorten explicit core. Other long messages preserve both ends;
        # the partial status explicitly denies semantic completeness.
        view=text if core or len(text)<=440 else text[:300]+' ... [shortened] ... '+text[-110:]
        if len(selected)>=8 or size+len(view)>4000:
            omitted.append(identity);continue
        selected.append(view);size+=len(view)
        item={'id':identity,'kind':'error' if warning_rank(text)==0 else 'located_warning' if warning_rank(text)==1 else 'warning','shortened':view!=text}
        line=re.search(r'\bline\s*[:#=]?\s*(\d+)|<candidate_rtl>:(\d+)',text,re.I)
        code=re.search(r'\[([A-Za-z_][A-Za-z0-9_-]*[ -][0-9][0-9-]*)\]',text)
        if line:item['line']=int(next(v for v in line.groups() if v is not None))
        if code:item['code']=code[1][:128]
        metadata.append(item);shortened+=view!=text
    prior_omitted=evidence.get('warnings_omitted',0)
    reasons=[]
    if omitted:reasons.append('warning_view_capacity')
    if shortened:reasons.append('message_shortened')
    if prior_omitted:reasons.append('upstream_warning_omission')
    required=[text for text,item in zip(selected,metadata) if warning_rank(text)<3 or item['id'] in {hashlib.sha256(' '.join(p.split()).encode()).hexdigest() for p in prior}]
    if not required and not any(evidence.get('diagnostics',{}).values()) and selected:required=selected[:1]
    evidence['required_warning_lines']=required
    evidence['warnings']=[text for text in selected if text not in required]
    evidence['warnings_omitted']=prior_omitted+len(omitted)
    evidence['diagnostic_coverage']={'scope':'available_safe_warning_projection','status':'partial' if reasons else 'complete',
        'available_count':len(unique),'retained_count':len(metadata),'omitted_count':len(omitted),'shortened_count':shortened,
        'upstream_omitted_count':prior_omitted,'core_preserved':True,'retained':metadata,'omitted_ids':omitted[:136],'reasons':reasons}
    return evidence


def bounded_warnings(raw, result):
    """Bound the model projection, leaving authoritative EDA output untouched."""
    raw = [raw] if isinstance(raw, str) else list(raw) if isinstance(raw, (list, tuple)) else []
    schema = EVIDENCE["properties"]["warnings"]
    unique = list(dict.fromkeys(_redact_validation_assets(str(item), result)[:schema["items"]["maxLength"]]
                                for item in raw))
    kept = sorted(unique, key=warning_rank)[:schema["maxItems"]]
    return kept, {"input_count":len(raw), "unique_count":len(unique), "kept_count":len(kept),
                  "duplicate_count":len(raw)-len(unique), "omitted_unique_count":len(unique)-len(kept)}


def _harden_projection(projected: dict[str, Any], result: dict[str, Any]) -> dict[str, Any]:
    hardened = dict(projected)
    hardened["summary"] = _redact_validation_assets(
        str(projected.get("summary", "")), result
    )
    hardened["warnings"], counts = bounded_warnings(projected.get("warnings", []), result)
    if counts["omitted_unique_count"]:
        hardened["warnings_omitted"] = projected.get("warnings_omitted",0) + counts["omitted_unique_count"]
    return hardened


# Values copied into diagnostics are deliberately much narrower than the
# validator summary.  This keeps useful simulation values (for example
# ``8'hff`` or ``f/0``) while preventing paths, shell fragments, and arbitrary
# log text from crossing the model boundary.
_SAFE_DIAGNOSTIC_VALUE_RE = re.compile(r"[^A-Za-z0-9_.$/'#+:=<>\-,xXzZ]")
_PROCESS_RE = re.compile(r"\b(always_ff|always_comb|always_latch|always|assign)\b", re.I)
_FIELD_RE = re.compile(
    r"(?P<key>kind|case|cycle|inputs|expected|actual)\s*(?:=|:)\s*(?P<value>[^\s,;\]\)]+)",
    re.I,
)
_INPUTS_RE = re.compile(
    r"\binputs\s*(?:=|:)\s*(?P<value>.+?)(?=\s+(?:expected|actual|kind|case|cycle)\s*(?:=|:)|$)",
    re.I,
)
_DRIVER_SIGNAL_RE = re.compile(
    r"(?:['\"](?P<quoted>[A-Za-z_]\w*)['\"]|\b(?:net|signal|pin)\s+['\"]?(?P<named>[A-Za-z_]\w*)['\"]?|\b(?P<bare>[A-Za-z_]\w*))"
    r"\s+(?:is\s+)?(?:multi[- ]?driven|driven|has\s+multiple\s+drivers|might\s+have\s+multiple\s+concurrent\s+drivers)",
    re.I,
)
_DRIVER_SIGNAL_FALLBACK_RE = re.compile(
    r"\b(?:multiple\s+drivers?\s+(?:on|for)\s+(?:(?:net|signal|pin)\s+)?|"
    r"multi[- ]?driven\s+(?:net|signal|pin)\s+(?:on\s+(?:net|signal|pin)\s+)?)['\"]?(?P<name>[A-Za-z_]\w*)",
    re.I,
)
_LINE_RE = re.compile(
    r"(?:\.(?:sv|v|vh|vhd|vhdl)\s*:\s*|\b(?:line|行)\s*[:#=]?\s*)(?P<line>\d+)\b",
    re.I,
)


def _safe_diagnostic_value(value: Any, *, maximum: int = 128) -> str:
    """Return a compact scalar suitable for a repair prompt."""

    text = str(value).strip()
    # Do not allow a value to become a path-like payload.  Fields are normally
    # single tokens from TB_FAIL, so replacing whitespace is sufficient and
    # avoids preserving unbounded log fragments.
    text = re.sub(r"\s+", "", text)
    text = _SAFE_DIAGNOSTIC_VALUE_RE.sub("", text)
    # A slash is useful in compact HDL comparisons such as ``f/0`` and
    # ``1/1``, but arbitrary slash-separated values can be absolute or
    # Windows paths.  Keep only the hexadecimal/unknown-value form used by
    # validator TB_FAIL fields; drop path-like values altogether.
    if "/" in text or "\\" in text:
        if not re.fullmatch(r"[0-9A-Fa-fxXzZ'h?]+(?:/[0-9A-Fa-fxXzZ'h?]+)+", text):
            return ""
    return text[:maximum]


def _diagnostic_fields(text: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    for match in _FIELD_RE.finditer(text):
        key = match.group("key").lower()
        value = _safe_diagnostic_value(match.group("value"))
        if value and key not in fields:
            fields[key] = value
    inputs_match = _INPUTS_RE.search(text)
    if inputs_match:
        value = _safe_diagnostic_value(inputs_match.group("value"))
        if value:
            fields["inputs"] = value
    return fields


def _is_multiple_driver_text(text: str) -> bool:
    lowered = text.lower()
    return bool(
        re.search(
            r"multiple\s+drivers?|multi[- ]?driv(?:en|ers?)|multi[- ]source|"
            r"multiple\s+concurrent\s+drivers?|concurrent\s+drivers?|"
            r"should\s+not\s+be\s+driven\s+by\s+any\s+other\s+process",
            lowered,
        )
    )


def _driver_record(text: str) -> dict[str, Any] | None:
    if not _is_multiple_driver_text(text):
        return None

    signal_match = _DRIVER_SIGNAL_RE.search(text) or _DRIVER_SIGNAL_FALLBACK_RE.search(text)
    signal = None
    if signal_match:
        groups = signal_match.groupdict()
        signal = groups.get("quoted") or groups.get("named") or groups.get("bare") or groups.get("name")
        signal = _safe_diagnostic_value(signal)
    processes = []
    for match in _PROCESS_RE.finditer(text):
        process = match.group(1).lower()
        if process not in processes:
            processes.append(process)
    line_match = _LINE_RE.search(text)
    record: dict[str, Any] = {}
    if signal:
        record["signal"] = signal
    if processes:
        # Keep both the convenient singular field and the complete set.  Most
        # Vivado warnings name one process and an unspecified "other process";
        # when both are named, ``processes`` preserves both names.
        record["process"] = processes[0]
        record["processes"] = processes
    if line_match:
        try:
            record["line"] = int(line_match.group("line"))
        except ValueError:
            pass
    return record or None


def _functional_record(text: str, error_type: str | None = None) -> dict[str, str] | None:
    fields = _diagnostic_fields(text)
    if not fields and not re.search(r"\b(?:TB_FAIL|TEST_FAIL)\b", text, re.I):
        return None
    if not (fields.get("expected") or fields.get("actual")):
        return None
    record: dict[str, str] = {}
    kind = fields.get("kind") or _safe_diagnostic_value(error_type or "functional_mismatch")
    if kind:
        record["kind"] = kind
    for key in ("case", "cycle", "inputs", "expected", "actual"):
        if fields.get(key):
            record[key] = fields[key]
    return record


def extract_structured_diagnostics(
    feedback: str | Mapping[str, Any],
    warnings: Iterable[Any] | None = None,
    *,
    error_type: str | None = None,
) -> dict[str, list[dict[str, Any]]]:
    """Extract safe, machine-readable details from projected validator text.

    The validator schema remains unchanged.  This helper intentionally reads
    only the already projected ``summary``/``warnings`` fields and returns no
    paths or raw log lines.  It accepts either a feedback mapping or a summary
    string to make local replay tests and integrations straightforward.
    """

    if isinstance(feedback, Mapping):
        summary = str(feedback.get("summary", ""))
        warning_values = feedback.get("warnings", [])
        if warnings is None:
            warnings = warning_values if isinstance(warning_values, Iterable) and not isinstance(warning_values, str) else [warning_values]
        if error_type is None:
            error_type = str(feedback.get("error_type", "")) or None
    else:
        summary = str(feedback)
    texts = [summary]
    if warnings is not None:
        texts.extend(str(item) for item in warnings)

    multi_drivers: list[dict[str, Any]] = []
    functional: list[dict[str, Any]] = []
    for text in texts:
        driver = _driver_record(text)
        if driver and driver not in multi_drivers:
            multi_drivers.append(driver)
        mismatch = _functional_record(text, error_type)
        if mismatch and mismatch not in functional:
            functional.append(mismatch)

    diagnostics: dict[str, list[dict[str, Any]]] = {}
    if multi_drivers:
        diagnostics["multiple_driver"] = multi_drivers[:20]
    if functional:
        diagnostics["functional_mismatch"] = functional[:20]
    return diagnostics


def _private_fixture(result: Mapping[str, Any]) -> bool:
    source = str(result.get("source", "")).replace("\\", "/").lower()
    return source.endswith("/reference.v") or "/faults/" in source


def _with_structured_diagnostics(projected: dict[str, Any], result: dict[str, Any]) -> dict[str, Any]:
    """Harden a projection and append diagnostics only for candidate failures."""

    hardened = _harden_projection(projected, result)
    hardened.pop("execution_trace",None)
    # Keep the boundary safe even if a custom validator policy returns an
    # over-permissive flag.  Environment failures and private fixtures never
    # become candidate repair context.
    if is_environment_failure(result) or _private_fixture(result):
        hardened["candidate_feedback_allowed"] = False
    if hardened.get("candidate_feedback_allowed", False):
        hardened["diagnostics"] = extract_structured_diagnostics(projected)
        # Only the validator's safe projection may disclose a temporal trace.
        if 'execution_trace' in projected:
            try:
                validate(projected['execution_trace'],EXECUTION_TRACE)
                hardened['execution_trace']=projected['execution_trace']
            except ContractError: pass
        # Controller-owned candidate prechecks, never private EDA fixture logs.
        if result.get("stage") == "precheck" and isinstance(result.get("candidate_errors"), list):
            records = []
            for item in result["candidate_errors"][:8]:
                if not isinstance(item, dict):
                    continue
                record = {"kind":str(item.get("kind", "precheck_error"))[:64],
                          "message":_redact_validation_assets(item.get("message", ""), result)}
                if type(item.get("line")) is int and item["line"] > 0:
                    record["line"] = item["line"]
                for key, maximum in (("tool",64),("code",128)):
                    if item.get(key): record[key] = str(item[key])[:maximum]
                if record["message"]: records.append(record)
            if records: hardened["diagnostics"]["candidate_errors"] = records
    else:
        hardened["diagnostics"] = {}
    return hardened


def _fallback_projection(result: dict[str, Any]) -> dict[str, Any]:
    environment_failure = is_environment_failure(result)
    source = str(result.get("source", "")).replace("\\", "/").lower()
    private_fixture = source.endswith("/reference.v") or "/faults/" in source
    summary = str(result.get("summary", ""))
    testbench = str(result.get("testbench", ""))
    if testbench:
        summary = summary.replace(testbench, "<private_testbench>")
    summary = re.sub(
        r"(?i)(?:[A-Za-z]:)?[^\s;]*[\\/](?:constraints\.xdc|tb_[^\\/\s]+\.sv)",
        "<private_validation_file>",
        summary,
    )
    if private_fixture:
        summary = f"{result.get('error_type', 'unknown_error')}: private validation fixture details withheld"
    warnings = [] if environment_failure or private_fixture else [str(item)[:1000] for item in result.get("warnings", [])]
    return _harden_projection({
        "stage": result.get("stage"),
        "error_type": result.get("error_type"),
        "summary": " ".join(summary.split())[:1000],
        "warnings": warnings,
        "candidate_feedback_allowed": not environment_failure and not private_fixture,
    }, result)


def project_safe_feedback(result: dict[str, Any], validator_root: str | Path, *, audit_path: Path | None = None) -> dict[str, Any]:
    """Prefer the validator's tested policy and fall back to the same field boundary."""

    def finish(projected, source, warning_source=None):
        value = {**_with_structured_diagnostics(projected, result), "projection_source":source}
        validate(value, EVIDENCE)
        if audit_path is not None:
            _, counts = bounded_warnings(projected.get("warnings", []) if warning_source is None else warning_source, result)
            atomic_write_json(Path(audit_path), {"projection_source":source, "warnings":counts})
        return value

    root = Path(validator_root).resolve()
    script = (
        "import json,sys; "
        "from tools.feedback_policy import team_two_feedback; "
        "print(json.dumps(team_two_feedback(json.load(sys.stdin)), ensure_ascii=True))"
    )
    try:
        completed = subprocess.run(
            [str(Path(__import__("sys").executable)), "-c", script],
            cwd=root,
            # Keep the pipe ASCII-only so Windows locale encodings cannot corrupt
            # Chinese task paths before the validator policy reads the JSON.
            input=json.dumps(result, ensure_ascii=True),
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=15,
            check=False,
        )
        if completed.returncode == 0:
            projected = json.loads(completed.stdout)
            required={"stage","error_type","summary","warnings","candidate_feedback_allowed"}
            if isinstance(projected, dict) and required <= set(projected) <= required | {'execution_trace'}:
                return finish(projected, "validator.feedback_policy")
    except (OSError, subprocess.SubprocessError, json.JSONDecodeError):
        pass
    fallback = _fallback_projection(result)
    return finish(fallback, "strict_fallback", result.get("warnings", [])
                  if fallback.get("candidate_feedback_allowed") else [])



def evidence_capabilities(feedback, *, scope='unknown', review=None):
    """Independent evidence capabilities; a point observation is not a temporal replay."""
    diagnostics=feedback.get('diagnostics') or {}
    located=bool(diagnostics.get('candidate_errors') or diagnostics.get('multiple_driver'))
    located = located or bool(feedback.get('stage') in {'compile','elaborate','precheck','synthesis'} and
        re.search(r'\b(?:candidate\s+line|line)\s*[:#]?\s*\d+|<candidate_rtl>:\d+',feedback.get('summary',''),re.I))
    io=any(isinstance(r,dict) and all(r.get(k) is not None for k in ('inputs','expected','actual'))
           for r in diagnostics.get('functional_mismatch',[]))
    functional=feedback.get('stage')=='simulation' or 'functional' in str(feedback.get('error_type','')).lower() or bool(diagnostics.get('functional_mismatch'))
    from .failure_evidence import trace_readiness
    replay=(feedback.get('replay') or trace_readiness(feedback.get('execution_trace')))['replay_status']=='ready'
    public_io=any(not c['matches'] for c in feedback.get('public_diagnostics',{}).get('cases',[]))
    io=io or public_io
    return {'located_tool_error':located,'observed_io':io,'replayable_trace':replay,
            'review_hypothesis':bool(review and review.get('issues')), 'aggregate_only':bool(functional and not located and not io),
            'direct_repair_supported':bool(located or io),
            'reconstruction_after_failed_repair':bool(functional and not located and (not io or scope != 'combinational'))}
