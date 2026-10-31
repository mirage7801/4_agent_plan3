"""Mock and generic local HTTP implementations of the model contract."""

from __future__ import annotations

import json
import http.client
import socket
import time
import uuid
import urllib.error
import urllib.request
import urllib.parse
from collections.abc import Iterable
from typing import Any

from model.contracts import ModelClientError, ModelResponse, ModelTimeoutError, response_metadata
from .backend_lifecycle import BackendLease, observation


class MockModelClient:
    """Return a deterministic sequence of responses without GPU or network."""

    def __init__(self, responses: Iterable[Any], model_id: str = "mock-model", revision: str = "mock"):
        self._responses = list(responses)
        self.model_id = model_id
        self.revision = revision
        self.calls: list[dict[str, Any]] = []

    def generate(self, prompt: str, max_tokens: int, temperature: float) -> ModelResponse:
        self.calls.append(
            {"prompt": prompt, "max_tokens": max_tokens, "temperature": temperature}
        )
        if not self._responses:
            raise ModelClientError("mock response sequence exhausted")
        item = self._responses.pop(0)
        if isinstance(item, Exception):
            raise item
        if isinstance(item, dict) and item.get("error"):
            if item["error"] == "timeout":
                raise ModelTimeoutError(item.get("message", "mock model timeout"))
            raise ModelClientError(str(item.get("message", item["error"])))
        if isinstance(item, ModelResponse):
            return item
        text = item.get("text", "") if isinstance(item, dict) else str(item)
        raw = item if isinstance(item, dict) else {"text": text}
        return ModelResponse(text=text, model_id=self.model_id, revision=self.revision, raw=raw, **response_metadata(raw,max_tokens))


class HttpModelClient:
    """Generic JSON-over-HTTP client for a configurable local model service."""

    def __init__(
        self,
        url: str,
        model_id: str,
        revision: str,
        timeout_seconds: float,
        response_text_field: str = "text",
        extra_request_fields: dict[str, Any] | None = None,
        backend_drain: dict[str, Any] | None = None,
        token_count_preflight: bool = False,
    ):
        self.backend_drain = backend_drain
        self.token_count_preflight = token_count_preflight
        self._token_count_unavailable = False
        self.url = url
        self.model_id = model_id
        self.revision = revision
        self.timeout_seconds = timeout_seconds
        self.response_text_field = response_text_field
        self.extra_request_fields = dict(extra_request_fields or {})
        if {"prompt", "model", "revision", "max_tokens", "temperature"} & self.extra_request_fields.keys():
            raise ModelClientError("extra_request_fields cannot override the assembled prompt or core generation fields")

    @staticmethod
    def _read_field(payload: Any, dotted_name: str) -> Any:
        value = payload
        for part in dotted_name.split("."):
            if not isinstance(value, dict) or part not in value:
                raise ModelClientError(f"response field {dotted_name!r} is missing")
            value = value[part]
        return value

    def count_prompt(self, prompt):
        """Optional reference-service tokenizer; never uses the generation slot."""
        if not self.token_count_preflight or self._token_count_unavailable:
            return {"status":"unknown", "reason":"not_enabled_or_unavailable"}
        parts=urllib.parse.urlsplit(self.url)
        url=urllib.parse.urlunsplit((parts.scheme,parts.netloc,parts.path.rsplit('/',1)[0]+"/tokenize","",""))
        request=urllib.request.Request(url,data=json.dumps({"prompt":prompt,"model":self.model_id,"revision":self.revision}).encode('utf-8'),
            headers={"Content-Type":"application/json"},method="POST")
        try:
            with urllib.request.urlopen(request,timeout=min(5,self.timeout_seconds)) as response:
                value=json.loads(response.read().decode('utf-8'))
            if (value.get('exact') is not True or value.get('model')!=self.model_id or value.get('revision')!=self.revision
                    or type(value.get('input_tokens')) is not int or value['input_tokens']<0
                    or type(value.get('context_length')) is not int or value['context_length']<=0):
                raise ValueError('invalid tokenizer identity/count')
            return {"status":"exact", "input_tokens":value['input_tokens'],"context_length":value['context_length']}
        except (OSError,ValueError,urllib.error.URLError,http.client.HTTPException):
            self._token_count_unavailable = True
            return {"status":"unknown", "reason":"tokenizer_endpoint_unavailable_or_invalid"}

    def generate(self, prompt: str, max_tokens: int, temperature: float) -> ModelResponse:
        with BackendLease(self.url,self.backend_drain) as lease:
            previous=lease.backend.copy()
            request_id=uuid.uuid4().hex
            lease.begin(request_id)
            request_started=time.monotonic()
            try:
                result=self._generate_http(prompt,max_tokens,temperature,request_id)
            except ModelClientError as exc:
                request_seconds=time.monotonic()-request_started
                if isinstance(exc,ModelTimeoutError) or getattr(exc,'backend_uncertain',False) or getattr(exc,'http_status',0)>=500 or getattr(exc,'http_status',0)==429:
                    exc.backend=lease.wait(request_id)
                else:
                    lease.clear()
                    exc.backend=observation(request_id)
                exc.backend["request_elapsed_seconds"]=round(request_seconds,6)
                exc.backend["previous_request_id"]=previous["request_id"]
                exc.backend["backend_drain_seconds"]=round(exc.backend["backend_drain_seconds"]+previous["backend_drain_seconds"],6)
                raise
            else:
                lease.clear()
                # Recovery of a previous request is measured, but its output is never used.
                return ModelResponse(**{**result.__dict__,'backend':{**previous,'request_id':request_id,'previous_request_id':previous['request_id'],'request_elapsed_seconds':result.elapsed_seconds}})

    def _generate_http(self, prompt, max_tokens, temperature, request_id):
        payload = {
            "model": self.model_id,
            "revision": self.revision,
            "prompt": prompt,
            "max_tokens": max_tokens,
            "temperature": temperature,
            **self.extra_request_fields,
        }
        request = urllib.request.Request(
            self.url,
            data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
            headers={"Content-Type": "application/json", "Accept": "application/json", "X-Request-ID":request_id},
            method="POST",
        )
        started = time.monotonic()
        try:
            with urllib.request.urlopen(request, timeout=self.timeout_seconds) as response:
                body = response.read().decode("utf-8")
        except (TimeoutError, socket.timeout) as exc:
            raise ModelTimeoutError(
                f"local model request timed out after {self.timeout_seconds} seconds"
            ) from exc
        except urllib.error.HTTPError as exc:
            detail = exc.read().decode("utf-8", errors="replace")[:1000]
            failure=ModelClientError(f"local model HTTP {exc.code}: {detail}")
            failure.http_status=exc.code
            if exc.code==429:failure.code="MODEL_SERVICE_BUSY"
            raise failure from exc
        except urllib.error.URLError as exc:
            if isinstance(exc.reason, (TimeoutError, socket.timeout)):
                raise ModelTimeoutError(
                    f"local model request timed out after {self.timeout_seconds} seconds"
                ) from exc
            failure=ModelClientError(f"local model service unavailable: {exc.reason}")
            failure.backend_uncertain=True
            raise failure from exc
        except (OSError, http.client.HTTPException) as exc:
            failure=ModelClientError(f"local model transport interrupted: {exc}")
            failure.backend_uncertain=True
            raise failure from exc
        try:
            decoded = json.loads(body)
        except json.JSONDecodeError as exc:
            failure=ModelClientError("local model service returned invalid JSON")
            failure.raw=body
            failure.metadata=response_metadata({},max_tokens)
            raise failure from exc
        try:
            text = self._read_field(decoded, self.response_text_field)
            if not isinstance(text,str): raise ModelClientError(f"response field {self.response_text_field!r} must be a string")
        except ModelClientError as exc:
            exc.raw=decoded
            exc.metadata=response_metadata(decoded,max_tokens)
            raise
        return ModelResponse(
            text=text,
            model_id=self.model_id,
            revision=self.revision,
            elapsed_seconds=round(time.monotonic() - started, 6),
            raw=decoded,
            **response_metadata(decoded,max_tokens),
        )
