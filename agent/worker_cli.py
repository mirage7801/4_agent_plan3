"""Worker entry points for model and EDA execution boundaries.

The Controller communicates with these workers only through request and response
JSON files.  Workers never choose a task, RTL version, or next action.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from config.loader import load_config
from serve.factory import create_model_client

from .core.eda_adapter import create_eda_adapter, OwnedProcessTimeout
from .contracts.messages import AgentMessage, MessageContractError
from .core.storage import atomic_write_json, atomic_write_text, assert_runtime_identity, RuntimeIdentityError
from .core.task import load_task
from .core.task_facts import verify_facts


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="python -m agent.worker_cli")
    sub = parser.add_subparsers(dest="command", required=True)
    for name in ("llm-generate", "vivado-validate"):
        command = sub.add_parser(name)
        command.add_argument("--request", required=True)
        command.add_argument("--response", required=True)
        command.add_argument("--config", required=True)
    return parser


def _read(path: str) -> dict:
    return AgentMessage.from_file(path).to_dict()


def _write(path: str, value: dict) -> None:
    atomic_write_json(Path(path), value)


def _llm(request: dict, config: dict) -> dict:
    from .core.output_protocol import execute_call
    worker_config=config
    if config["model"]["service_type"] == "mock" and "mock_response_index" in request:
        index=request["mock_response_index"]
        responses=config["mock"]["model_responses"]
        if index>=len(responses):
            from .core.output_protocol import failure_envelope
            return failure_envelope(request,config,"MOCK_EXHAUSTED","mock response sequence exhausted")
        worker_config=dict(config); worker_config["_identity_config"]=config; worker_config["mock"]=dict(config["mock"])
        worker_config["mock"]["model_responses"]=[responses[index]]
    return execute_call(request,config,create_model_client(worker_config))


def _vivado(request: dict, config: dict) -> dict:
    binding = request.get("context_binding")
    if binding:
        facts = json.loads(Path(binding["facts_path"]).read_text(encoding="utf-8"))
        verify_facts(facts, binding["facts_ref"])
    worker_config = config
    if config["eda"]["adapter"] == "mock" and "mock_eda_scenario_index" in request:
        index = int(request["mock_eda_scenario_index"])
        scenarios = config["mock"]["eda_scenarios"]
        if index < 0 or index >= len(scenarios):
            raise ValueError(f"mock EDA scenario index out of range: {index}")
        worker_config = dict(config)
        worker_config["mock"] = dict(config["mock"])
        worker_config["mock"]["eda_scenarios"] = [scenarios[index]]
    task = load_task(request["task_path"])
    try:
        record = create_eda_adapter(worker_config).validate(
            task,
            Path(request["source_path"]).resolve(),
            Path(request["output_dir"]).resolve(),
        )
    except OwnedProcessTimeout as exc:
        return {"schema_version":"1.0","task_id":request["task_id"],"run_id":request["run_id"],
                "exit_code":2,"context_binding":binding,"result_file":str(Path(request["output_dir"])/"result.json"),
                "output_dir":request["output_dir"],"result":{"passed":False,"stage":"environment","error_type":"eda_adapter_timeout",
                "summary":str(exc),"local_cleanup_confirmed":exc.cleaned,"owned_process_pid":exc.pid}}
    return {
        "schema_version": "1.0",
        "task_id": request["task_id"],
        "run_id": request["run_id"],
        "exit_code": record.exit_code,
        "context_binding": request.get("context_binding"),
        "result_file": str(record.output_dir / "result.json"),
        "output_dir": str(record.output_dir),
        "result": record.result,
    }


def main(argv: list[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    envelope = _read(args.request)
    if envelope["message_type"] != args.command:
        raise MessageContractError(
            f"request message_type {envelope['message_type']!r} does not match {args.command!r}"
        )
    request = dict(envelope["payload"])
    request.setdefault("task_id", envelope["task_id"])
    request.setdefault("run_id", envelope["run_id"])
    config = load_config(args.config)
    if args.command == "llm-generate":
        try:
            if request.get('runtime_identity'):assert_runtime_identity(request['runtime_identity'],config)
            result = _llm(request, config)
        except Exception as exc:
            from .core.output_protocol import failure_envelope
            result=failure_envelope(request,config,getattr(exc,"code","WORKER_SETUP_ERROR"),str(exc))
    elif args.command == "vivado-validate":
        try:
            if request.get('runtime_identity'):assert_runtime_identity(request['runtime_identity'],config)
            result = _vivado(request, config)
        except RuntimeIdentityError as exc:
            result={"schema_version":"1.0","task_id":request['task_id'],"run_id":request['run_id'],"exit_code":2,
                    "context_binding":request.get('context_binding'),"result_file":str(Path(request['output_dir'])/'result.json'),
                    "output_dir":request['output_dir'],"result":{"passed":False,"stage":"environment","error_type":"runtime_identity_mismatch","summary":str(exc)}}
    if request.get('runtime_identity'):result['runtime_identity']=request['runtime_identity']
    _write(args.response, result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
