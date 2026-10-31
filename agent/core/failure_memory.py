"""Small cross-run failure memory.

Only public task descriptors and projected validator feedback are persisted.
Private testbench/reference paths and raw EDA logs never enter this store.
The file is intentionally simple so it can later be replaced by a Skill
backend without changing the candidate-search controller.
"""

from __future__ import annotations

import json
import re
import time
from pathlib import Path
from typing import Any

from .storage import atomic_write_json


def _tokens(value: str) -> set[str]:
    return {t for t in re.findall(r"[a-zA-Z0-9_]+", value.lower()) if len(t) > 2}


class FailureMemory:
    def __init__(self, root: str | Path):
        self.root = Path(root).expanduser().resolve()
        self.path = self.root / "failures.json"

    def _read(self) -> list[dict[str, Any]]:
        if not self.path.is_file():
            return []
        try:
            data = json.loads(self.path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            return []
        return data if isinstance(data, list) else []

    def retrieve(self, task: dict[str, Any], limit: int = 8) -> list[dict[str, Any]]:
        if limit <= 0:
            return []
        query = _tokens(" ".join(str(task.get(k, "")) for k in ("task_id", "description", "public_problem")))
        scored: list[tuple[int, dict[str, Any]]] = []
        for item in self._read():
            score = len(query & _tokens(str(item.get("task_text", ""))))
            if item.get("task_id") == task.get("task_id"):
                score += 100
            if score:
                scored.append((score, item))
        scored.sort(key=lambda pair: (-pair[0], -float(pair[1].get("created_at", 0))))
        return [item for _, item in scored[:limit]]

    def record(self, task: dict[str, Any], feedback: dict[str, Any], action: str,
               passed: bool = False) -> None:
        item = {
            "schema_version": "1.0",
            "created_at": time.time(),
            "task_id": str(task.get("task_id", "")),
            "task_text": str(task.get("description", ""))[:1000] + " " + str(task.get("public_problem", ""))[:2000],
            "stage": str(feedback.get("stage", "")),
            "error_type": str(feedback.get("error_type", "")),
            "summary": str(feedback.get("summary", ""))[:1000],
            "diagnostics": feedback.get("diagnostics", {}),
            "action": action,
            "passed": bool(passed),
        }
        entries = self._read()
        entries.append(item)
        # Bound the memory so it remains a useful prompt artifact.
        atomic_write_json(self.path, entries[-2000:])
