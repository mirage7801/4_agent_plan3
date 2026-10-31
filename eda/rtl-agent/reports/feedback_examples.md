# Feedback Examples for Team Two and Team Three

These examples use fresh phase-2 Vivado 2026.1 runs. They are feedback artifacts, not automatic repairs. Raw logs remain private validator evidence.

## 1. Compile syntax error

- Candidate RTL: `demo_tasks/counter/faults/missing_semicolon.v`
- Command: `python tools/validate_rtl.py --source demo_tasks/counter/faults/missing_semicolon.v --testbench demo_tasks/counter/tb_counter.sv --top counter --part xczu3eg-sbva484-1-e --clock-period 5.0 --output-dir outputs/phase2_vivado_20260922/counter_syntax_retry --vivado-bin D:/AMDDesignTools/2026.1/Vivado/bin`
- Failed stage: `compile`
- error_type: `syntax_error`
- Summary: `syntax_error at candidate RTL .../missing_semicolon.v:4: ... syntax error near 'else' ... code 2:always_ff ... | 3:if (rst) ... | 4:else if (enable) ...`
- result.json: `outputs/phase2_vivado_20260922/counter_syntax_retry_run_20260922_221708_44f963f8/result.json`
- Raw log: `outputs/phase2_vivado_20260922/counter_syntax_retry_run_20260922_221708_44f963f8/compile.log`
- Team two may use: failed stage, error_type, original candidate path, line number, diagnostic, and the bounded candidate snippet.
- Never send to a model: `reference.v`, `tb_counter.sv`, XDC, `faults/`, raw Vivado logs, private temporary paths, or the full task directory.

## 2. Top-module name error

- Candidate RTL: `demo_tasks/counter/reference.v`
- Command: same validator command with `--top counter_missing` and output directory `outputs/phase2_vivado_20260922/counter_top_retry`
- Failed stage: `elaborate`
- error_type: `elaboration_error`
- Summary: `elaboration_error: 位置未知; ERROR: [XSIM 43-3225] Cannot find design unit work.tb_counter_missing...`
- result.json: `outputs/phase2_vivado_20260922/counter_top_retry_run_20260922_221712_84102016/result.json`
- Raw log: `.../elaborate.log`
- Team two may use: stage, error_type, and the fact that the requested top/testbench design unit was not found.
- Never send: private bench source, reference source, raw logs, or temporary workspace paths.

## 3. Simulation/tool failure boundary

- Candidate RTL: `demo_tasks/counter/reference.v`
- Command: standard counter validation with output `outputs/phase2_vivado_20260922/counter_reference_retry`
- Failed stage: `simulation`
- error_type: `unknown_error`
- Summary: `unknown_error: 位置未知; Unknown error occured while verifying the digital signature. Error Code: -2146762486`
- result.json: `outputs/phase2_vivado_20260922/counter_reference_retry_run_20260922_221654_0ce7e505/result.json`
- Raw log: `.../simulation.log`
- Team two may use: the fact that no structured `TB_FAIL` was emitted and the failure is a simulator/tool error, so no RTL repair prompt should be generated from it.
- Never send: raw simulator logs, private paths, or any claim that this proves a functional RTL defect.

## 4. Reset behavior feedback from an existing real run

- Candidate RTL: `demo_tasks/counter/faults/wrong_reset.v`
- Command: `python tools/validate_rtl.py --source demo_tasks/counter/faults/wrong_reset.v --testbench demo_tasks/counter/tb_counter.sv --top counter --part xczu3eg-sbva484-1-e --clock-period 5.0 --output-dir outputs/faults/wrong_reset`
- Failed stage: `simulation`
- error_type: `reset_behavior_error`
- Summary: `Fatal: TEST_FAIL cycle=1 inputs rst=1 enable=0 expected=00 actual=ff reset behavior` (legacy real result; structured TB_FAIL support now produces the equivalent machine-readable kind/case form)
- result.json: `outputs/faults/wrong_reset/result.json`
- Raw log: `outputs/faults/wrong_reset/simulation.log`
- Team two may use: reset case, cycle, reset input, expected value, actual value, and error_type.
- Never send: the private testbench, reference implementation, complete logs, or unrelated fault samples.

The stable interface remains `tools/validate_rtl.py` plus `result.json`; no incompatible CLI was introduced.
