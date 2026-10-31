"""Load, expand and validate a reproducible experiment configuration."""

from __future__ import annotations

import copy
import json
import math
import sys

from serve.backend_lifecycle import DEFAULT_DRAIN
from pathlib import Path
from typing import Any


class ConfigError(ValueError):
    """Configuration cannot safely drive an experiment."""


MAX_OUTPUT_TOKENS = 8912


DEFAULT_CONFIG: dict[str, Any] = {
    "schema_version": "1.0",
    "model": {
        "service_type": "http",
        "url": "http://127.0.0.1:8000/generate",
        "id": "unconfigured-local-model",
        "revision": "unconfigured",
        "max_tokens": MAX_OUTPUT_TOKENS,
        "temperature": 0.2,
        "context_length": 32768,
        "request_timeout_seconds": 300.0,
        "backend_drain": copy.deepcopy(DEFAULT_DRAIN),
        "response_text_field": "text",
        "extra_request_fields": {},
        "token_count_preflight": False,
    },
    "agent": {
        "architecture": "candidate_search",
        "execution_mode": "in_process",
        "analysis_max_tokens": MAX_OUTPUT_TOKENS,
        "protocol_retries": 1,
        "worker_watchdog": {"allowance_seconds":30.0,"termination_grace_seconds":10.0},
    },
    "analysis": {"mode": "after_failure"},
    "speculation": {"timing_mode":"observed", "enabled": True, "failure_reserve_calls": 2,
                    "time_reserve": {"generation_seconds":300.0,"validation_seconds":540.0,"drain_seconds":120.0}},
    "orchestration": {
        "max_model_calls": 12,
    },
    "eda": {
        "adapter": "cli",
        "validator_root": "../eda/rtl-agent",
        "validator_entry": "tools/validate_rtl.py",
        "python_executable": None,
        "target_part": "xczu3eg-sbva484-1-e",
        "clock_period_ns": 5.0,
        "timeouts": {
            "compile_seconds": 60.0,
            "elaborate_seconds": 60.0,
            "simulation_seconds": 120.0,
            "synthesis_seconds": 300.0,
        },
    },
    "baseline": {"validate": True},
    "experiment": {"output_root": "../runs"},
    "mock": {"enabled": False, "model_responses": [], "eda_scenarios": []},
    "search": {
        "max_candidates": 3,
        "max_vivado_calls": 6,
        "max_eda_seconds": 1800.0,
        "max_wall_clock_seconds": 3600.0,
        "max_repairs_per_candidate": 1,
        "memory_limit": 0,
        "failure_memory_root": "../failure_memory",
        "strategies": ["auto"],
    },
}


def _merge(base: dict[str, Any], override: dict[str, Any]) -> dict[str, Any]:
    result = copy.deepcopy(base)
    for key, value in override.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = _merge(result[key], value)
        else:
            result[key] = copy.deepcopy(value)
    return result


def _positive(value: Any, location: str) -> None:
    if not isinstance(value, (int, float)) or isinstance(value, bool) or not math.isfinite(value) or value <= 0:
        raise ConfigError(f"{location} must be a positive number")


def _validate_drain(drain):
    if not isinstance(drain,dict) or set(drain)!=set(DEFAULT_DRAIN):
        raise ConfigError("model.backend_drain must contain only max_wait_seconds, poll_interval_seconds, status_timeout_seconds, state_root")
    for name in ("max_wait_seconds","poll_interval_seconds","status_timeout_seconds"):
        _positive(drain[name],"model.backend_drain."+name)
    if not isinstance(drain["state_root"],str) or not drain["state_root"].strip():
        raise ConfigError("model.backend_drain.state_root is required")


def _validate(config: dict[str, Any]) -> None:
    if config.get("schema_version") != "1.0":
        raise ConfigError("schema_version must be '1.0'")
    allowed_top = {"schema_version", "model", "agent", "orchestration", "eda", "baseline", "experiment", "mock", "search", "speculation", "analysis"}
    unexpected = set(config) - allowed_top
    if unexpected:
        raise ConfigError(f"unexpected top-level keys: {sorted(unexpected)}")
    analysis = config["analysis"]
    if not isinstance(analysis, dict) or set(analysis) != {"mode"} or not isinstance(analysis["mode"], str) or analysis["mode"] not in {"before_generation", "after_failure", "disabled"}:
        raise ConfigError("analysis.mode must be before_generation, after_failure or disabled")
    speculation = config["speculation"]
    if not isinstance(speculation, dict) or set(speculation) != {"enabled", "failure_reserve_calls", "time_reserve", "timing_mode"}:
        raise ConfigError("speculation requires enabled, failure_reserve_calls, time_reserve and timing_mode")
    if not isinstance(speculation["timing_mode"],str) or speculation["timing_mode"] not in {"observed","fixed_window","feedback_first"}:
        raise ConfigError("speculation.timing_mode must be observed, fixed_window or feedback_first")
    if type(speculation["enabled"]) is not bool:
        raise ConfigError("speculation.enabled must be boolean")
    if type(speculation["failure_reserve_calls"]) is not int or speculation["failure_reserve_calls"] not in {1, 2}:
        raise ConfigError("speculation.failure_reserve_calls must be 1 or 2")
    reserve = speculation["time_reserve"]
    if not isinstance(reserve, dict) or set(reserve) != {"generation_seconds","validation_seconds","drain_seconds"}:
        raise ConfigError("speculation.time_reserve requires generation_seconds, validation_seconds, drain_seconds")
    for name, seconds in reserve.items():
        _positive(seconds, "speculation.time_reserve."+name)
    model = config["model"]
    if model["service_type"] not in {"mock", "http"}:
        raise ConfigError("model.service_type must be 'mock' or 'http'")
    if not isinstance(model["id"], str) or not model["id"]:
        raise ConfigError("model.id is required")
    if not isinstance(model["revision"], str) or not model["revision"]:
        raise ConfigError("model.revision is required")
    if model["service_type"] == "http" and not str(model.get("url", "")).startswith(("http://", "https://")):
        raise ConfigError("model.url must be an HTTP URL")
    if not isinstance(model["max_tokens"], int) or model["max_tokens"] <= 0:
        raise ConfigError("model.max_tokens must be a positive integer")
    if not isinstance(model["context_length"], int) or model["context_length"] <= 0:
        raise ConfigError("model.context_length must be a positive integer")
    if not isinstance(model["temperature"], (int, float)) or isinstance(model["temperature"], bool) or model["temperature"] < 0:
        raise ConfigError("model.temperature must be a non-negative number")
    _positive(model["request_timeout_seconds"], "model.request_timeout_seconds")

    if type(model["token_count_preflight"]) is not bool:
        raise ConfigError("model.token_count_preflight must be boolean")
    _validate_drain(model["backend_drain"])
    extra = model.get("extra_request_fields", {})
    if not isinstance(extra, dict) or {"prompt", "model", "revision", "max_tokens", "temperature"} & extra.keys():
        raise ConfigError("model.extra_request_fields cannot override core generation fields")

    agent = config["agent"]
    if agent.get("architecture") != "candidate_search":
        raise ConfigError("agent.architecture must be 'candidate_search'")
    if agent.get("execution_mode", "in_process") not in {"in_process", "workers"}:
        raise ConfigError("agent.execution_mode must be 'in_process' or 'workers'")
    watchdog=agent.get("worker_watchdog")
    if not isinstance(watchdog,dict) or set(watchdog)!={"allowance_seconds","termination_grace_seconds"}:
        raise ConfigError("agent.worker_watchdog requires allowance_seconds and termination_grace_seconds")
    for key,value in watchdog.items(): _positive(value,"agent.worker_watchdog."+key)
    for section, removed in ((agent, {"max_feedback_characters", "model_timeout_retries"}),
                             (config["experiment"], {"random_seed"}),
                             (config["orchestration"], {"require_evidence_manifest"})):
        if removed & section.keys():
            raise ConfigError(f"removed non-executing settings: {sorted(removed & section.keys())}; see config/README.md")

    if model["max_tokens"] != MAX_OUTPUT_TOKENS:
        raise ConfigError("model.max_tokens must be 8912 for all model stages")
    if model["context_length"] <= model["max_tokens"]:
        raise ConfigError("model.context_length must exceed 8912 and match the actual backend")
    if type(agent["analysis_max_tokens"]) is not int or agent["analysis_max_tokens"] != model["max_tokens"]:
        raise ConfigError("agent.analysis_max_tokens must equal model.max_tokens (8912)")
    if type(agent["protocol_retries"]) is not int or agent["protocol_retries"] not in {0,1}:
        raise ConfigError("agent.protocol_retries must be 0 or 1")
    search = config["search"]
    for name in ("max_candidates", "max_vivado_calls"):
        if not isinstance(search[name], int) or search[name] <= 0:
            raise ConfigError(f"search.{name} must be a positive integer")
    if not isinstance(search["memory_limit"], int) or isinstance(search["memory_limit"], bool) or search["memory_limit"] < 0:
        raise ConfigError("search.memory_limit must be a non-negative integer")
    if not isinstance(search["max_repairs_per_candidate"], int) or search["max_repairs_per_candidate"] < 0:
        raise ConfigError("search.max_repairs_per_candidate must be a non-negative integer")
    _positive(search["max_eda_seconds"], "search.max_eda_seconds")
    _positive(search["max_wall_clock_seconds"], "search.max_wall_clock_seconds")
    if not isinstance(search.get("failure_memory_root"), str) or not search["failure_memory_root"].strip():
        raise ConfigError("search.failure_memory_root must be a non-empty path")
    if "deep_spec_review" in search:
        raise ConfigError("search.deep_spec_review was removed; task facts replace the unused planner chain")
    if "validation_cache_root" in search:
        raise ConfigError("search.validation_cache_root was removed; validation deduplication is run-local")
    if not isinstance(search.get("strategies"), list) or not search["strategies"] or any(not isinstance(x, str) or not x.strip() for x in search["strategies"]):
        raise ConfigError("search.strategies must be a non-empty list of strings")

    orchestration = config["orchestration"]
    if "roles" in orchestration:
        raise ConfigError("orchestration.roles was a non-executing declaration and has been removed; dispatch is explicit in candidate_search")
    for name in ("max_model_calls",):
        if not isinstance(orchestration[name], int) or orchestration[name] <= 0:
            raise ConfigError(f"orchestration.{name} must be a positive integer")

    eda = config["eda"]
    if eda["adapter"] not in {"cli", "gitee", "mock"}:
        raise ConfigError("eda.adapter must be 'cli', 'gitee' or 'mock'")
    _positive(eda["clock_period_ns"], "eda.clock_period_ns")
    if not str(eda["target_part"]):
        raise ConfigError("eda.target_part is required")
    for name in ("compile_seconds", "elaborate_seconds", "simulation_seconds", "synthesis_seconds"):
        _positive(eda["timeouts"][name], f"eda.timeouts.{name}")
    if model["service_type"] == "mock" and not isinstance(config["mock"]["model_responses"], list):
        raise ConfigError("mock.model_responses must be a list")
    if eda["adapter"] == "mock" and not isinstance(config["mock"]["eda_scenarios"], list):
        raise ConfigError("mock.eda_scenarios must be a list")


def load_config(path: str | Path) -> dict[str, Any]:
    config_path = Path(path).expanduser().resolve()
    if not config_path.is_file():
        raise ConfigError(f"configuration file not found: {config_path}")
    try:
        raw = json.loads(config_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise ConfigError(f"invalid JSON configuration: {exc}") from exc
    if not isinstance(raw, dict):
        raise ConfigError("configuration root must be an object")
    config = _merge(DEFAULT_CONFIG, raw)
    config["_config_path"] = str(config_path)
    validator_root = Path(config["eda"]["validator_root"])
    config["eda"]["validator_root"] = str(
        (config_path.parent / validator_root).resolve()
        if not validator_root.is_absolute()
        else validator_root.resolve()
    )
    _validate_drain(config["model"]["backend_drain"])
    drain_root=Path(config["model"]["backend_drain"]["state_root"])
    config["model"]["backend_drain"]["state_root"]=str((config_path.parent/drain_root).resolve() if not drain_root.is_absolute() else drain_root.resolve())
    executable = config["eda"].get("python_executable")
    config["eda"]["python_executable"] = str(Path(executable).resolve()) if executable else sys.executable
    output_root = Path(config["experiment"]["output_root"])
    config["experiment"]["output_root"] = str(
        (config_path.parent / output_root).resolve() if not output_root.is_absolute() else output_root.resolve()
    )
    memory_root = Path(config["search"]["failure_memory_root"])
    config["search"]["failure_memory_root"] = str(
        (config_path.parent / memory_root).resolve() if not memory_root.is_absolute() else memory_root.resolve()
    )
    validation_copy = {key: value for key, value in config.items() if not key.startswith("_")}
    _validate(validation_copy)
    return config


_SENSITIVE_FRAGMENTS = ("token", "secret", "password", "api_key", "authorization", "credential")


def redacted_snapshot(config: dict[str, Any]) -> dict[str, Any]:
    """Return a serializable expanded config with likely secrets removed."""

    def redact(value: Any, key: str = "") -> Any:
        if key.lower() not in {"max_tokens", "analysis_max_tokens", "requested_max_tokens", "input_tokens", "output_tokens", "reasoning_tokens"} and any(fragment in key.lower() for fragment in _SENSITIVE_FRAGMENTS):
            return "<redacted>"
        if isinstance(value, dict):
            return {
                child_key: redact(child_value, child_key)
                for child_key, child_value in value.items()
                if not child_key.startswith("_")
            }
        if isinstance(value, list):
            return [redact(item, key) for item in value]
        return value

    return redact(config)
