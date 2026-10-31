"""Recover a candidate-search run from immutable files without model/EDA calls."""

from __future__ import annotations

import json
import time
from pathlib import Path
from typing import Any

from .core.task_facts import verify_facts
from .core.storage import atomic_write_json, utc_timestamp, read_events
from .runtime.reporting import collect_evidence


def _read_json(path: Path) -> dict[str, Any] | None:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None
    return value if isinstance(value, dict) else None


def _recover_attempts(run_dir: Path) -> list[dict[str, Any]]:
    attempts: list[dict[str, Any]] = []
    candidates = run_dir / "candidates"
    if not candidates.is_dir():
        return attempts
    for candidate_dir in sorted(candidates.glob("candidate_*")):
        candidate_id = candidate_dir.name
        for validation_dir in sorted(candidate_dir.glob("validation_*")):
            result = _read_json(validation_dir / "result.json")
            if result is None:
                continue
            try:
                repair_index = int(validation_dir.name.rsplit("_", 1)[1])
            except (ValueError, IndexError):
                repair_index = 0
            attempts.append({
                "candidate_id": candidate_id,
                "repair_index": repair_index,
                "validation": result,
                "wall_clock_seconds": float(result.get("timings", {}).get("total_seconds", 0.0) or 0.0),
                "timings": result.get("timings", {}),
                "recovered": True,
            })
    return attempts


def _recover_state(run_dir: Path, attempts: list[dict[str, Any]], pending_rtl: bool) -> dict[str, Any]:
    """Recover the controller checkpoint, not only its final report."""
    checkpoint = _read_json(run_dir / "search_state.json") or {}
    if checkpoint.get("current_state"):
        return {"current_state": checkpoint["current_state"],
                "detail": checkpoint.get("detail", ""),
                "transitions": read_events(run_dir),
                "next_action": "resume_from_checkpoint"}
    if any(item.get("validation", {}).get("passed") for item in attempts):
        state = "FINAL"
        action = "none"
    elif attempts:
        state = "DIAGNOSE"
        action = "continue_candidate_search"
    elif pending_rtl:
        state = "VIVADO"
        action = "validate_pending_candidate"
    else:
        state = "INTAKE"
        action = "restart_run"
    return {"current_state": state, "detail": "inferred from persisted evidence",
            "transitions": [], "next_action": action}


def resume_run(run_dir: str | Path) -> dict[str, Any]:
    root = Path(run_dir).expanduser().resolve()
    manifest_path = root / "run_manifest.json"
    manifest = _read_json(manifest_path)
    if manifest is None:
        raise ValueError(f"run_manifest.json not found or invalid: {root}")
    facts = _read_json(root / "task_facts.json")
    if facts is not None:
        verify_facts(facts)
        for binding_file in (root / "candidates").glob("*/generation.json"):
            binding = _read_json(binding_file) or {}
            if binding.get("facts_ref"):
                verify_facts(facts, binding["facts_ref"])
    mode = str(manifest.get("mode", "candidate_search"))
    mode_dir = root / mode
    final_path = mode_dir / "final.json"
    if final_path.is_file():
        result = _read_json(final_path) or {}
        return {"status": "already_complete", "run_dir": str(root), "final": result, "report_rebuilt": False, "recovered_attempts": []}

    attempts = _recover_attempts(root)
    passed = any(bool(item.get("validation", {}).get("passed")) for item in attempts)
    pending_rtl = any((root / "candidates").glob("candidate_*/solution.*")) if (root / "candidates").is_dir() else False
    resume_state = _recover_state(root, attempts, pending_rtl)
    if passed:
        stop_reason = "resumed_success"
    elif attempts:
        stop_reason = "resumed_incomplete"
    elif pending_rtl:
        stop_reason = "resume_pending_validation"
    else:
        stop_reason = "resume_no_evidence"
    now = utc_timestamp()
    final = {
        "schema_version": "2.0",
        "mode": mode,
        "mock": bool(manifest.get("mock", False)),
        "task_id": manifest.get("task_id"),
        "task_version": manifest.get("task_version"),
        "passed": passed,
        "stop_reason": stop_reason,
        "attempt_count": len(attempts),
        "candidate_count": len({item["candidate_id"] for item in attempts}),
        "repair_count": sum(1 for item in attempts if int(item.get("repair_index", 0)) > 0),
        "model_call_count": None,
        "model_seconds": None,
        "eda_seconds": round(sum(float(item.get("wall_clock_seconds", 0.0)) for item in attempts), 6),
        "wall_clock_seconds": None,
        "final_source": None,
        "attempts": attempts,
        "transitions": [{"state": "FINAL" if passed else "STOP", "detail": "recovered from persisted evidence", "at": now}],
        "started_at": manifest.get("started_at"),
        "ended_at": now,
        "recovered": True,
        "resume_state": resume_state,
    }
    if passed:
        successful = next(item for item in attempts if item["validation"].get("passed"))
        candidate_dir = root / "candidates" / successful["candidate_id"]
        repair_index = successful["repair_index"]
        source_dir = candidate_dir / f"repair_{repair_index:02d}" if repair_index else candidate_dir
        source_candidates = sorted(source_dir.glob("solution.*"))
        if source_candidates:
            final["final_source"] = str(source_candidates[-1])
    mode_dir.mkdir(parents=True, exist_ok=True)
    atomic_write_json(final_path, final)
    manifest.update({"ended_at": now, "stop_reason": stop_reason, "passed": passed})
    atomic_write_json(manifest_path, manifest)
    report_rebuilt = False
    try:
        collect_evidence(root)
        report_rebuilt = True
    except Exception as exc:  # recovery must preserve evidence even if reporting is unavailable
        final["report_error"] = str(exc)
    status = "recovered" if passed else "resumable"
    atomic_write_json(root / "resume.json", {
        "schema_version": "2.0", "status": status, "run_dir": str(root),
        "report_rebuilt": report_rebuilt, "recovered_attempts": len(attempts),
        "pending": [] if attempts else (["validation"] if pending_rtl else ["run"]),
        "resume_state": resume_state,
    })
    return {"status": status, "run_dir": str(root), "final": final, "report_rebuilt": report_rebuilt, "recovered_attempts": attempts, "resume_state": resume_state, "pending": [] if attempts else (["validation"] if pending_rtl else ["run"])}
