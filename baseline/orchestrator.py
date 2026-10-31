"""Fair single-call baseline using the Agent's model, prompt and extractor."""

from __future__ import annotations

import json
import time
from pathlib import Path
from typing import Any

from agent.core.eda_adapter import EdaAdapter, EdaAdapterError, is_environment_failure
from agent.core.prompts import build_initial_prompt
from agent.core.storage import (
    RunStore,
    atomic_write_json,
    atomic_write_text,
    code_version,
    reserve_run_directory,
    utc_timestamp,
)
from agent.core.task import TaskSpec, load_task
from config.loader import redacted_snapshot
from serve.backend_lifecycle import backend_summary, observation
from model.contracts import ModelClient, ModelClientError, ModelTimeoutError
from model.extraction import ExtractionError, extract_rtl


def _json_safe(value: Any) -> Any:
    try:
        json.dumps(value)
        return value
    except (TypeError, ValueError):
        return repr(value)


class BaselineRunner:
    def __init__(self, config: dict[str, Any], model_client: ModelClient, eda_adapter: EdaAdapter):
        self.config = config
        self.model_client = model_client
        self.eda_adapter = eda_adapter

    def run(
        self,
        problem: str | Path | TaskSpec,
        output_root: str | Path | None = None,
        run_id: str | None = None,
    ) -> dict[str, Any]:
        started_monotonic = time.monotonic()
        started_at = utc_timestamp()
        task = problem if isinstance(problem, TaskSpec) else load_task(problem)
        public_problem = task.public_snapshot()
        run_dir = reserve_run_directory(
            output_root or self.config["experiment"]["output_root"], run_id
        )
        store = RunStore(run_dir, "baseline")
        mock_run = (
            self.config["model"]["service_type"] == "mock"
            or self.config["eda"]["adapter"] == "mock"
        )
        manifest = {
            "schema_version": "1.0",
            "run_id": run_dir.name,
            "mode": "baseline",
            "mock": mock_run,
            "started_at": started_at,
            "ended_at": None,
            "code_version": code_version(Path(__file__).resolve().parents[1]),
            "task_id": task.task_id,
            "task_version": task.version,
            "model": {
                "id": self.config["model"]["id"],
                "revision": self.config["model"]["revision"],
                "service_type": self.config["model"]["service_type"],
            },
            "eda_adapter": self.config["eda"]["adapter"],
        }
        store.initialize(redacted_snapshot(self.config), public_problem, manifest)
        attempt_dir = store.attempt_directory(1)
        prompt = build_initial_prompt(public_problem)
        atomic_write_text(attempt_dir / "prompt.txt", prompt)
        attempt = {
            "attempt": 1,
            "started_at": utc_timestamp(),
            "prompt_file": str(attempt_dir / "prompt.txt"),
            "raw_response_file": str(attempt_dir / "raw_response.txt"),
            "model_calls": [
                {
                    "request_number": 1,
                    "max_tokens": self.config["model"]["max_tokens"],
                    "temperature": self.config["model"]["temperature"],
                }
            ],
        }
        passed = False
        environment_failure = False
        stop_reason = "generation_failed"
        final_source: str | None = None
        vivado_version: str | None = None
        model_failures = 0
        try:
            response = self.model_client.generate(
                prompt,
                int(self.config["model"]["max_tokens"]),
                float(self.config["model"]["temperature"]),
            )
            attempt["model_calls"][0].update(
                status="ok", elapsed_seconds=response.elapsed_seconds, generation={"finish_reason":response.finish_reason,"provider_finish_reason":response.provider_finish_reason}, usage={"input_tokens":response.input_tokens,"output_tokens":response.output_tokens,"reasoning_tokens":response.reasoning_tokens,"requested_max_tokens":int(self.config["model"]["max_tokens"])}
            )
        except ModelTimeoutError as exc:
            model_failures = 1
            attempt["model_calls"][0].update(status="timeout", error=str(exc),backend=getattr(exc,"backend",observation(state="unknown",reason="timeout_without_status")))
            atomic_write_text(attempt_dir / "raw_response.txt", "")
            attempt.update(status="model_timeout", summary=str(exc))
            stop_reason = "model_timeout" if attempt["model_calls"][0]["backend"]["next_task_allowed"] else "model_timeout_backend_unknown"
            response = None
        except ModelClientError as exc:
            model_failures = 1
            attempt["model_calls"][0].update(status="error", error=str(exc))
            if hasattr(exc,"backend"):attempt["model_calls"][0]["backend"]=exc.backend
            atomic_write_text(attempt_dir / "raw_response.txt", "")
            attempt.update(status="model_error", summary=str(exc))
            stop_reason = "backend_state_unknown" if not getattr(exc,"backend",{}).get("next_task_allowed",True) else "model_service_busy" if getattr(exc,"code",None)=="MODEL_SERVICE_BUSY" else "model_error"
            response = None

        if response is not None:
            if response.backend is not None:attempt["model_calls"][0]["backend"]=response.backend
            atomic_write_text(attempt_dir / "raw_response.txt", response.text)
            atomic_write_json(
                attempt_dir / "response.json",
                {
                    "model_id": response.model_id,
                    "revision": response.revision,
                    "elapsed_seconds": response.elapsed_seconds,
                    "raw": _json_safe(response.raw),
                },
            )
            try:
                extracted = extract_rtl(response.text, task.top_module)
            except ExtractionError as exc:
                attempt.update(
                    status="generation_failed",
                    error_type=type(exc).__name__,
                    summary=str(exc),
                )
                stop_reason = "extraction_failure"
            else:
                source_path = attempt_dir / f"solution{task.source_suffix}"
                atomic_write_text(source_path, extracted.source)
                final_source = str(source_path)
                attempt["extraction"] = {
                    "source_kind": extracted.source_kind,
                    "selected_block_index": extracted.selected_block_index,
                    "discovered_modules": list(extracted.discovered_modules),
                    "source_path": str(source_path),
                }
                if self.config["baseline"]["validate"]:
                    try:
                        validation = self.eda_adapter.validate(
                            task, source_path, attempt_dir / "validation"
                        )
                    except EdaAdapterError as exc:
                        environment_failure = True
                        attempt.update(
                            status="environment_failed",
                            error_type="eda_adapter_error",
                            summary=str(exc),
                        )
                        stop_reason = "environment_failure"
                    else:
                        result = validation.result
                        vivado_version = result.get("vivado_version")
                        attempt["validation"] = {
                            "exit_code": validation.exit_code,
                            "result_file": str(validation.output_dir / "result.json"),
                            "output_dir": str(validation.output_dir),
                            "passed": result.get("passed"),
                            "stage": result.get("stage"),
                            "error_type": result.get("error_type"),
                            "summary": result.get("summary"),
                            "vivado_version": vivado_version,
                        }
                        passed = bool(result.get("passed"))
                        environment_failure = is_environment_failure(result)
                        attempt["status"] = (
                            "passed" if passed else "environment_failed" if environment_failure else "candidate_failed"
                        )
                        stop_reason = (
                            "success" if passed else "environment_failure" if environment_failure else "single_generation_failed"
                        )
                else:
                    attempt["status"] = "generated"
                    stop_reason = "generated_without_validation"

        ended_at = utc_timestamp()
        attempt.update(
            stop_reason=stop_reason,
            ended_at=ended_at,
            wall_clock_seconds=round(time.monotonic() - started_monotonic, 6),
        )
        atomic_write_json(attempt_dir / "attempt.json", attempt)
        final = {
            "schema_version": "1.0",
            "mode": "baseline",
            "mock": mock_run,
            "task_id": task.task_id,
            "task_version": task.version,
            "passed": passed,
            "first_attempt_passed": passed,
            "stop_reason": stop_reason,
            "attempt_count": 1,
            "repair_count": 0,
            "model_failure_count": model_failures,
            "environment_failure": environment_failure,
            "vivado_version": vivado_version,
            "final_source": final_source,
            "attempts": [attempt],
            "started_at": started_at,
            "ended_at": ended_at,
            "wall_clock_seconds": round(time.monotonic() - started_monotonic, 6),
            "model": {
                "id": self.config["model"]["id"],
                "revision": self.config["model"]["revision"],
                "max_tokens": self.config["model"]["max_tokens"],
                "temperature": self.config["model"]["temperature"],
                "context_length": self.config["model"]["context_length"],
                "request_timeout_seconds": self.config["model"]["request_timeout_seconds"],
            },
        }
        final.update(backend_summary(attempt["model_calls"]))
        store.finish(final)
        return {**final, "run_dir": str(run_dir)}
