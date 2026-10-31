"""Convert VerilogEval spec-to-RTL triples into RTL-Agent task folders.

The converter copies the public prompt into ``task.txt`` and keeps the
reference RTL private.  The original VerilogEval testbench compares a
candidate ``TopModule`` against a private ``RefModule``.  RTL-Agent validates
one candidate source plus one testbench, so the untouched ``RefModule`` is
appended only to the private converted testbench.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Iterable


DEFAULT_PART = "xczu3eg-sbva484-1-e"
DEFAULT_CLOCK_NS = 5.0


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True, help="VerilogEval dataset_spec-to-rtl directory")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--problem", help="convert one problem stem, for example Prob001_zero")
    mode.add_argument("--all", action="store_true", help="convert every spec-to-RTL problem")
    parser.add_argument("--output", type=Path, help="directory that will receive one converted task")
    parser.add_argument("--output-root", type=Path, help="parent directory for --all converted tasks")
    existing = parser.add_mutually_exclusive_group()
    existing.add_argument(
        "--skip-existing",
        action="store_true",
        help="with --all, keep an existing task directory instead of failing",
    )
    existing.add_argument(
        "--overwrite-converted",
        action="store_true",
        help="with --all, update only folders that this converter previously created",
    )
    return parser.parse_args()


def converted_name(problem: str) -> str:
    """Return a stable, lowercase RTL-Agent directory name."""

    return problem.lower()


def _is_matching_converted_task(output: Path, problem: str) -> bool:
    """Only permit overwriting a folder with matching converter provenance."""

    provenance_path = output / "provenance.json"
    if not provenance_path.is_file():
        return False
    try:
        provenance = json.loads(provenance_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return False
    return (
        provenance.get("source_dataset") == "VerilogEval dataset_spec-to-rtl"
        and provenance.get("source_problem") == problem
    )


def instrument_testbench(original_test: str) -> str:
    """Add the RTL-Agent pass/fail markers without altering test vectors.

    VerilogEval's upstream benches record mismatch counts in ``stats1.errors``
    but usually end with ``$finish`` regardless of that value.  The Vivado
    validator requires ``TEST_PASS`` for success and needs a nonzero-failure
    marker for a mismatch.  All v2 spec-to-RTL benches have this final block.
    """

    marker = '''final begin
    // RTL-Agent compatibility marker; original VerilogEval checks remain below.
    if (stats1.errors != 0) begin
        $display("TB_FAIL kind=functional_mismatch mismatches=%0d", stats1.errors);
        $fatal(1, "TB_FAIL kind=functional_mismatch mismatches=%0d", stats1.errors);
    end else begin
        $display("TEST_PASS verilog_eval");
    end'''
    converted, replacements = re.subn(r"\bfinal\s+begin", marker, original_test, count=1)
    if replacements != 1:
        raise ValueError("expected exactly one `final begin` block for RTL-Agent instrumentation")
    return converted


def normalize_vivado_declaration_order(original_test: str) -> str:
    """Hoist VerilogEval's checker nets before their first Vivado use.

    The upstream benches declare ``tb_match`` / ``tb_mismatch`` after a
    ``$dumpvars`` use.  Icarus accepts that ordering, but Vivado's SystemVerilog
    compiler rejects it.  Moving those two checker declarations changes neither
    the driven values nor the comparison logic.
    """

    declaration = re.compile(
        r"(?m)^(?P<indent>[ \t]*)wire\s+tb_match;[^\r\n]*\r?\n"
        r"[ \t]*wire\s+tb_mismatch\s*=\s*~tb_match;\s*\r?\n"
    )
    found = declaration.search(original_test)
    if found is None:
        raise ValueError("expected tb_match/tb_mismatch checker declarations")
    without_declaration = original_test[:found.start()] + original_test[found.end():]
    dump_initial = re.compile(r"(?m)^[ \t]*initial\s+begin\s*\r?\n[ \t]*\$dumpfile").search(
        without_declaration
    )
    if dump_initial is None:
        raise ValueError("expected the VerilogEval $dumpfile initial block")
    declaration_text = found.group(0).rstrip() + "\n\n"
    return (
        without_declaration[:dump_initial.start()]
        + declaration_text
        + without_declaration[dump_initial.start():]
    )


def normalize_rtl_agent_testbench_top(original_test: str) -> str:
    """Use the fixed testbench name expected by the existing validator."""

    converted, replacements = re.subn(
        r"\bmodule\s+tb\s*\(", "module tb_TopModule(", original_test, count=1
    )
    if replacements != 1:
        raise ValueError("expected exactly one `module tb(` declaration")
    return converted


def convert(source: Path, output: Path, problem: str, overwrite_converted: bool = False) -> dict[str, object]:
    prompt_path = source / f"{problem}_prompt.txt"
    reference_path = source / f"{problem}_ref.sv"
    test_path = source / f"{problem}_test.sv"
    missing = [str(path) for path in (prompt_path, reference_path, test_path) if not path.is_file()]
    if missing:
        raise FileNotFoundError("missing VerilogEval input file(s): " + ", ".join(missing))
    if output.exists() and not overwrite_converted:
        raise FileExistsError(f"output already exists; refusing to overwrite: {output}")
    if output.exists() and overwrite_converted and not _is_matching_converted_task(output, problem):
        raise FileExistsError(f"output is not a matching converted task; refusing to overwrite: {output}")

    prompt = prompt_path.read_text(encoding="utf-8")
    original_reference = reference_path.read_text(encoding="utf-8")
    original_test = test_path.read_text(encoding="utf-8")
    candidate_reference, replacements = re.subn(r"\bmodule\s+RefModule\b", "module TopModule", original_reference, count=1)
    if replacements != 1:
        raise ValueError("expected exactly one `module RefModule` declaration in the reference RTL")
    if not re.search(r"\bTopModule\b", original_test):
        raise ValueError("testbench does not instantiate TopModule; manual review is required")

    output.mkdir(parents=True, exist_ok=True)
    (output / "task.txt").write_text(prompt, encoding="utf-8")
    (output / "reference.v").write_text(candidate_reference, encoding="utf-8")
    # The original testbench instantiates RefModule as the golden design.  The
    # agent's validator compiles exactly a candidate source plus one testbench,
    # so append the untouched golden reference to the private testbench.
    (output / "tb.sv").write_text(
        instrument_testbench(
            normalize_rtl_agent_testbench_top(
                normalize_vivado_declaration_order(original_test)
            )
        ).rstrip()
        + "\n\n// Private golden reference copied from VerilogEval.\n"
        + original_reference.lstrip(),
        encoding="utf-8",
    )
    task = {
        "schema_version": "1.0",
        "task_id": problem.lower(),
        "description": prompt.strip(),
        "language": "systemverilog",
        "top_module": "TopModule",
        "expected_source_file": "solution.sv",
        "testbench": "tb.sv",
        "constraints": None,
        "part": DEFAULT_PART,
        "clock_period_ns": DEFAULT_CLOCK_NS,
        "timeouts": {
            "compile_seconds": 60,
            "elaborate_seconds": 60,
            "simulation_seconds": 120,
            "synthesis_seconds": 300,
        },
    }
    (output / "task.json").write_text(json.dumps(task, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    provenance = {
        "source_dataset": "VerilogEval dataset_spec-to-rtl",
        "source_problem": problem,
        "source_files": {
            prompt_path.name: sha256(prompt_path),
            reference_path.name: sha256(reference_path),
            test_path.name: sha256(test_path),
        },
        "conversion_notes": [
            "Candidate top module renamed from RefModule to TopModule for the reference smoke test.",
            "Original RefModule reference is appended to the private testbench because it is required by the upstream checker.",
            "The upstream mismatch counter is instrumented to emit TEST_PASS or TB_FAIL for RTL-Agent's Vivado validator.",
            "Vivado requires tb_match/tb_mismatch declarations before $dumpvars; only their declaration position is changed.",
            "The upstream testbench module tb is renamed to tb_TopModule because the existing validator elaborates that fixed name.",
            "Run the Vivado reference smoke test before using this task for Agent experiments.",
        ],
    }
    (output / "provenance.json").write_text(json.dumps(provenance, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return {
        "source_problem": problem,
        "task_id": task["task_id"],
        "directory": output.name,
        "source_files": provenance["source_files"],
    }


def source_problems(source: Path) -> Iterable[str]:
    for prompt_path in sorted(source.glob("*_prompt.txt")):
        yield prompt_path.name.removesuffix("_prompt.txt")


def convert_all(source: Path, output_root: Path, skip_existing: bool, overwrite_converted: bool) -> dict[str, object]:
    output_root.mkdir(parents=True, exist_ok=True)
    converted: list[dict[str, object]] = []
    skipped: list[str] = []
    for problem in source_problems(source):
        output = output_root / converted_name(problem)
        if output.exists() and not overwrite_converted:
            if not skip_existing:
                raise FileExistsError(
                    f"output already exists: {output}; rerun with --skip-existing to retain it"
                )
            skipped.append(problem)
            continue
        converted.append(convert(source, output, problem, overwrite_converted=overwrite_converted))

    manifest = {
        "schema_version": "1.0",
        "source_dataset": "VerilogEval dataset_spec-to-rtl",
        "converted_count": len(converted),
        "skipped_existing_count": len(skipped),
        "skipped_existing": skipped,
        "vivado_validation": "not_run_by_converter",
        "tasks": converted,
    }
    (output_root / "conversion_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return manifest


def main() -> int:
    args = parse_args()
    source = args.source.resolve()
    if args.all:
        if args.output is not None or args.output_root is None:
            raise SystemExit("--all requires --output-root and must not use --output")
        manifest = convert_all(
            source, args.output_root.resolve(), args.skip_existing, args.overwrite_converted
        )
        print(json.dumps({
            "converted_count": manifest["converted_count"],
            "skipped_existing_count": manifest["skipped_existing_count"],
            "manifest": str((args.output_root.resolve() / "conversion_manifest.json")),
        }, ensure_ascii=False))
    else:
        if args.output is None or args.output_root is not None:
            raise SystemExit("--problem requires --output and must not use --output-root")
        convert(source, args.output.resolve(), args.problem, args.overwrite_converted)
        print(args.output.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
