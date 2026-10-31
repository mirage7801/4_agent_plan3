# Boundary and evidence hardening — 2026-10-30

## Batch 1: completed implementation

Shared RTL lexical helpers recognize preprocessing-sensitive sources. Strict final answer framing remains unchanged; raw text module counts cannot reject unexpanded conditional branches or macro-defined names. Compilation decides the actual top/module structure.

Interface checks expose match/mismatch/unknown. Bounded decimal constant addition/subtraction/multiplication and unary signs support equivalent literal ranges; unsupported parameters/types/partial ANSI parsing remain unknown and defer to EDA. No eval or HDL preprocessor is implemented.

Standalone frontend failure blocks only candidate-located syntax/elaboration errors. Unsupported features and unclassified exits require authoritative validation; parser absence/failure is never reported as a pass. Syntax tools use the shared owned-process timeout/cleanup mechanism. Unconfirmed cleanup persists the existing local barrier.

All worker crash/invalid-response/contract-error paths recover remote state under the same exclusive BackendLease used by timeout. The durable begin-before-POST invariant, worker termination and lease acquisition permit proving no pending request. Mere absence of an in-memory record does not. Missing backend observations on worker failures are unknown in final summaries. No GPU cancellation or late-answer acceptance is introduced.

## Validation

Each batch is installed and tested on D:/AMD/4_agent_plan3 before starting the next batch. Local HTTP substitutes and mock validators establish protocol and scheduling behavior, not GPU/Vivado performance. Per-batch passing results and source identities are archived alongside this document. Historical runs/reports are unchanged.

## Batch 2: evidence and public diagnostics

Optional execution_trace is accepted only from the validator safe feedback projection, never arbitrary raw results or private log/waveform files. Values are bounded signal/value records. Invalid traces are removed before model projection. Replay readiness requires declared known initialization/reset, ordered clock events, complete input sets and a known sampling point. StageContext recomputes readiness against public input ports. This describes discrete trace sufficiency, not a successful replay or certified diagnosis.

Literal numeric Markdown truth tables for explicitly combinational public tasks can generate up to eight diagnostic cases. Unsupported types, signed ports, missing input columns, contradictory rows and unspecified behavior are not inferred. The existing EDA adapter runs an isolated public bench via Icarus/vvp or xvlog/xelab/xsim when installed; unavailable tools, incomplete output and probe compilation failure are explicitly not_executed. Auxiliary probes run after authoritative non-timeout functional simulation failure, consume bounded remaining EDA time and cannot change the authoritative pass/fail result. No private testbench is read. Process cleanup uncertainty uses the existing persistent local barrier.

Public diagnostic observations travel in candidate/validation-bound evidence. Failure evidence preserves their identity. observed_behavior_comparison.json compares only actually executed public cases; matching observations never establish global equivalence. relationship_summary remains unverified intent; separate behavior_summary records actual public observations for subsequent reconstruction. The report manifest includes comparisons and diagnostic artifacts. The runtime still has one Controller and no new production module.

Batch 1 passed before Batch 2 implementation began; Batch 2 passed before Batch 3 implementation began. Final per-batch results appear below.

## Batch 3: explicit call/time policy

Default analysis.mode is after_failure: first produce A; localized errors may be repaired directly, while reassessment is invoked when reconstruction needs it. before_generation and disabled remain explicit alternatives. Existing legacy test scenarios pin their intended old policy; separate actual CLI/HTTP tests verify the new defaults in both execution modes.

resource_time_admission_v3 keeps one Controller and original resource reserves. action_cost is the common minimum-call accounting source. Decisions include call-budget tradeoffs and the alternatives that become unaffordable; this describes budget opportunity, not a proof that an alternative is semantically applicable. Protocol retries consume actual remaining calls and cannot spend reserved repair calls. Empty Reviewer results remain no_supported_findings, never a successful diagnosis.

speculation.timing_mode supports observed (default), fixed_window and feedback_first. observed uses up to 16 positive finite model/validation durations for the same endpoint/model/revision/EDA configuration and Controller source hash. At least two samples of each kind are required; otherwise wait for A feedback. Bounds use 1.25 times maximum observed durations and subtract elapsed validation time to check potential overlap. Resource allowances 300/540/120 still apply independently. These are heuristic estimates, not guaranteed completion times or difficulty predictions. fixed_window explicitly opts into configured duration windows; feedback_first never speculates. Timing history contains only numeric latencies, no task identity/source/feedback/pass rates and no shared generation budget. Order/workload changes may affect estimates and scheduling, never weaken admission barriers. Timing-history read/write failure falls back safely and is recorded.

The remote-siliconmind.local.json Agent configuration enables token_count_preflight. The client accepts exact counts only when model/revision identities match; unsupported or invalid counting records unknown and never truncates mandatory source/code/evidence. Baseline generation remains unchanged. Global output 8912, request timeout 300s and natural remote completion are unchanged.

The two execution modes are verified with real CLI, local HTTP request capture, per-request tokenizer calls and mock EDA. Expected default chain for three aggregate failures followed by success: A, B, Reviewer, Repairer, reassessment, reconstruction. This proves dispatch/context behavior, not GPU/Vivado correctness or speedup. Batch 2 target regression: 252 tests passed in 261.808s.

## Paths and scope

Production still uses 29 Agent Python modules, one Controller and shared model/rtl_lex.py. No parallel scheduler, extra Agent, private test asset parser or HDL preprocessor is introduced. Existing static/interface/process helpers are reused. New artifacts are public_diagnostics.json, observed_behavior_comparison.json, timing_basis.json and timing_history_update.json, included in existing report collection. Historical run/report files remain untouched.

Structured signal values in safe traces and public diagnostics are hexadecimal strings without prefixes; x/z retain four-state observations. When reconstruction is being verified, an unlocalized repair of an older candidate waits for that result instead of consuming the last call speculatively. Known located-error repairs retain their existing priority.

The Controller ignores arbitrary public_diagnostics fields from external raw results. Only its own executed probe can populate that model evidence. Compile/environment failures, timeouts and passing candidates do not incur auxiliary probes. The cleanup regression observes absence of child activity after confirmed termination, rather than assuming Windows taskkill starts within a fixed subsecond interval.

## Final sequential verification

| Batch | Target tests | Result | Seconds |
|---|---:|---|---:|
| 1 | 245 | OK | 265.026 |
| 2 | 252 | OK | 261.808 |
| 3 | 259 | OK | 263.549 |

[Verification and source hashes](boundary-evidence-verification-20261030.json), [in-process HTTP capture](boundary-chain-in_process-20261030.json), and [worker HTTP capture](boundary-chain-workers-20261030.json). Both modes actually invoke the target CLI and shared Controller; captured six-request scenario: Synthesizer A → Synthesizer B → Reviewer → Repairer → reassessment → reconstructed Synthesizer. Six tokenizer preflights, 8912 output tokens per request and 300s timeout are verified. Scenario-specific chain is not a promise that every task uses all roles.

No real cloud GPU/Vivado execution, speedup measurement or ablation was performed. Public diagnostics presently execute only supported literal unsigned combinational tables (up to eight rows); temporal trace readiness is not an executed replay engine. Baseline source and generation prompts remain unchanged.
