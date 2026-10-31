"""Validate the files and contracts needed before a four-agent run.

This is intentionally offline: it checks configuration and local assets but
does not call the model service or Vivado.  A successful preflight is the
handoff contract for the closed-loop runner.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

# When invoked as ``python scripts/preflight.py`` Python places ``scripts``
# (not the project root) on sys.path.
PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from config.loader import ConfigError, load_config, redacted_snapshot
from agent.core.task import TaskError, load_task
from agent.orchestration.candidate_search import PIPELINE_VERSION
from agent.core.search_policy import POLICY_VERSION


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="python scripts/preflight.py")
    parser.add_argument("--problem", required=True)
    parser.add_argument("--config", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--json", action="store_true", dest="as_json")
    return parser


def run(problem: str, config_path: str, output: str) -> dict:
    config = load_config(config_path)
    task = load_task(problem)
    validator = Path(config["eda"]["validator_root"]) / config["eda"]["validator_entry"]
    python_executable = Path(config["eda"]["python_executable"])
    output_root = Path(output).expanduser().resolve()
    mock_eda = config["eda"]["adapter"] == "mock"
    checks = {
        "config": True,
        "task": True,
        # Mock runs intentionally use public fixtures without private bench/XDC.
        "testbench": mock_eda or task.testbench_path.is_file(),
        "constraints": mock_eda or task.constraints_path is None or task.constraints_path.is_file(),
        "validator_root": Path(config["eda"]["validator_root"]).is_dir(),
        "validator_entry": validator.is_file(),
        "python_executable": python_executable.is_file(),
        "output_parent": output_root.parent.is_dir(),
    }
    if not all(checks.values()):
        failed = [name for name, ok in checks.items() if not ok]
        raise ConfigError("preflight failed: " + ", ".join(failed))
    return {
        "schema_version": "1.0",
        "status": "ready",
        "execution": {"entrypoint": "agent.cli -> runtime.run.run_task -> CandidateSearchRunner",
                      "pipeline_version": PIPELINE_VERSION, "policy_version": POLICY_VERSION,
                      "speculation": config["speculation"], "model_slots": 1,
                      "validation_slots": 1, "waiting_validation_capacity": 1,
                      "drain_policy": "natural_completion"},
        "problem": {"task_id": task.task_id, "task_version": task.version, "top_module": task.top_module},
        "config": redacted_snapshot(config),
        "paths": {
            "config": str(Path(config_path).resolve()),
            "validator": str(validator.resolve()),
            "output_root": str(output_root),
        },
        "checks": checks,
        "network_probe": "not performed",
    }


def main(argv: list[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    try:
        result = run(args.problem, args.config, args.output)
    except (ConfigError, TaskError, OSError, ValueError) as exc:
        payload = {"schema_version": "1.0", "status": "blocked", "error": str(exc)}
        print(json.dumps(payload, ensure_ascii=False))
        return 2
    print(json.dumps(result if args.as_json else {"status": result["status"], "task_id": result["problem"]["task_id"]}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
