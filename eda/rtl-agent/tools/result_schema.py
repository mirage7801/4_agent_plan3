"""Stable result construction and lightweight JSON-schema validation."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STAGES = ("environment", "compile", "elaborate", "simulation", "synthesis", "complete")
ERROR_TYPES = (
    "tool_not_found", "unsupported_part", "license_error", "timeout", "syntax_error",
    "module_not_found", "port_mismatch", "width_mismatch", "elaboration_error",
    "functional_mismatch", "reset_behavior_error", "latency_mismatch",
    "simulation_timeout", "unknown_value", "multiple_driver", "latch_inferred",
    "combinational_loop", "unsynthesizable_construct", "synthesis_error",
    "unknown_error", "none",
)
TIMING_KEYS = ("compile_seconds", "elaborate_seconds", "simulation_seconds", "synthesis_seconds", "total_seconds")


def _check(value: object, schema: dict, location: str = "$") -> None:
    kinds = schema.get("type")
    if kinds is not None:
        accepted = kinds if isinstance(kinds, list) else [kinds]
        predicates = {
            "object": lambda x: isinstance(x, dict),
            "array": lambda x: isinstance(x, list),
            "string": lambda x: isinstance(x, str),
            "number": lambda x: isinstance(x, (int, float)) and not isinstance(x, bool),
            "boolean": lambda x: isinstance(x, bool),
            "null": lambda x: x is None,
        }
        if not any(predicates[kind](value) for kind in accepted):
            raise ValueError(f"{location}: expected {accepted}")
    if "const" in schema and value != schema["const"]:
        raise ValueError(f"{location}: invalid constant")
    if "enum" in schema and value not in schema["enum"]:
        raise ValueError(f"{location}: invalid enum")
    if isinstance(value, dict):
        missing = set(schema.get("required", [])) - set(value)
        if missing:
            raise ValueError(f"{location}: missing {sorted(missing)}")
        properties = schema.get("properties", {})
        if schema.get("additionalProperties") is False and set(value) - set(properties):
            raise ValueError(f"{location}: unexpected keys {sorted(set(value) - set(properties))}")
        for key, item in value.items():
            if key in properties:
                _check(item, properties[key], f"{location}.{key}")
    elif isinstance(value, list) and "items" in schema:
        for index, item in enumerate(value):
            _check(item, schema["items"], f"{location}[{index}]")
    elif isinstance(value, str):
        if len(value) < schema.get("minLength", 0) or len(value) > schema.get("maxLength", float("inf")):
            raise ValueError(f"{location}: invalid length")
    elif isinstance(value, (int, float)) and not isinstance(value, bool):
        if value < schema.get("minimum", float("-inf")) or value <= schema.get("exclusiveMinimum", float("-inf")):
            raise ValueError(f"{location}: value below minimum")


def new_result(source: str, testbench: str, top: str, part: str, clock_period_ns: float) -> dict:
    return {
        "schema_version": "1.0", "passed": False, "stage": "environment",
        "error_type": "none", "summary": "尚未执行", "source": str(source),
        "testbench": str(testbench), "top_module": top, "part": part,
        "clock_period_ns": float(clock_period_ns), "vivado_version": None,
        "timings": {key: 0.0 for key in TIMING_KEYS}, "commands": [],
        "log_files": [], "artifacts": [], "warnings": [],
    }


def short_summary(value: str) -> str:
    return " ".join(str(value).split())[:1000]


def validate_result(result: dict) -> None:
    schema = json.loads((ROOT / "interfaces" / "result.schema.json").read_text(encoding="utf-8"))
    _check(result, schema)


def validate_task(task: dict) -> None:
    schema = json.loads((ROOT / "interfaces" / "task.schema.json").read_text(encoding="utf-8"))
    _check(task, schema)
