from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.log_parser import classify, parse_tb_fail, warnings_from
from tools.result_schema import ROOT, new_result, short_summary, validate_result, validate_task
from tools.validator_api import _execute, _synthesis_command, validate_rtl
from tools.validate_rtl import main as cli_main


class PurePythonValidationTests(unittest.TestCase):
    def test_result_schema_and_summary(self):
        result = new_result("a.v", "tb.sv", "counter", "xczu3eg-sbva484-1-e", 5)
        result["summary"] = short_summary("x" * 1200)
        self.assertEqual(len(result["summary"]), 1000)
        validate_result(result)
        result["stage"] = "invented"
        with self.assertRaises(ValueError):
            validate_result(result)

    def test_task_schemas(self):
        schema = json.loads((ROOT / "interfaces/task.schema.json").read_text(encoding="utf-8"))
        self.assertEqual(schema["$schema"], "https://json-schema.org/draft/2020-12/schema")
        self.assertEqual(json.loads((ROOT / "interfaces/result.schema.json").read_text(encoding="utf-8"))["properties"]["schema_version"]["const"], "1.0")
        tasks = sorted((ROOT / "demo_tasks").glob("*/task.json"))
        self.assertEqual(len(tasks), 10)
        for path in tasks:
            task = json.loads(path.read_text(encoding="utf-8"))
            validate_task(task)
            self.assertTrue((path.parent / task["testbench"]).is_file())
            self.assertTrue((path.parent / "reference.v").is_file())
            self.assertTrue((path.parent / "task.txt").is_file())
        with self.assertRaises(ValueError):
            validate_task({})

    def test_log_classification(self):
        cases = [
            ("compile", "ERROR: syntax error near else", "syntax_error"),
            ("elaborate", "ERROR: port data width mismatch", "width_mismatch"),
            ("elaborate", "ERROR: [XSIM 43-3225] Cannot find design unit work.tb_counter_missing", "module_not_found"),
            ("simulation", "TEST_FAIL reset expected=0 actual=ff", "reset_behavior_error"),
            ("synthesis", "ERROR: multiple drivers on net", "multiple_driver"),
            ("synthesis", "CRITICAL WARNING: [Synth 8-6859] multi-driven net on pin Q", "multiple_driver"),
            ("synthesis", "INFO: Got license for Vivado_Synthesis", "synthesis_error"),
        ]
        for stage, log, expected in cases:
            self.assertEqual(classify(stage, log)[0], expected)
        self.assertEqual(classify("simulation", "", timed_out=True)[0], "simulation_timeout")
        self.assertEqual(warnings_from("WARNING: width mismatch\nINFO: okay"), ["WARNING: width mismatch"])

    def test_structured_simulation_feedback_priority(self):
        self.assertEqual(classify("simulation", "TB_FAIL kind=functional_mismatch case=count_increment cycle=18 rst=0 enable=1 expected=10 actual=0f")[0], "functional_mismatch")
        self.assertEqual(classify("simulation", "TB_FAIL kind=reset_behavior_error case=runtime_reset cycle=17 rst=1 enable=1 expected=00 actual=0f")[0], "reset_behavior_error")
        self.assertEqual(classify("simulation", "TB_FAIL kind=latency_mismatch case=registered_output cycle=4 expected=1 actual=0 previous=0")[0], "latency_mismatch")
        self.assertEqual(classify("simulation", "TEST_FAIL cycle=4 expected=10 actual=0f")[0], "functional_mismatch")
        self.assertEqual(classify("simulation", "TEST_FAIL cycle=4 inputs rst=0 expected=10 actual=0f reset behavior")[0], "functional_mismatch")
        self.assertEqual(classify("simulation", "TEST_FAIL cycle=1 inputs rst=1 expected=00 actual=ff reset behavior")[0], "reset_behavior_error")
        self.assertEqual(classify("simulation", "TB_FAIL kind=unknown_value case=shift_bit cycle=3 expected=10 actual=0x")[0], "unknown_value")
        self.assertEqual(classify("simulation", "TB_FAIL kind=simulation_timeout case=watchdog cycle=2 expected=0 actual=0")[0], "simulation_timeout")
        self.assertEqual(classify("simulation", "", timed_out=True)[0], "simulation_timeout")
        self.assertEqual(parse_tb_fail("Fatal: TB_FAIL kind=functional_mismatch case=hold_disabled cycle=2 expected=00 actual=01"), {
            "kind": "functional_mismatch", "case": "hold_disabled", "cycle": "2", "expected": "00", "actual": "01"
        })

    def test_real_vivado_location_mapping_and_snippet(self):
        source = ROOT / "demo_tasks" / "counter" / "faults" / "missing_semicolon.v"
        tb = ROOT / "demo_tasks" / "counter" / "tb_counter.sv"
        text = (ROOT / "tests" / "fixtures" / "vivado" / "syntax_error_20260921_missing_semicolon.log").read_text(encoding="utf-8")
        kind, summary = classify("compile", text, source_path=source, testbench_path=tb)
        self.assertEqual(kind, "syntax_error")
        self.assertIn(str(source), summary)
        self.assertIn("code ", summary)
        self.assertNotIn("rtl_agent_", summary)
        self.assertLessEqual(len(summary), 1000)

    def test_unknown_location_is_not_invented_and_tb_is_labeled(self):
        self.assertIn("位置未知", classify("compile", "ERROR: syntax error without a file location")[1])
        tb = ROOT / "demo_tasks" / "counter" / "tb_counter.sv"
        summary = classify("compile", 'ERROR: [VRFC 10-999] bad bench [C:/tmp/testbench.sv:7]', testbench_path=tb)[1]
        self.assertIn("validation environment/testbench", summary)

    def test_width_warning_is_preserved_without_failure_inference(self):
        text = (ROOT / "tests" / "fixtures" / "vivado" / "width_warning_20260921_wrong_port_width.log").read_text(encoding="utf-8")
        self.assertEqual(classify("elaborate", text)[0], "width_mismatch")
        self.assertEqual(warnings_from(text)[0].startswith("WARNING:"), True)

    def test_summary_limit_and_chain_error_priority(self):
        text = "\n".join(["ERROR: [VRFC 10-4982] syntax error [C:/tmp/source.v:4]", "ERROR: module ignored due to previous errors [C:/tmp/source.v:1]"] + ["ERROR: cascading error"] * 200)
        _, summary = classify("compile", text, source_path=ROOT / "demo_tasks/counter/faults/missing_semicolon.v")
        self.assertLessEqual(len(summary), 1000)
        self.assertIn("syntax_error", summary)

    def test_simulator_tool_failure_uses_environment_exit(self):
        simulated_tool_failure = new_result("a.v", "tb.sv", "counter", "xczu3eg-sbva484-1-e", 5)
        simulated_tool_failure.update(stage="simulation", error_type="unknown_error", summary="simulation tool failure; no candidate RTL evidence; unknown_error: 位置未知")
        with patch("tools.validate_rtl.validate_rtl", return_value=simulated_tool_failure):
            self.assertEqual(cli_main(["--source", "a.v", "--testbench", "tb.sv", "--top", "counter", "--output-dir", "out"]), 2)

    def test_process_timeout_and_space_arguments(self):
        with tempfile.TemporaryDirectory(prefix="rtl test ") as temp:
            folder = Path(temp) / "含 空格"
            folder.mkdir()
            code, text, expired, seconds = _execute([sys.executable, "-c", "import time;time.sleep(1)"], folder, folder / "timeout.log", .05)
            self.assertTrue(expired)
            self.assertIsNone(code)
            self.assertTrue((folder / "timeout.log").is_file())
            arg = str(folder / "source with spaces.v")
            code, text, expired, seconds = _execute([sys.executable, "-c", "import sys;print(sys.argv[1])", arg], folder, folder / "path.log", 5)
            self.assertEqual(code, 0)
            self.assertIn(arg, text)
            self.assertEqual(json.loads((folder / "path.log").read_text(encoding="utf-8").split("\n", 1)[0])["argv"][-1], arg)

    def test_synthesis_arguments_use_staged_relative_paths(self):
        bin_dir = Path("D:/AMDDesignTools/2026.1/Vivado/bin")
        unclocked = _synthesis_command(bin_dir, "source.v", "priority_encoder", "xczu3eg-sbva484-1-e", False)
        clocked = _synthesis_command(bin_dir, "source.sv", "counter", "xczu3eg-sbva484-1-e", True)
        self.assertEqual(unclocked[-5:], ["source.v", "priority_encoder", "xczu3eg-sbva484-1-e", "NO_CONSTRAINTS", "synth_netlist.v"])
        self.assertEqual(clocked[-5:], ["source.sv", "counter", "xczu3eg-sbva484-1-e", "constraints.xdc", "synth_netlist.v"])
        self.assertEqual(unclocked[unclocked.index("-source") + 1], "synth.tcl")
        self.assertNotIn("", unclocked)

    def test_missing_tool_unique_run_and_cli_api_semantics(self):
        with tempfile.TemporaryDirectory(prefix="rtl test ") as temp:
            folder = Path(temp) / "含 空格"
            folder.mkdir()
            src, tb = folder / "source with spaces.v", folder / "tb_counter.sv"
            src.write_text("module counter; endmodule", encoding="utf-8")
            tb.write_text("module tb_counter; endmodule", encoding="utf-8")
            output = folder / "validation"
            api = validate_rtl(src, tb, "counter", output_dir=output, vivado_bin=folder / "missing")
            self.assertEqual((api["stage"], api["error_type"]), ("environment", "tool_not_found"))
            self.assertEqual(json.loads((output / "result.json").read_text(encoding="utf-8")), api)
            cli = subprocess.run([sys.executable, str(ROOT / "tools/validate_rtl.py"), "--source", str(src),
                                  "--testbench", str(tb), "--top", "counter", "--output-dir", str(output),
                                  "--vivado-bin", str(folder / "missing")], capture_output=True, text=True, encoding="utf-8")
            self.assertEqual(cli.returncode, 2)
            cli_result = json.loads(cli.stdout)
            self.assertEqual(set(api), set(cli_result))
            self.assertEqual((api["stage"], api["error_type"]), (cli_result["stage"], cli_result["error_type"]))
            self.assertEqual(api["source"], cli_result["source"])
            self.assertEqual(api["testbench"], cli_result["testbench"])
            self.assertNotEqual(api["output_dir"], cli_result["output_dir"])
            self.assertTrue((Path(cli_result["output_dir"]) / "result.json").is_file())
            self.assertEqual(json.loads((Path(cli_result["output_dir"]) / "result.json").read_text(encoding="utf-8")), cli_result)
            self.assertEqual(json.loads((output / "result.json").read_text(encoding="utf-8")), api)


if __name__ == "__main__":
    unittest.main()
