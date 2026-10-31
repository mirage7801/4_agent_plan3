"""Sequential batch validation through the stable CLI, with truthful rollups."""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from tools.result_schema import ROOT, validate_task


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tasks-dir", default="demo_tasks")
    parser.add_argument("--implementation", choices=["reference"], default="reference")
    args = parser.parse_args(argv)
    tasks_dir = Path(args.tasks_dir)
    if not tasks_dir.is_absolute():
        tasks_dir = ROOT / tasks_dir
    entries = []
    for task_file in sorted(tasks_dir.glob("*/task.json")):
        task = json.loads(task_file.read_text(encoding="utf-8"))
        validate_task(task)
        folder = task_file.parent
        output = ROOT / "outputs" / "batch" / task["task_id"] / time.strftime("%Y%m%d_%H%M%S")
        command = [sys.executable, str(ROOT / "tools/validate_rtl.py"), "--source", str(folder / "reference.v"),
                   "--testbench", str(folder / task["testbench"]), "--top", task["top_module"],
                   "--part", task["part"], "--clock-period", str(task["clock_period_ns"]),
                   "--output-dir", str(output)]
        for stage in ("compile", "elaborate", "simulation", "synthesis"):
            command += [f"--{stage}-timeout", str(task["timeouts"][f"{stage}_seconds"])]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
        try:
            result = json.loads(completed.stdout)
            authoritative = Path(result.get("output_dir", str(output))) / "result.json"
            if authoritative.is_file():
                result = json.loads(authoritative.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            authoritative = output / "result.json"
            if authoritative.is_file():
                result = json.loads(authoritative.read_text(encoding="utf-8"))
            else:
                result = None
        if result is None:
            result = {"passed": False, "stage": "environment", "error_type": "unknown_error", "summary": completed.stderr[:1000],
                      "commands": [], "timings": {}, "output_dir": str(output)}
        ran = {record["stage"] for record in result.get("commands", [])}
        entry = {"task_id": task["task_id"], "passed": result["passed"],
                 "compile_passed": "compile" in ran and result["stage"] not in ("environment", "compile"),
                 "simulation_passed": "simulation" in ran and result["stage"] not in ("environment", "compile", "elaborate", "simulation"),
                 "synthesis_passed": result["passed"], "failed_stage": None if result["passed"] else result["stage"],
                 "error_type": result["error_type"], "timings": result.get("timings", {}),
                 "log_directory": result.get("output_dir", str(output)), "exit_code": completed.returncode}
        entries.append(entry)
        print(f"{task['task_id']}: {result['stage']} {result['error_type']}", file=sys.stderr, flush=True)
        reports = ROOT / "reports"
        reports.mkdir(exist_ok=True)
        summary = {"schema_version": "1.0", "implementation": "reference", "tasks": entries,
                   "all_passed": len(entries) == 10 and all(item["passed"] for item in entries)}
        (reports / "validation_summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        lines = ["# Reference batch validation", "", "Real results from `validate_rtl.py`; unrun stages are false, not waived.", "",
                 "| Task | Compile | Simulation | Synthesis | Failed stage | Error | Seconds (C/E/Sim/Synth) | Logs |",
                 "|---|---|---|---|---|---|---|---|"]
        for item in entries:
            t = item["timings"]
            seconds = "/".join(str(t.get(f"{s}_seconds", 0)) for s in ("compile", "elaborate", "simulation", "synthesis"))
            lines.append(f"| {item['task_id']} | {item['compile_passed']} | {item['simulation_passed']} | {item['synthesis_passed']} | {item['failed_stage'] or '-'} | {item['error_type']} | {seconds} | `{item['log_directory']}` |")
        (reports / "validation_summary.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return 0 if len(entries) == 10 and all(item["passed"] for item in entries) else 1


if __name__ == "__main__":
    raise SystemExit(main())
