"""Stable model-service boundary shared by Agent and baseline."""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Protocol, runtime_checkable


class ModelClientError(RuntimeError):
    """A model request failed without producing a usable response."""


class ModelTimeoutError(ModelClientError):
    """A model request exceeded its configured timeout."""


@dataclass(frozen=True)
class ModelResponse:
    """Normalized response while retaining the service's raw payload."""

    text: str
    model_id: str
    revision: str
    elapsed_seconds: float = 0.0
    raw: Any = field(default=None, compare=False)
    finish_reason: str = "unknown"
    provider_finish_reason: str | None = None
    input_tokens: int | None = None
    output_tokens: int | None = None
    reasoning_tokens: int | None = None
    requested_max_tokens: int | None = None
    backend: dict[str, Any] | None = field(default=None, compare=False)


@runtime_checkable
class ModelClient(Protocol):
    """The only generation operation used by orchestration code."""

    def generate(self, prompt: str, max_tokens: int, temperature: float) -> ModelResponse:
        """Generate one response or raise an explicit ModelClientError."""


def response_metadata(raw: Any, requested_max_tokens: int) -> dict[str, Any]:
    """Read provider observations; missing/ambiguous finish causes stay unknown."""
    payload=raw if isinstance(raw,dict) else {}
    choices=payload.get("choices")
    provider=payload.get("finish_reason")
    if provider is None and isinstance(choices,list) and choices and isinstance(choices[0],dict):
        provider=choices[0].get("finish_reason")
    provider=provider if isinstance(provider,str) else None
    reasons={"eos":"eos","eos_token":"eos","end_turn":"eos","stop_sequence":"stop_sequence","length":"length","max_tokens":"length","timeout":"timeout","cancelled":"cancelled","error":"error"}
    # Generic 'stop' does not tell EOS from a configured stop sequence.
    reason=reasons.get(provider,"unknown")
    usage=payload.get("usage") if isinstance(payload.get("usage"),dict) else payload
    def count(*keys):
        for key in keys:
            value=usage.get(key)
            if type(value) is int and value>=0: return value
        return None
    details=usage.get("completion_tokens_details",{})
    reasoning=count("reasoning_tokens")
    if reasoning is None and isinstance(details,dict):
        value=details.get("reasoning_tokens")
        if type(value) is int and value>=0: reasoning=value
    return {"finish_reason":reason,"provider_finish_reason":provider,"input_tokens":count("input_tokens","prompt_tokens"),"output_tokens":count("output_tokens","completion_tokens"),"reasoning_tokens":reasoning,"requested_max_tokens":requested_max_tokens}
