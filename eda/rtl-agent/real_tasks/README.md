# VerilogEval-to-RTL-Agent conversion workspace

This directory is a separate conversion workspace. It does not modify the
original `verilog-eval-main` checkout or the existing AMD RTL-Agent demo tasks.

## Public specification repair (2026-10-25)

The converted task set has been audited against both upstream public task
formats. Public specifications for questions 031, 049, 060, 061, 062, 068,
073, 080, 094, 099, 116, 126, 132, 135, 136, 146, 148, and 153 have been
corrected in place. The reference RTL and testbenches were not changed.

See [repair report](reports/repair_report_20261025.md) for exact corrections
and current Vivado evidence, and [difficulty report](reports/difficulty_report_20261025.md)
for all 156 question numbers and their five difficulty levels.

The conversion instructions below describe the original structural import.
Re-running conversion with `--overwrite-converted` would restore upstream
prompt defects and discard these public-spec corrections.

## What is converted

The converter turns one VerilogEval `spec-to-rtl` triple into one task folder:

```text
<problem>_prompt.txt -> task.txt
<problem>_ref.sv     -> reference.v (RefModule renamed to TopModule for smoke testing)
<problem>_test.sv    -> tb.sv (with the original RefModule retained privately)
```

`task.txt` and public fields of `task.json` are model input. `tb.sv`,
`reference.v`, and `provenance.json` are validation assets and must never be
sent to the model.

## Convert all 156 spec-to-RTL problems

The original VerilogEval checkout is read-only input.  This workspace receives
the converted task folders; it never edits the original dataset.

```powershell
python tools\convert_verilog_eval.py `
  --source D:\AMD\verilog-eval-main\verilog-eval-main\dataset_spec-to-rtl `
  --all `
  --output-root problems `
  --overwrite-converted
```

The command writes one folder per problem and `problems\conversion_manifest.json`.
Conversion is structural only: it does **not** claim that every upstream
testbench is Vivado-compatible or that every reference RTL has passed Vivado.
The converter adds private `TEST_PASS` / `TB_FAIL` markers based on the
upstream testbench's original mismatch counter; it does not alter test vectors
or expected behavior.

## Convert one trial

From this directory in PowerShell:

```powershell
python tools\convert_verilog_eval.py `
  --source D:\AMD\verilog-eval-main\verilog-eval-main\dataset_spec-to-rtl `
  --output problems\prob001_zero `
  --problem Prob001_zero
```

Then validate the converted reference with the existing AMD RTL-Agent
validator. Do this before adding the task to any Agent experiment:

```powershell
python D:\AMD\current_work\eda\rtl-agent\tools\validate_rtl.py `
  --source problems\prob001_zero\reference.v `
  --testbench problems\prob001_zero\tb.sv `
  --top TopModule `
  --part xczu3eg-sbva484-1-e `
  --clock-period 5.0 `
  --output-dir outputs\prob001_zero_reference
```

The expected result is `"passed": true`. If it fails, review Vivado
compatibility and preserve the original VerilogEval functional intent; do not
weaken the testbench merely to obtain a pass.
