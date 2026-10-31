"""Read the frozen validator task format while exposing only public prompt data."""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


class TaskError(ValueError):
    """The requested public task is missing or malformed."""


@dataclass(frozen=True)
class TaskSpec:
    root: Path
    metadata_path: Path
    public_text_path: Path
    metadata: dict[str, Any]
    public_text: str
    testbench_path: Path
    constraints_path: Path | None
    version: str

    @property
    def task_id(self) -> str:
        return str(self.metadata["task_id"])

    @property
    def top_module(self) -> str:
        return str(self.metadata["top_module"])

    @property
    def language(self) -> str:
        return str(self.metadata["language"])

    @property
    def source_suffix(self) -> str:
        return ".sv" if self.language == "systemverilog" else ".v"

    def public_snapshot(self) -> dict[str, Any]:
        """Return only fields allowed in storage and model context."""

        return {
            "schema_version": self.metadata["schema_version"],
            "task_id": self.task_id,
            "description": self.metadata["description"],
            "public_problem": self.public_text,
            "language": self.language,
            "top_module": self.top_module,
            "expected_source_file": self.metadata["expected_source_file"],
            "part": self.metadata["part"],
            "clock_period_ns": self.metadata["clock_period_ns"],
            "timeouts": self.metadata["timeouts"],
            "task_version": self.version,
        }


_REQUIRED = {
    "schema_version",
    "task_id",
    "description",
    "language",
    "top_module",
    "expected_source_file",
    "testbench",
    "constraints",
    "part",
    "clock_period_ns",
    "timeouts",
}


def _resolve_task_files(problem: str | Path) -> tuple[Path, Path, Path]:
    value = Path(problem).expanduser().resolve()
    if value.is_dir():
        metadata = value / "task.json"
        public_text = value / "task.txt"
        return value, metadata, public_text
    if value.is_file() and value.suffix.lower() == ".json":
        return value.parent, value, value.parent / "task.txt"
    if value.is_file() and value.name == "task.txt":
        return value.parent, value.parent / "task.json", value
    raise TaskError(f"problem path must be a task directory, task.json, or task.txt: {value}")


def load_task(problem: str | Path) -> TaskSpec:
    root, metadata_path, public_text_path = _resolve_task_files(problem)
    if not metadata_path.is_file():
        raise TaskError(f"task metadata not found: {metadata_path}")
    if not public_text_path.is_file():
        raise TaskError(f"public task text not found: {public_text_path}")
    try:
        metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise TaskError(f"invalid task JSON: {exc}") from exc
    if not isinstance(metadata, dict):
        raise TaskError("task metadata root must be an object")
    missing = _REQUIRED - set(metadata)
    if missing:
        raise TaskError(f"task metadata missing fields: {sorted(missing)}")
    if metadata["schema_version"] != "1.0":
        raise TaskError("only task schema_version 1.0 is supported")
    if metadata["language"] not in {"verilog", "systemverilog"}:
        raise TaskError("task language must be verilog or systemverilog")
    public_text = public_text_path.read_text(encoding="utf-8")
    if not public_text.strip():
        raise TaskError("public task text is empty")
    testbench = (root / str(metadata["testbench"])).resolve()
    constraints_value = metadata.get("constraints")
    constraints = (root / str(constraints_value)).resolve() if constraints_value else None
    digest = hashlib.sha256()
    public_metadata = {
        key: value
        for key, value in metadata.items()
        if key not in {"testbench", "constraints"}
    }
    digest.update(json.dumps(public_metadata, sort_keys=True, ensure_ascii=False).encode("utf-8"))
    digest.update(b"\0")
    digest.update(public_text.encode("utf-8"))
    return TaskSpec(
        root=root,
        metadata_path=metadata_path,
        public_text_path=public_text_path,
        metadata=metadata,
        public_text=public_text,
        testbench_path=testbench,
        constraints_path=constraints,
        version=digest.hexdigest(),
    )
