"""Cross-platform command line entrypoint for the repair Agent."""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path
from .core.storage import atomic_write_json

from config.loader import ConfigError, load_config
from serve.factory import create_model_client

from .core.eda_adapter import create_eda_adapter
from .runtime.run import run_task
from .core.storage import StorageError
from .core.task import TaskError
from .resume import resume_run


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="python -m agent.cli")
    commands = parser.add_subparsers(dest="command", required=True)
    run = commands.add_parser("run", help="run one public RTL task")
    run.add_argument("--problem", required=True, help="task directory, task.json, or task.txt")
    run.add_argument("--config", required=True, help="experiment JSON configuration")
    run.add_argument("--output", required=True, help="parent directory for a unique run")
    run.add_argument("--run-id", help="preferred run directory name; collisions get a suffix")
    resume = commands.add_parser("resume", help="recover one interrupted run from persisted evidence")
    resume.add_argument("--run-dir", required=True, help="existing run directory")
    return parser


def _main(argv, timing) -> int:
    args = build_parser().parse_args(argv)
    try:
        if args.command == "resume":
            result = resume_run(args.run_dir)
            print(json.dumps(result, ensure_ascii=False, default=str))
            return 0 if result.get("final", {}).get("passed") else 1
        config = load_config(args.config)
        result = run_task(config, create_model_client(config), create_eda_adapter(config), args.problem, args.output, args.run_id)
    except (ConfigError, TaskError, StorageError, OSError, ValueError) as exc:
        print(f"agent error: {exc}", file=sys.stderr)
        return 2
    timing["run_dir"] = result["run_dir"]
    print(
        json.dumps(
            {
                "run_dir": result["run_dir"],
                "passed": result["passed"],
                "stop_reason": result["stop_reason"],
                "attempt_count": result["attempt_count"],
                "mock": result["mock"],
                "backend_state":result.get("backend_state","not_observed"),
                "backend_drain_seconds":result.get("backend_drain_seconds",0.0),
                "next_task_allowed":result.get("next_task_allowed",True),
                "pipeline_version": result["pipeline_version"],
                "policy_version": result["policy_version"],
                "solution_ready_seconds": result["solution_ready_seconds"],
                "runner_wall_clock_seconds": result["wall_clock_seconds"],
                "lifecycle_timings": result.get("lifecycle_timings"),
                "drain_status": result["drain_status"],
            },
            ensure_ascii=False,
        )
    )
    if not result.get("next_task_allowed",True):
        return 3
    if result["passed"]:
        return 0
    return 2 if result["environment_failure"] else 1


def main(argv: list[str] | None = None) -> int:
    started=time.monotonic();timing={}
    try:
        return _main(argv,timing)
    finally:
        if timing.get("run_dir"):
            path=Path(timing["run_dir"])/'lifecycle_timing.json'
            value=json.loads(path.read_text(encoding='utf-8')) if path.exists() else {}
            value.update(cli_main_seconds=round(time.monotonic()-started,6),
                         cli_measurement_boundary='main entry through stdout and exit decision; excludes this timing write and interpreter startup/shutdown')
            atomic_write_json(path,value)


if __name__ == "__main__":
    raise SystemExit(main())
