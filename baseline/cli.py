"""Cross-platform command line entrypoint for the single-call baseline."""

from __future__ import annotations

import argparse
import json
import sys

from agent.core.eda_adapter import create_eda_adapter
from agent.core.storage import StorageError
from agent.core.task import TaskError
from config.loader import ConfigError, load_config
from serve.factory import create_model_client

from .orchestrator import BaselineRunner


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="python -m baseline.cli")
    commands = parser.add_subparsers(dest="command", required=True)
    run = commands.add_parser("run", help="run one public RTL baseline")
    run.add_argument("--problem", required=True, help="task directory, task.json, or task.txt")
    run.add_argument("--config", required=True, help="experiment JSON configuration")
    run.add_argument("--output", required=True, help="parent directory for a unique run")
    run.add_argument("--run-id", help="preferred run directory name; collisions get a suffix")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        config = load_config(args.config)
        runner = BaselineRunner(
            config,
            create_model_client(config),
            create_eda_adapter(config),
        )
        result = runner.run(args.problem, args.output, args.run_id)
    except (ConfigError, TaskError, StorageError, OSError, ValueError) as exc:
        print(f"baseline error: {exc}", file=sys.stderr)
        return 2
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
            },
            ensure_ascii=False,
        )
    )
    if not result.get("next_task_allowed",True):
        return 3
    if result["passed"]:
        return 0
    return 2 if result["environment_failure"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
