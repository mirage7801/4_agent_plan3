# RTL automatic verification and Demo set

Vivado 2026.1-based validator for generated Verilog/SystemVerilog: `xvlog` analysis, `xelab` elaboration, `xsim` self-checking simulation, `synth_design` for `xczu3eg-sbva484-1-e`, raw logs, error classification and JSON result. The clock period is 5.0 ns where a clock exists. No GUI, model inference, code rewriting or retry policy.

Layout: `tools/` CLI/API/batch/parser/schema and Vivado Tcl; `interfaces/` immutable 1.0 contracts; `demo_tasks/<name>/` ten public specifications and private bench/reference; `tests/` Python tests; `outputs/` isolated runs; `logs/` manual counter records; `reports/` environment, batch and handoff documents. Agent-specific guardrails are in `AGENTS.md`; operational details and evidence remain here and in `reports/final_handoff.md`.

From this directory:

```powershell
python tools/validate_rtl.py --source demo_tasks/counter/reference.v --testbench demo_tasks/counter/tb_counter.sv --top counter --part xczu3eg-sbva484-1-e --clock-period 5.0 --output-dir outputs/manual_example
python tools/run_all_tasks.py --tasks-dir demo_tasks --implementation reference
python -m unittest discover -s tests -v
```

Vivado must be exactly 2026.1 with the target device and a working synthesis license. The validator discovers the absolute executable directory (or accepts `--vivado-bin` / `RTL_AGENT_VIVADO_BIN`) and checks version; `vivado -version` on this Windows installation prints 2026.1 but returns 1, so the version text is authoritative for that informational switch. Consult `reports/environment_report.md` for this host's actual check, and `reports/validation_summary.md` for actual reference outcomes. No success is inferred merely from installation or from Icarus Verilog.

On this Windows host, Vivado has intermittently emitted `ERROR: [Common 17-354] Could not open 'C' for writing` after otherwise successful synthesis when drive-qualified paths were passed as Tcl arguments. The synthesis launcher therefore runs from a private ASCII work directory and passes staged source, Tcl, XDC and netlist names as relative arguments. Do not change these back to absolute `C:/...` Tcl arguments without a real Vivado regression run. Historical failing logs remain in their original `outputs/batch/` directories; the current batch report points to fresh runs.

The result contains `schema_version`, `passed`, `stage`, `error_type`, compact `summary`, candidate/bench/top/part/clock, `vivado_version`, per-stage seconds, actual `commands`, `log_files`, `artifacts`, `warnings`, and `output_dir`. Stages: environment, compile, elaborate, simulation, synthesis, complete. Error types include missing tool/part/license, timeout, syntax/module/port/width/elaboration, functional/reset/latency/unknown-value/simulation timeout, multiple driver/latch/loop/unsynthesizable/synthesis, unknown, none. Full enum is in `interfaces/result.schema.json`. Diagnostic regexes are best-effort; raw logs remain authoritative, and a Windows tool crash can be classified as `synthesis_error` without a diagnostic line.

To add a task, create `demo_tasks/<name>/task.txt`, a schema-conforming `task.json`, a private synthesizable `reference.v`, `tb_<name>.sv` with deterministic assertions/timeout/`TEST_PASS`, a clock XDC if needed, and README. Ensure testbench module is `tb_<top_module>`, then run single and batch validation. Public prompt material is only task text and public JSON description/interface. Never provide the model `reference.v`, `tb_*.sv`, `constraints.xdc`, `faults/`, raw logs, or a result's private paths. Do not pass the whole task directory as model context.

Team three stores each generated candidate under `outputs/<task_id>/<run_id>/attempt_01/solution.sv`, invokes the CLI with its matching private bench and an independent `validation/`, checks exit code and `result.json`, preserves history, and decides retry/final selection. Python callers may use `from tools.validator_api import validate_rtl`. Team two should use only `stage`, `error_type`, `summary`, relevant warnings and the candidate code snippet to construct a repair prompt; do not expose the private reference or testbench. See `interfaces/validation_contract.md` for the frozen contract.

Known limits: Windows Vivado process behavior and tool crashes require raw-log inspection; the validator handles one source file and one bench, infers a bench top by naming convention, and uses heuristic error classification. Even when a Vivado run succeeds, it proves these specific stimuli and a synthesis netlist, not universal equivalence, timing closure or final contest compatibility.
