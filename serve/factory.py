"""Construct the configured model client without hidden fallbacks."""

from __future__ import annotations

from typing import Any

from .clients import HttpModelClient, MockModelClient


def create_model_client(config: dict[str, Any]):
    model = config["model"]
    service_type = model["service_type"]
    if service_type == "mock":
        return MockModelClient(
            config["mock"]["model_responses"],
            model_id=model["id"],
            revision=model["revision"],
        )
    if service_type == "http":
        return HttpModelClient(
            url=model["url"],
            model_id=model["id"],
            revision=model["revision"],
            timeout_seconds=model["request_timeout_seconds"],
            response_text_field=model["response_text_field"],
            extra_request_fields=model.get("extra_request_fields"),
            backend_drain=model.get("backend_drain"),
            token_count_preflight=model.get("token_count_preflight", False),
        )
    raise ValueError(f"unsupported model service_type: {service_type}")
