# Phase 2 baseline: feedback quality and integration readiness

Baseline checked on 2026-09-22 from current files and real artifacts (not only historical prose):

- Pure Python: `python -m unittest discover -s tests -v` was 6/6 before changes.
- Latest reference batch: `reports/validation_summary.json` points to ten fresh Vivado 2026.1 runs, all `passed=true`, `all_passed=true` (10/10).
- Counter fault evidence: `missing_semicolon` was `compile/syntax_error`; `wrong_reset` was `simulation/reset_behavior_error`; `wrong_port_width` was inconsistently recorded as `simulation/reset_behavior_error` in the original run and `width_mismatch` in a rerun; `multiple_driver` was passed in one run and rejected as `synthesis/multiple_driver` in another. The inconsistent width/reset classification was the confirmed defect.
- Existing result files use `schema_version=1.0` and the fixed top-level fields from `interfaces/result.schema.json`; no extra top-level field was added.
- Before this phase, `log_parser.py` could select a first diagnostic line and warnings but did not reliably map `source.v/source.sv` back to the candidate, did not extract candidate snippets, and exposed temporary paths in summaries/warnings.
- Counter, shift-register, and sequence-detector testbenches already included `case`, `cycle`, reset/control inputs, expected and actual values, but the parser did not prioritize their structured `TB_FAIL kind=...` data.

Current phase-2 implementation status:

- Structured `TB_FAIL` is authoritative for the five simulation classes; ordinary numerical differences default to `functional_mismatch`.
- `latency_mismatch` requires explicit latency/timing evidence or a structured kind; reset errors require a structured reset kind or explicit reset case/input evidence; legacy wording alone is not sufficient.
- `source.v/source.sv` and `testbench.sv` locations are mapped to the original candidate or explicitly labeled validation environment/testbench. Candidate locations include line context of up to two lines before and after, bounded by the existing 1000-character summary limit.
- Raw logs remain complete; result schema remains 1.0.
- Real log fixtures were copied, without modifying originals, to `tests/fixtures/vivado/` and are labeled by the source run in their filenames.

Vivado 2026.1 phase-2 reruns created fresh directories under `outputs/phase2_vivado_20260922/`. The syntax-error run and top-module run produced useful real diagnostics. Reference, wrong-reset, width, shift-register, and sequence-detector simulations were blocked by the installed xsim's real process error `Unknown error occured while verifying the digital signature. Error Code: -2146762486`; this is preserved as an environment/tool failure and is not attributed to candidate RTL.
