"""One audited generation/parse path shared by in-process and workers."""
from __future__ import annotations
import time
from pathlib import Path
from agent.contracts.schemas import ContractError, check, loads, ERROR
from model.contracts import ModelClientError, ModelTimeoutError
from model.extraction import extract_rtl
from model.framing import ProtocolError, final_region
from .storage import atomic_write_json, atomic_write_text

from config.loader import MAX_OUTPUT_TOKENS


def parse_json_answer(text, kind):
    """Validate final-region structure; task-specific content is checked per item downstream."""
    return check(kind, loads(final_region(text, "answer")))


def error_details(code, message, *, retryable=False):
    """Construct an error that satisfies the canonical closed error contract."""
    props = ERROR["properties"]
    code = str(code or "UNKNOWN_ERROR").strip() or "UNKNOWN_ERROR"
    message = str(message or "").strip() or code
    return {"code": code[:props["code"]["maxLength"]],
            "message": message[:props["message"]["maxLength"]], "retryable": retryable}


def failure_envelope(request, config, code, message, *, stage="infrastructure", elapsed=0.0):
    return {"schema_version":"2.0","task_id":request["task_id"],"run_id":request["run_id"],"request_id":request["request_id"],"response_kind":request["response_kind"],"context_binding":request.get("context_binding"),"model_id":config["model"]["id"],"revision":config["model"]["revision"],"elapsed_seconds":elapsed,"status":"failed","stage":stage,"error":error_details(code,message),"generation":{"finish_reason":"unknown","provider_finish_reason":None},"usage":{"input_tokens":None,"output_tokens":None,"reasoning_tokens":None,"requested_max_tokens":request["max_tokens"]},"rtl_status":"not_available","raw_response_file":None,"raw_payload_file":None,"source_file":None,"answer_file":None,"source_kind":None,"selected_block_index":None,**({"runtime_identity":request["runtime_identity"]} if request.get("runtime_identity") else {})}

def execute_call(request, config, client):
    started=time.monotonic()
    result=failure_envelope(request,config,"UNFINISHED_CALL","generation did not complete",stage="generation")
    output=Path(request["output_dir"]).resolve()
    # The scheduler chooses this path. Model-produced filenames are never used.
    audit=output / "audit"
    audit.mkdir(parents=True,exist_ok=True)
    facts=None
    try:
        check("llm_payload",{k:v for k,v in request.items() if k not in {"task_id","run_id"}})
        if request.get('runtime_identity'):
            from .storage import assert_runtime_identity
            assert_runtime_identity(request['runtime_identity'],config.get('_identity_config',config))
        expected_budget=MAX_OUTPUT_TOKENS
        if request["max_tokens"]!=expected_budget:
            raise ContractError("request output budget does not match configured role budget")
        if config["model"]["context_length"]<=request["max_tokens"]:
            raise ContractError("context_length leaves no room for input; update backend/context config")
        binding=request.get("context_binding")
        if binding:
            from .task_facts import verify_facts
            facts=loads(Path(binding["facts_path"]).read_text(encoding="utf-8"))
            verify_facts(facts,binding["facts_ref"])
            if facts["facts_version"]!=binding["facts_version"] or facts["interface"]["module"]!=request["top_module"]:
                raise ContractError("request facts version/top_module binding mismatch")
        # Agent-only optional preflight. Baseline keeps its existing request path.
        actual_prompt=request["prompt"]
        if binding:
            from .stage_context import compact_prompt
            counts=[]
            for level in range(3):
                count=client.count_prompt(actual_prompt) if hasattr(client,"count_prompt") else {"status":"unknown","reason":"client_has_no_tokenizer"}
                counts.append({"level":level,**count})
                atomic_write_json(audit/"context_budget.json", {"checks":counts,"requested_max_tokens":request["max_tokens"]})
                if count['status'] != 'exact': break
                context_limit=min(config['model']['context_length'],count['context_length'])
                if count['input_tokens']+request['max_tokens'] <= context_limit: break
                if level==2:
                    failure=ModelClientError("Original task, candidate and required evidence exceed context capacity after optional context removal")
                    failure.code="CONTEXT_BUDGET_EXCEEDED"
                    raise failure
                actual_prompt=compact_prompt(request["prompt"],level+1)
            atomic_write_text(audit/"sent_prompt.txt",actual_prompt)
        response=client.generate(actual_prompt,request["max_tokens"],float(config["model"]["temperature"]))
        if response.backend is not None:result["backend"]=response.backend
        raw_path=audit/"raw_response.txt"; payload_path=audit/"raw_payload.json"
        atomic_write_text(raw_path,response.text)
        atomic_write_json(payload_path,response.raw)
        result.update(model_id=response.model_id,revision=response.revision,raw_response_file=str(raw_path),raw_payload_file=str(payload_path),generation={"finish_reason":response.finish_reason,"provider_finish_reason":response.provider_finish_reason},usage={"input_tokens":response.input_tokens,"output_tokens":response.output_tokens,"reasoning_tokens":response.reasoning_tokens,"requested_max_tokens":request["max_tokens"]})
        # Persist observations before extraction; a later crash still leaves usage.
        result["elapsed_seconds"]=round(time.monotonic()-started,6)
        atomic_write_json(audit/"call_metadata.json",result)
        kind=request["response_kind"]
        if kind=="rtl":
            result["stage"]="rtl_extraction"
            extracted=extract_rtl(response.text,request["top_module"])
            source=output/request["source_name"]
            atomic_write_text(source,extracted.source)
            result.update(source_file=str(source),source_kind=extracted.source_kind,rtl_status="complete")
        else:
            result["stage"]="json_validation"
            # Read only the controller-authored delta, never audit text as context.
            schema_kind = kind
            if kind == "analyst":
                try: delta = loads(request["prompt"].split("\n\nSTAGE_DELTA\n", 1)[1])
                except (IndexError, ContractError): raise ContractError("missing analyst stage context")
                if "previous_attempt" in delta:
                    schema_kind = "rebuild"
            value=parse_json_answer(response.text,schema_kind)
            answer=output/"answer.json"; atomic_write_json(answer,value)
            result["answer_file"]=str(answer)
        result.update(status="success",stage="complete",error=None)
    except Exception as exc:
        if hasattr(exc,"backend"):
            result["backend"]=exc.backend
            atomic_write_json(audit/"backend_drain.json",exc.backend)
        if hasattr(exc,"raw"):
            path=audit/"raw_payload.json";atomic_write_json(path,exc.raw)
            result["raw_payload_file"]=str(path)
            metadata=exc.metadata
            result["usage"]={k:metadata[k] for k in ("input_tokens","output_tokens","reasoning_tokens","requested_max_tokens")}
            result["generation"]={k:metadata[k] for k in ("finish_reason","provider_finish_reason")}
        result["error"]=error_details(getattr(exc,"code",type(exc).__name__), str(exc),
                                      retryable=isinstance(exc,(ProtocolError,ContractError)) and result["raw_response_file"] is not None)
        atomic_write_json(audit/"exception.json", {"type":type(exc).__name__, "message":str(exc)})
        if isinstance(exc,ModelTimeoutError): result["generation"]["finish_reason"]="timeout"
        elif isinstance(exc,ModelClientError) and result["generation"]["finish_reason"]=="unknown": result["generation"]["finish_reason"]="error"
        if result["stage"]=="rtl_extraction": result["rtl_status"]="incomplete"
    result["elapsed_seconds"]=round(time.monotonic()-started,6)
    check("call",result)
    atomic_write_json(audit/"call_metadata.json",result)
    return result
