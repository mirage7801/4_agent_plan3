"""Stable subprocess CLI; stdout contains only one JSON object."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from tools.validator_api import validate_rtl


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate RTL with Vivado 2026.1")
    parser.add_argument("--source", required=True)
    parser.add_argument("--testbench", required=True)
    parser.add_argument("--top", required=True)
    parser.add_argument("--part", default="xczu3eg-sbva484-1-e")
    parser.add_argument("--clock-period", type=float, default=5.0)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--constraints")
    parser.add_argument("--vivado-bin")
    parser.add_argument("--synth-on-sim-failure", action="store_true")
    parser.add_argument("--overwrite", action="store_true")
    for stage in ("compile", "elaborate", "simulation", "synthesis"):
        parser.add_argument(f"--{stage}-timeout", type=float)
    args = parser.parse_args(argv)
    timeouts = {f"{stage}_seconds": getattr(args, f"{stage}_timeout") for stage in ("compile", "elaborate", "simulation", "synthesis") if getattr(args, f"{stage}_timeout") is not None}
    result = validate_rtl(args.source, args.testbench, args.top, args.part, args.clock_period,
                          args.output_dir, timeouts=timeouts, synth_on_sim_failure=args.synth_on_sim_failure,
                          overwrite=args.overwrite, vivado_bin=args.vivado_bin, constraints=args.constraints)
    # ASCII-escaped JSON survives Windows consoles/pipes configured for GBK or UTF-8.
    print(json.dumps(result, ensure_ascii=True))
    environment_failure = (result["stage"] == "environment" or result["error_type"] in ("tool_not_found", "unsupported_part", "license_error") or (result["stage"] == "simulation" and result["error_type"] == "unknown_error" and "no candidate RTL evidence" in result["summary"]))
    return 0 if result["passed"] else 2 if environment_failure else 1


if __name__ == "__main__":
    raise SystemExit(main())
