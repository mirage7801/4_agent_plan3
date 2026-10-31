"""File-backed messages used by the worker execution boundary."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any
from .schemas import check, loads, ContractError


MESSAGE_TYPES = {"llm-generate", "vivado-validate"}
_REQUEST_FIELDS = {
    "llm-generate": ("prompt", "top_module", "output_dir"),
    "vivado-validate": ("task_path", "source_path", "output_dir"),
}
_RESPONSE_FIELDS = {
    "llm-generate": ("raw_response_file", "source_file", "model_id", "revision"),
    "vivado-validate": ("result_file", "output_dir", "result", "exit_code"),
}


class MessageContractError(ValueError):
    """A worker request or response violates the versioned JSON contract."""


@dataclass(frozen=True)
class AgentMessage:
    """A versioned request/response envelope exchanged through JSON files."""

    schema_version: str
    message_type: str
    task_id: str
    run_id: str
    payload: dict[str, Any]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, value: Any) -> "AgentMessage":
        if not isinstance(value, dict):
            raise MessageContractError("message must be a JSON object")
        if value.get("schema_version") != ("2.0" if value.get("message_type")=="llm-generate" else "1.0"):
            raise MessageContractError("unsupported message schema_version")
        message_type = value.get("message_type")
        if message_type not in MESSAGE_TYPES:
            raise MessageContractError(f"unsupported message_type: {message_type!r}")
        task_id = value.get("task_id")
        run_id = value.get("run_id")
        payload = value.get("payload")
        if not isinstance(task_id, str) or not task_id:
            raise MessageContractError("task_id must be a non-empty string")
        if not isinstance(run_id, str) or not run_id:
            raise MessageContractError("run_id must be a non-empty string")
        if not isinstance(payload, dict):
            raise MessageContractError("payload must be an object")
        missing = [field for field in _REQUEST_FIELDS[message_type] if not payload.get(field)]
        if missing:
            raise MessageContractError(
                f"{message_type} request missing required payload fields: {', '.join(missing)}"
            )
        if set(value)!={"schema_version","message_type","task_id","run_id","payload"}:
            raise MessageContractError("unexpected envelope fields")
        if message_type=="llm-generate":
            try: check("llm_payload",payload)
            except ContractError as exc: raise MessageContractError(str(exc)) from exc
        return cls(value["schema_version"], message_type, task_id, run_id, payload)

    @classmethod
    def from_file(cls, path: str | Path) -> "AgentMessage":
        try:
            value = loads(Path(path).read_text(encoding="utf-8"))
            return cls.from_dict(value)
        except (OSError, ValueError) as exc:
            raise MessageContractError(f"invalid agent message: {path}: {exc}") from exc


def validate_worker_response(message_type: str, value: Any, task_id: str, run_id: str) -> dict[str, Any]:
    """Validate the flat response written by a worker process."""
    if message_type not in MESSAGE_TYPES:
        raise MessageContractError(f"unsupported message_type: {message_type!r}")
    if not isinstance(value, dict):
        raise MessageContractError("worker response must be an object")
    if value.get("schema_version") != ("2.0" if message_type=="llm-generate" else "1.0"):
        raise MessageContractError("worker response has unsupported schema_version")
    if value.get("task_id") != task_id or value.get("run_id") != run_id:
        raise MessageContractError("worker response task_id/run_id do not match request")
    missing = [field for field in _RESPONSE_FIELDS[message_type] if field not in value]
    if missing:
        raise MessageContractError(
            f"{message_type} response missing required fields: {', '.join(missing)}"
        )
    if message_type=="llm-generate":
        try:
            check("call",value)
            if value["status"]=="success":
                if value["error"] is not None or value["stage"]!="complete": raise ContractError("success has error state")
                artifact="source_file" if value["response_kind"]=="rtl" else "answer_file"
                if value[artifact] is None: raise ContractError("successful call has no final artifact")
            elif value["error"] is None: raise ContractError("failed call requires error")
        except ContractError as exc: raise MessageContractError(str(exc)) from exc
    return value
