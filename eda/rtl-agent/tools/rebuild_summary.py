"""Rebuild batch reports from authoritative per-run result.json files, no tool reruns."""
from __future__ import annotations

import json
import sys
from pathlib import Path

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from tools.result_schema import ROOT, validate_result


def main() -> int:
    entries = []
    for task_file in sorted((ROOT / "demo_tasks").glob("*/task.json")):
        task = json.loads(task_file.read_text(encoding="utf-8"))
        runs = list((ROOT / "outputs" / "batch" / task["task_id"]).glob("*/result.json"))
        if not runs:
            continue
        result_file = max(runs, key=lambda path: path.parent.name)
        result = json.loads(result_file.read_text(encoding="utf-8"))
        validate_result(result)
        ran = {record["stage"] for record in result["commands"]}
        entries.append({
            "task_id": task["task_id"], "passed": result["passed"],
            "compile_passed": "compile" in ran and result["stage"] not in ("environment", "compile"),
            "simulation_passed": "simulation" in ran and result["stage"] not in ("environment", "compile", "elaborate", "simulation"),
            "synthesis_passed": result["passed"], "failed_stage": None if result["passed"] else result["stage"],
            "error_type": result["error_type"], "timings": result["timings"],
            "log_directory": result["output_dir"],
            "exit_code": 0 if result["passed"] else 2 if result["stage"] == "environment" else 1,
            "result_file": str(result_file),
        })
    summary = {"schema_version": "1.0", "implementation": "reference", "tasks": entries,
               "all_passed": len(entries) == 10 and all(entry["passed"] for entry in entries)}
    reports = ROOT / "reports"
    reports.mkdir(exist_ok=True)
    (reports / "validation_summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    lines = ["# Reference batch validation", "", "Rebuilt from real per-task `result.json` files; no synthetic or inferred success.", "",
             "| Task | Compile | Simulation | Synthesis | Failed stage | Error | Seconds (C/E/Sim/Synth) | Logs |",
             "|---|---|---|---|---|---|---|---|"]
    for entry in entries:
        times = entry["timings"]
        seconds = "/".join(str(times[f"{stage}_seconds"]) for stage in ("compile", "elaborate", "simulation", "synthesis"))
        lines.append(f"| {entry['task_id']} | {entry['compile_passed']} | {entry['simulation_passed']} | {entry['synthesis_passed']} | {entry['failed_stage'] or '-'} | {entry['error_type']} | {seconds} | `{entry['log_directory']}` |")
    (reports / "validation_summary.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return 0 if summary["all_passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
