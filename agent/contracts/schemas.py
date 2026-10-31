"""Canonical closed schemas and a strict validator for this project's schema subset.

No external dependency; this is deliberately not a general JSON Schema engine.
All objects are closed, except explicitly typed maps (diagnostic values).
"""
from __future__ import annotations
import json
import math
import re

class ContractError(ValueError):
    pass

def loads(text):
    def pairs(items):
        result = {}
        for key, value in items:
            if key in result: raise ContractError("duplicate JSON key: " + key)
            result[key] = value
        return result
    def constant(value): raise ContractError("non-finite JSON number: " + value)
    def number(text):
        value=float(text)
        if not math.isfinite(value): raise ContractError("non-finite JSON number")
        return value
    try: return json.loads(text, object_pairs_hook=pairs, parse_constant=constant, parse_float=number)
    except (ValueError, RecursionError) as exc: raise ContractError(str(exc)) from exc

def string(maximum=1200, minimum=1, pattern=None):
    result = {"type":"string", "minLength":minimum, "maxLength":maximum}
    if pattern: result["pattern"] = pattern
    return result

def enum(*values): return {"enum":list(values)}
def arr(item, maximum=128, minimum=0, unique=False):
    return {"type":"array", "items":item, "minItems":minimum, "maxItems":maximum, "uniqueItems":unique}
def obj(props, optional=()):
    return {"type":"object", "properties":props, "required":[k for k in props if k not in optional], "additionalProperties":False}
def nullable(schema): return {"anyOf":[schema,{"type":"null"}]}
BOOL={"type":"boolean"}
INT={"type":"integer","minimum":1}
NAT={"type":"integer","minimum":0}
NUM={"type":"number","minimum":0}
TEXT=string()
REF=string(32,pattern=r"^R[0-9]{4,}$")
REFS=arr(REF,4096,unique=True)
NE_REFS={**REFS,"minItems":1}
HASH=string(64,64,r"^[a-f0-9]{64}$")
ID=string(128,pattern=r"^[A-Za-z_][A-Za-z0-9_$]*$")
CHECK_IDS=("locked_interface","combinational_scope","complete_comb_assignments","public_table_rows","reset_behavior","reset_priority","priority_order","enable_behavior","output_timing","illegal_states","parameter_range","collision_behavior","state_transitions")
PROFILE_VALUES={"implementation_scope":("unknown","combinational","sequential"),"requested_component":("unknown","next_state_logic","full_module"),"functional_family":("unknown","popcount","priority_encoder","fifo","counter","fsm")}
NOTE=obj({"statement":TEXT,"requirement_refs":NE_REFS,"source_quote":TEXT,"basis":enum("explicit","inferred"),"example":obj({"given":TEXT,"expected":TEXT})},("example",))
AMBIGUITY=obj({"question":TEXT,"implementation_impact":TEXT,"requirement_refs":NE_REFS,"source_quote":TEXT})
REASSESSMENT=obj({"prior_interpretation":TEXT,"feedback_observation":TEXT,"evidence_sufficient":BOOL,"interpretation_change":TEXT,"next_attempt_change":TEXT})
ANALYST=obj({"implementation_notes":arr(NOTE,16),"ambiguities":arr(AMBIGUITY,8)})
REBUILD=obj({**ANALYST["properties"],"reassessment":REASSESSMENT})
ISSUE=obj({"id":string(64),"requirement_refs":NE_REFS,"source_quote":TEXT,"candidate_location":obj({"start_line":INT,"end_line":INT}),"candidate_excerpt":string(6000),"trigger_condition":TEXT,"expected_behavior":TEXT,"predicted_behavior":TEXT,"reasoning":TEXT})
REVIEWER=obj({"issues":arr(ISSUE,4),"limitations":arr(string(1000),3)})
STATUS=enum("source_checked","unknown","not_applicable","conflict")
def feature(value): return obj({"value":value,"status":STATUS,"requirement_refs":REFS})
FEATURE_NAMES=("reset_behavior","reset_priority","priority","enable","output_latency","illegal_states","parameter_range","collision","state_transitions","overflow","public_table","clocked")
PROFILE=obj({"schema_version":enum("1.0"),**{k:feature(enum(*v)) for k,v in PROFILE_VALUES.items()},"clocking":arr(obj({"signal":ID,"edge":enum("rising","falling"),"requirement_refs":NE_REFS}),128),"reset":obj({"status":STATUS,"requirement_refs":REFS,"polarity":enum("unknown","active_high","active_low"),"synchrony":enum("unknown","synchronous","asynchronous")}),"features":obj({k:feature(nullable(BOOL)) for k in FEATURE_NAMES}),"method":enum("deterministic_source_patterns"),"semantic_completeness_proven":enum(False),"facts_ref":HASH})
PORT=obj({"name":ID,"direction":enum("input","output","inout"),"width":{"anyOf":[INT,string(512,pattern=r"^\[.+:.+\]$")]},"signed":BOOL,"source_refs":NE_REFS})
FACTS=obj({"schema_version":enum("2.0"),"facts_version":INT,"facts_id":HASH,"source":obj({"raw_text":string(2000000),"sha256":HASH,"task_version":string(256)}),"interface":obj({"module":ID,"language":enum("verilog","systemverilog"),"ports":arr(PORT,8192),"ports_status":enum("parsed","unresolved")}),"scope":obj({"implementation_kind":enum("combinational","sequential","unspecified"),"source_refs":REFS}),"requirements":arr(obj({"id":REF,"source_lines":{**arr(INT,2,2)},"status":enum("explicit_source")}),100000),"explicit_tables":REFS,"explicit_examples":REFS,"unresolved_questions":arr(obj({"kind":enum("interface_parse"),"action":enum("use_original_interface_text")})),"verification":obj({"method":enum("deterministic_public_source"),"source_preserved":enum(True),"interface_checked":BOOL,"semantic_completeness_proven":enum(False)})})
SOURCE_CHECK=enum("exact_source_match","source_match_whitespace_normalized")
DERIVED_NOTE=obj({**NOTE["properties"],"source_check":SOURCE_CHECK,"semantic_status":enum("unverified")},("example",))
DERIVED_AMBIGUITY=obj({**AMBIGUITY["properties"],"source_check":SOURCE_CHECK,"semantic_status":enum("unverified")})
DERIVED=obj({"schema_version":enum("3.0"),"derived_version":INT,"facts_ref":HASH,"implementation_notes":arr(DERIVED_NOTE,16),"ambiguities":arr(DERIVED_AMBIGUITY,8),"reassessment":nullable(REASSESSMENT),"rejected":arr(obj({"collection":enum("implementation_notes","ambiguities"),"index":NAT,"reason":enum("unknown_requirement_reference","source_quote_mismatch")}),24),"task_profile":PROFILE})
BINDING=obj({"facts_ref":HASH,"facts_version":INT,"derived_ref":nullable(INT)})
WORKER_BINDING=obj({**BINDING["properties"],"facts_path":string(32768)})
USAGE=obj({"input_tokens":nullable(NAT),"output_tokens":nullable(NAT),"reasoning_tokens":nullable(NAT),"requested_max_tokens":INT})
GENERATION=obj({"finish_reason":enum("eos","stop_sequence","length","timeout","cancelled","error","unknown"),"provider_finish_reason":nullable(string(256))})
ERROR=obj({"code":string(128),"message":string(4000),"retryable":BOOL})
BACKEND=obj({"request_id":nullable(string(128)),"backend_state":enum("not_observed","idle_confirmed","unknown"),"backend_drain_seconds":NUM,"next_task_allowed":BOOL,"reason":string(128),"server_state":nullable(enum("running","completed","failed","rejected","unknown")),"request_elapsed_seconds":NUM,"previous_request_id":nullable(string(128))})
RUNTIME_BINDING=obj({"identity_id":HASH,"code_hash":HASH,"config_hash":HASH})
CALL=obj({"runtime_identity":RUNTIME_BINDING,"schema_version":enum("2.0"),"task_id":string(256),"run_id":string(256),"request_id":string(128),"response_kind":enum("rtl","analyst","reviewer"),"context_binding":nullable(WORKER_BINDING),"model_id":string(512),"revision":string(512),"elapsed_seconds":NUM,"status":enum("success","failed"),"stage":enum("generation","rtl_extraction","json_validation","complete","infrastructure"),"error":nullable(ERROR),"generation":GENERATION,"usage":USAGE,"rtl_status":enum("complete","incomplete","invalid","not_available"),"raw_response_file":nullable(string(32768)),"raw_payload_file":nullable(string(32768)),"source_file":nullable(string(32768)),"answer_file":nullable(string(32768)),"source_kind":nullable(enum("tagged:RTL_CODE")),"selected_block_index":nullable(NAT),"backend":BACKEND},("backend","runtime_identity",))
LLM_PAYLOAD=obj({"runtime_identity":RUNTIME_BINDING,"prompt":string(2000000),"top_module":ID,"output_dir":string(32768),"response_kind":enum("rtl","analyst","reviewer"),"source_name":string(256,pattern=r"^[^/\\]+$"),"context_binding":WORKER_BINDING,"mock_response_index":NAT,"max_tokens":INT,"request_id":string(128)},("mock_response_index","runtime_identity",))
APPLICABLE_CHECK=obj({"check_id":enum(*CHECK_IDS),"requirement_refs":NE_REFS,"instruction":TEXT})
MEMORY=arr(obj({"error_type":string(256,0),"stage":string(256,0),"summary":string(2000,0)},("error_type","stage","summary")),3)
SCALAR={"anyOf":[string(128,0),NAT,BOOL,{"type":"null"}]}
CANDIDATE_DIAGNOSTIC=obj({"kind":string(64),"message":string(1000),"line":INT,"tool":string(64),"code":string(128)},("line","tool","code"))
DIAGNOSTICS=obj({"candidate_errors":arr(CANDIDATE_DIAGNOSTIC,8),"multiple_driver":arr(obj({"signal":ID,"process":string(32),"processes":arr(string(32),8),"line":INT},("signal","process","processes","line")),20),"functional_mismatch":arr(obj({k:SCALAR for k in ("kind","case","cycle","inputs","expected","actual")},("kind","case","cycle","inputs","expected","actual")),20)},("multiple_driver","functional_mismatch","candidate_errors"))
CANDIDATE_BINDING=obj({"revision_id":string(128),"source_hash":HASH})
SIGNAL_VALUE=obj({"signal":ID,"value":string(128,1,r"^[0-9a-fA-F_xXzZ]+$")})
TRACE_EVENT=obj({"clock_signal":ID,"cycle":NAT,"edge":enum("rising","falling","unknown"),"inputs":arr(SIGNAL_VALUE,64),"expected":arr(SIGNAL_VALUE,64),"actual":arr(SIGNAL_VALUE,64)},("clock_signal","expected","actual"))
EXECUTION_TRACE=obj({"initialization":obj({"status":enum("known","unknown"),"inputs":arr(SIGNAL_VALUE,64),"reset_cycles":NAT}),"events":arr(TRACE_EVENT,64),"sampling_point":enum("before_update","after_update","unknown")})
PUBLIC_CASE_RESULT=obj({"case_id":NAT,"requirement_refs":NE_REFS,"inputs":arr(SIGNAL_VALUE,64),"expected":arr(SIGNAL_VALUE,64),"actual":arr(SIGNAL_VALUE,64),"matches":BOOL})
PUBLIC_DIAGNOSTIC=obj({"status":enum("executed","not_executed","not_applicable"),"reason":string(256),"cases":arr(PUBLIC_CASE_RESULT,8)})
REPLAY=obj({"replay_status":enum("ready","insufficient"),"missing_replay_fields":arr(enum("initialization","ordered_input_sequence","sampling_point"),3)})
DIAGNOSTIC_COVERAGE=obj({"scope":enum("available_safe_warning_projection"),"status":enum("complete","partial"),"available_count":NAT,"retained_count":NAT,"omitted_count":NAT,"shortened_count":NAT,"upstream_omitted_count":NAT,"core_preserved":BOOL,"retained":arr(obj({"id":HASH,"kind":enum("error","located_warning","warning"),"shortened":BOOL,"line":INT,"code":string(128)},("line","code")),8),"omitted_ids":arr(HASH,136),"reasons":arr(enum("warning_view_capacity","message_shortened","upstream_warning_omission","optional_context_compaction"),4,unique=True)})
EVIDENCE=obj({"diagnostic_coverage":DIAGNOSTIC_COVERAGE,"replay":REPLAY,"execution_trace":EXECUTION_TRACE,"public_diagnostics":PUBLIC_DIAGNOSTIC,"candidate_binding":CANDIDATE_BINDING,"validation_id":string(256),"required_warning_lines":arr(string(2000,0),8),"stage":string(256,0),"error_type":nullable(string(256,0)),"summary":string(12000,0),"warnings":arr(string(2000,0),128),"warnings_omitted":NAT,"candidate_feedback_allowed":BOOL,"diagnostics":DIAGNOSTICS,"projection_source":string(256)},("diagnostic_coverage","replay","execution_trace","public_diagnostics","candidate_binding","validation_id","required_warning_lines","warnings","warnings_omitted","candidate_feedback_allowed","diagnostics","projection_source"))
REVIEW_ISSUE=obj({**ISSUE["properties"],"source_check":SOURCE_CHECK,"candidate_check":enum("exact_candidate_excerpt"),"semantic_status":enum("unverified")})
REVIEW_CONTEXT=obj({"status":enum("findings_available","no_supported_findings","unavailable"),"candidate_binding":nullable(CANDIDATE_BINDING),"issues":arr(REVIEW_ISSUE,4),"limitations":arr(string(1000),3)})
REVIEW_FILTERED=obj({**REVIEW_CONTEXT["properties"],"rejected_issues":arr(obj({"index":NAT,"id":string(64),"reason":enum("duplicate_issue_id","unknown_requirement_reference","source_quote_mismatch","invalid_candidate_location","candidate_excerpt_mismatch","empty_issue_content","conflicts_with_combinational_scope")}),4)})
ATTEMPT_METHOD=obj({"behavior_summary":string(1200,0),"revision_id":string(128),"source_hash":HASH,"strategy_id":string(128),"outcome":string(64),"failure_summary":string(1000,0),"parent_revision_id":nullable(string(128)),"analyst_advice_visible":BOOL,"relationship_summary":string(256)},("behavior_summary","parent_revision_id","analyst_advice_visible","relationship_summary"))
ATTEMPT_METHODS=arr(ATTEMPT_METHOD,32)
DELTA_PROPS={"attempted_methods":ATTEMPT_METHODS,"candidate_numbered":string(4000000),"memory":MEMORY,"strategy":TEXT,"candidate":string(2000000),"candidate_binding":CANDIDATE_BINDING,"applicable_checks":arr(APPLICABLE_CHECK,32),"evidence":EVIDENCE,"review":REVIEW_CONTEXT,"repair_strategy":TEXT,"previous_attempt":obj({"revision_id":string(128),"source_hash":HASH,"candidate":string(2000000)})}
ROLE_KEYS={"analyst":("memory",),"rebuild":("evidence","memory","previous_attempt","attempted_methods"),"synthesizer":("strategy","memory","applicable_checks","evidence","previous_attempt","attempted_methods"),"reviewer":("candidate","candidate_binding","evidence","applicable_checks","candidate_numbered"),"repairer":("candidate","candidate_binding","evidence","review","memory","repair_strategy","applicable_checks")}
def handoff_schema(stage):
    required = ({"previous_attempt","evidence"} if stage == "rebuild" else
                {"candidate","candidate_binding","evidence"} if stage in {"reviewer","repairer"} else set())
    optional = tuple(k for k in ROLE_KEYS[stage] if k not in required)
    return obj({"schema_version":enum("2.0"),"stage":enum(stage),**BINDING["properties"],"delta":obj({k:DELTA_PROPS[k] for k in ROLE_KEYS[stage]},optional)})

SCHEMAS={"analyst":ANALYST,"rebuild":REBUILD,"reviewer":REVIEWER,"filtered_review":REVIEW_FILTERED,"candidate_binding":CANDIDATE_BINDING,"task_facts":FACTS,"derived_spec":DERIVED,"llm_payload":LLM_PAYLOAD,"call":CALL,**{"handoff_"+r:handoff_schema(r) for r in ROLE_KEYS}}

def validate(value, schema, path="$", depth=0):
    if depth > 100: raise ContractError(path+": nesting limit exceeded")
    if "anyOf" in schema:
        for choice in schema["anyOf"]:
            try: validate(value,choice,path,depth+1); return
            except ContractError: pass
        raise ContractError(path+": does not match permitted types")
    if "enum" in schema and not any(type(value) is type(x) and value == x for x in schema["enum"]):
        raise ContractError(path+": invalid enum value")
    kind=schema.get("type")
    correct={"object":isinstance(value,dict),"array":isinstance(value,list),"string":isinstance(value,str),"integer":type(value) is int,"number":type(value) in (int,float) and math.isfinite(value),"boolean":type(value) is bool,"null":value is None}
    if kind and not correct[kind]: raise ContractError(path+": expected "+kind)
    if kind=="object":
        props=schema["properties"]
        missing=set(schema["required"])-value.keys(); extra=value.keys()-props.keys()
        if missing or extra: raise ContractError(f"{path}: missing={sorted(missing)}, unexpected={sorted(extra)}")
        for key,item in value.items(): validate(item,props[key],path+"."+key,depth+1)
    elif kind=="array":
        if not schema["minItems"]<=len(value)<=schema["maxItems"]: raise ContractError(path+": array length out of range")
        if schema.get("uniqueItems") and len({json.dumps(x,sort_keys=True) for x in value})!=len(value): raise ContractError(path+": duplicate array item")
        for i,item in enumerate(value): validate(item,schema["items"],f"{path}[{i}]",depth+1)
    elif kind=="string":
        if not schema["minLength"]<=len(value)<=schema["maxLength"]: raise ContractError(path+": string length out of range")
        if "pattern" in schema and not re.search(schema["pattern"],value): raise ContractError(path+": invalid string pattern")
    elif kind in {"integer","number"}:
        if value < schema.get("minimum",value): raise ContractError(path+": below minimum")

def check(name,value):
    validate(value,SCHEMAS[name]); return value

def validate_references(value, facts):
    known={r["id"] for r in facts["requirements"]}
    def walk(item):
        if isinstance(item,dict):
            for key,val in item.items():
                if key in {"requirement_refs","source_refs"} and any(r not in known for r in val):
                    raise ContractError("unknown requirement reference")
                walk(val)
        elif isinstance(item,list):
            for val in item: walk(val)
    walk(value)
