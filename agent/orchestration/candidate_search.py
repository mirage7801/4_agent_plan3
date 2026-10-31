"""One bounded pipeline: one model slot, one EDA slot, one waiting revision.

The controller owns all queues. Executors receive immutable revision snapshots.
Feedback never changes an in-flight request. There is no legacy serial runner.
"""
from __future__ import annotations

import hashlib
import json
import copy
import time
from collections import deque
from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
from dataclasses import dataclass
from pathlib import Path
from threading import Event
from typing import Any

from config.loader import redacted_snapshot
from serve.backend_lifecycle import backend_summary
from model.contracts import ModelClientError, ModelResponse
from model.extraction import extract_rtl
from model.rtl_lex import lexical_fingerprint
from ..core.eda_adapter import EdaAdapterError, is_environment_failure
from ..core.feedback import project_safe_feedback, evidence_capabilities, EvidenceBudgetError
from ..core.failure_memory import FailureMemory
from ..core.failure_evidence import build_failure_evidence, compare_public_behaviors
from ..core.static_checks import check_rtl, syntax_check
from ..core.repair_strategy import classify_failure, strategy_context, applicable_checks
from ..core.search_policy import speculation_admission, POLICY_VERSION, action_cost, call_budget_tradeoffs, admission_decision_key, load_timing_history, save_timing_history
from ..core.task_facts import (build_task_facts, freeze_facts, build_derived,
                               filter_review, check_candidate_interface, candidate_interface_report)
from ..core.stage_context import StageContext, compact_memory
from ..core.task_profile import candidate_plan
from ..core.prompts import stage_instruction
from ..core.storage import (RunStore, atomic_write_json, atomic_write_text, code_version,
                            reserve_run_directory, utc_timestamp, append_event, runtime_identity, identity_binding, assert_runtime_identity, RuntimeIdentityError)
from ..core.task import TaskSpec, load_task
from ..contracts.messages import AgentMessage
from ..runtime.worker_boundary import WorkerBoundary, assert_no_worker_barrier, worker_barrier_path

PIPELINE_VERSION = "bounded_pipeline_resource_v2"


def _json_object(text):
    from model.framing import final_region, ProtocolError
    from ..contracts.schemas import loads, ContractError
    try:
        value = loads(final_region(text, "answer"))
        return value if isinstance(value, dict) else None
    except (ProtocolError, ContractError):
        return None


def pipeline_timings(events, ready_seconds=None):
    """Observed Controller job intervals, not GPU occupancy or causal time saved."""
    models, validations = [], []
    active_model = active_validation = None
    for item in events:
        name, at = item["event"], item["elapsed_seconds"]
        if name == "model_job_started":
            active_model = {"start":at,"candidate_id":item["candidate_id"],
                            "speculative":item.get("speculative",False),"failure_wait_start":None}
        elif name == "validation_started":
            active_validation = {"start":at,"revision_id":item["revision_id"]}
        elif name == "validation_finished":
            if active_validation:
                validations.append({**active_validation,"end":at});active_validation=None
            if not item["passed"] and active_model and active_model["failure_wait_start"] is None:
                active_model["failure_wait_start"] = at
        elif name in {"model_job_finished","model_job_failed"}:
            if active_model:
                models.append({**active_model,"end":at});active_model=None
    speculative = [m for m in models if m["speculative"]]
    overlap = sum(max(0.0,min(m["end"],v["end"])-max(m["start"],v["start"]))
                  for m in speculative for v in validations if v["revision_id"].startswith("candidate_01:"))
    wait = sum(max(0.0,m["end"]-m["failure_wait_start"]) for m in models if m["failure_wait_start"] is not None)
    drain = (sum(max(0.0,m["end"]-max(m["start"],ready_seconds)) for m in models)
             if ready_seconds is not None else 0.0)
    complete = active_model is None and active_validation is None
    return {"measurement_scope":"controller_observed_job_intervals", "complete":complete,
            "speculative_job_count":sum(e["event"] == "model_job_started" and e.get("speculative",False) for e in events),
            "b_a_validation_overlap_seconds":round(overlap,6) if complete else None,
            "failure_model_slot_wait_seconds":round(wait,6) if complete else None,
            "post_success_model_drain_seconds":round(drain,6) if complete else None}


@dataclass(frozen=True)
class Revision:
    candidate_id: str
    repair_index: int
    source: str
    source_path: Path
    directory: Path
    derived: dict[str, Any]
    model_seconds: float = 0.0
    root_strategy_id: str = "direct"
    parent_revision_id: str | None = None
    analyst_advice_visible: bool = True
    context_policy_reason: str = "initial_policy"
    relationship_summary: str = "unknown"

    @property
    def provenance(self):
        return {"root_strategy_id":self.root_strategy_id,"parent_revision_id":self.parent_revision_id,
                "analyst_advice_visible":self.analyst_advice_visible,"context_policy_reason":self.context_policy_reason}


    @property
    def source_hash(self):
        return hashlib.sha256(self.source.encode("utf-8")).hexdigest()

    @property
    def revision_id(self):
        return f"{self.candidate_id}:r{self.repair_index}"


class CandidateSearchRunner:
    def __init__(self, config, model_client, eda_adapter):
        self.config, self.model_client = config, model_client
        self.eda = eda_adapter
        self.worker_boundary = None

    def _generate_stage(self, prompt, task, output_dir, *, derived=None,
                        kind="rtl", reserve_calls=0):
        from ..core.output_protocol import execute_call, MAX_OUTPUT_TOKENS
        limit = MAX_OUTPUT_TOKENS
        from model.framing import output_contract, frame_final
        # Auxiliary analysis/review never retries; preserve the generation/repair budget.
        retries = 0 if kind in {"analyst", "reviewer"} else self.config["agent"]["protocol_retries"]
        for retry in range(retries + 1):
            if self.stop.is_set():
                raise ModelClientError("pipeline_stopped")
            if self.call_count >= self.config["orchestration"]["max_model_calls"] - reserve_calls:
                raise ModelClientError("model_call_budget_exhausted")
            if getattr(self,'runtime_binding',None):
                assert_runtime_identity(self.runtime_binding,self.config)
            self.call_count += 1
            self.context.load()
            payload = {"prompt": prompt, "top_module": task.top_module,
                       "output_dir": str(output_dir / f"call_{retry + 1:02d}"),
                       "response_kind": kind, "source_name": "solution.txt" if kind == "rtl" else "answer.txt",
                       "max_tokens": limit, "request_id": f"model_call_{self.call_count:04d}",
                       "context_binding": {**self.context.binding(derived), "facts_path": str(self.context.path)}}
            if getattr(self,'runtime_binding',None):payload['runtime_identity']=self.runtime_binding
            if self.worker_boundary is None:
                response = execute_call({**payload, "task_id": task.task_id, "run_id": self.run_dir.name}, self.config, self.model_client)
            else:
                payload["mock_response_index"] = self.worker_model_index
                self.worker_model_index += 1
                response = self.worker_boundary.call(AgentMessage("2.0", "llm-generate", task.task_id, self.run_dir.name, payload))
            self.calls.append(response)
            atomic_write_json(self.run_dir / "model_calls.json", self.calls)
            if (response.get('error') or {}).get('code')=='RUNTIME_IDENTITY_MISMATCH':
                self.stop.set()
                raise RuntimeIdentityError(response['error']['message'])
            if response["generation"]["finish_reason"] == "timeout":
                # Closing HTTP does not prove remote computation stopped. Do not dispatch again.
                self.model_timed_out = True
                self.backend_unknown = not response.get("backend",{}).get("next_task_allowed",False)
                self.stop.set()
            if response.get("backend",{}).get("next_task_allowed") is False:
                self.backend_unknown=True
                self.stop.set()
            if (response.get("error") or {}).get("code")=="MODEL_SERVICE_BUSY":
                self.model_service_busy=True
                self.stop.set()
            if response["status"] == "success":
                if kind == "rtl":
                    self.rtl_protocol_failed = False
                    self.last_rtl_protocol_error = None
                field = "source_file" if kind == "rtl" else "answer_file"
                text = frame_final(Path(response[field]).read_text(encoding="utf-8"), kind)
                return ModelResponse(text, response["model_id"], response["revision"], response["elapsed_seconds"],
                                     raw=response, **response["generation"], **response["usage"])
            code = response["error"]["code"]
            if kind == "rtl" and response["error"]["retryable"]:
                self.rtl_protocol_failed = True
                if self.last_rtl_protocol_error == code:
                    self.protocol_blocked = True
                self.last_rtl_protocol_error = code
            if not response["error"]["retryable"]:
                break
            prompt += "\n\nPROTOCOL_CORRECTION\n" + response["error"]["code"] + ": " + response["error"]["message"] + "\n" + output_contract(kind) + " Correct only the reported protocol issue; retain the original task and interface."
        raise ModelClientError(response["error"]["code"] + ": " + response["error"]["message"])

    def _prompt(self, role, path, derived=None, *, include_analyst=True, **delta):
        if role in {"synthesizer", "reviewer", "repairer"}:
            checks = applicable_checks(self.context.load(), derived["task_profile"], role)
            atomic_write_json(path.with_suffix(".checks.json"), checks)
            delta["applicable_checks"] = checks["enabled"]
        name = str(path.relative_to(self.run_dir)).replace("\\", "_").replace("/", "_") + ".json"
        prompt = self.context.render(role, stage_instruction(role), derived, delta,
                                     handoff_path=self.run_dir / "handoffs" / name, include_analyst=include_analyst)
        atomic_write_text(path, prompt)
        atomic_write_json(path.with_suffix(".view.json"), {"role":role,"analyst_advice_visible":include_analyst and role != "reviewer", "delta_fields":sorted(json.loads(prompt.split("\n\nSTAGE_DELTA\n",1)[1]))})
        return prompt

    def _model_job(self, job, task):
        role, directory, derived = job["role"], job["directory"], job["derived"]
        parent = job.get("parent")
        candidate_binding = {"revision_id": parent.revision_id, "source_hash": parent.source_hash} if parent else None
        review = filter_review(None, self.context.load(), parent.source if parent else None, candidate_binding=candidate_binding)
        if role == "rebuild":
            path = self.run_dir / "context" / "contract_rebuild"
            if self.config["analysis"]["mode"] != "disabled":
                prompt = self._prompt("rebuild", path / "analyst_prompt.txt", derived,
                                      evidence=job["feedback"], memory=self.past, attempted_methods=job["attempted_methods"],
                                      previous_attempt={"revision_id": parent.revision_id, "source_hash": parent.source_hash, "candidate": parent.source})
                try:
                    response = self._generate_stage(prompt, task, path / "analyst_response", derived=derived, kind="analyst", reserve_calls=1)
                    proposal = _json_object(response.text)
                except ModelClientError as exc:
                    if self.stop.is_set():
                        raise
                    proposal = None
                    atomic_write_json(path / "analyst_failure.json", {"error": str(exc), "fallback": "source_derived"})
                derived = build_derived(self.context.load(), proposal, version=2)
                atomic_write_json(self.run_dir / "derived_spec.v2.json", derived)
            selection = candidate_plan(derived["task_profile"], ["auto"], 4)
            tried = {item["strategy_id"] for item in job["attempted_methods"]}
            untried = [s for s in selection["selected"] if s["id"] not in tried]
            job["strategy"] = untried[0] if untried else {
                "id":"evidence_reconstruction",
                "instruction":"Reconstruct the implementation from original requirements and the bound failed candidate/evidence. Read attempted_methods and reassessment. Identify the specific source-supported relationship the previous implementation got wrong, or state evidence limits internally. Use a different derivation from failed methods; changing syntax alone is insufficient. Add no unspecified behavior. Return only complete RTL."}
            selection["rebuild_selected"] = job["strategy"]
            atomic_write_json(directory / "strategy_selection.json", selection)
        if job.get("review"):
            prompt = self._prompt("reviewer", directory / "reviewer_prompt.txt", derived, candidate=parent.source,
                                  candidate_binding=candidate_binding, evidence=job["feedback"])
            try:
                response = self._generate_stage(prompt, task, directory / "review_response", derived=derived, kind="reviewer", reserve_calls=1)
                review = filter_review(_json_object(response.text), self.context.load(), parent.source, candidate_binding=candidate_binding)
            except ModelClientError as exc:
                atomic_write_json(directory / "review_failure.json", {"status": "unavailable", "error": str(exc)})
            atomic_write_json(directory / "review.json", review)
        if role == "repairer":
            f = job["feedback"]
            strategy = classify_failure(f.get("stage"), f.get("error_type"), f.get("warnings"), f.get("diagnostics"))
            prompt = self._prompt("repairer", directory / "repairer_prompt.txt", derived,
                candidate=parent.source, candidate_binding=candidate_binding, evidence=f,
                review={k: v for k, v in review.items() if k != "rejected_issues"}, memory=self.past,
                repair_strategy=strategy_context(strategy, derived["task_profile"]),
                include_analyst=job["analyst_advice_visible"])
        else:
            rebuild_context = ({"previous_attempt":{"revision_id":parent.revision_id,"source_hash":parent.source_hash,"candidate":parent.source},
                                "evidence":job["feedback"],"attempted_methods":job["attempted_methods"]}
                               if role == "rebuild" else {})
            prompt = self._prompt("synthesizer", directory / "synthesizer_prompt.txt", derived,
                                  strategy=job["strategy"]["instruction"], memory=self.past,
                                  include_analyst=job["analyst_advice_visible"], **rebuild_context)
        response = self._generate_stage(prompt, task, directory / "code_response", derived=derived,
                                        reserve_calls=job.get("reserve_calls", 0))
        extracted = extract_rtl(response.text, task.top_module)
        source_path = directory / f"solution{task.source_suffix}"
        atomic_write_text(source_path, extracted.source)
        # Reuse existing advisory findings only; this is intended reasoning, not proved RTL behavior.
        relationship_summary = parent.relationship_summary if role == "repairer" else "unknown"
        if role == "repairer" and review.get("issues"):
            issue = review["issues"][0]
            relationship_summary = "unverified repair intent: if " + issue["trigger_condition"] + "; require " + issue["expected_behavior"] + "; prior prediction " + issue["predicted_behavior"]
        elif role == "rebuild" and derived.get("reassessment"):
            relationship_summary = "unverified rebuild intent: " + derived["reassessment"]["next_attempt_change"]
        elif role != "repairer" and job["analyst_advice_visible"] and derived.get("implementation_notes"):
            relationship_summary = "unverified Analyst relation: " + derived["implementation_notes"][0]["statement"]
        revision = Revision(job["candidate_id"], job["repair_index"], extracted.source, source_path,
                            job["candidate_dir"], derived, response.elapsed_seconds,
                            root_strategy_id=parent.root_strategy_id if role == "repairer" else job["strategy"]["id"],
                            parent_revision_id=parent.revision_id if parent else None,
                            analyst_advice_visible=job["analyst_advice_visible"], context_policy_reason=job["context_policy_reason"],relationship_summary=relationship_summary[:256])
        job["resolved_revision"] = revision.revision_id
        status = "unchanged" if role == "repairer" and revision.source_hash == parent.source_hash else "ok"
        atomic_write_json(directory / ("repair.json" if role == "repairer" else "generation.json"), {
            "status": status, "source_path": str(source_path), "source_hash": revision.source_hash,
            "parent_revision": parent.revision_id if parent else None,
            "parent_source_hash": parent.source_hash if parent else None,
            "strategy_id":revision.root_strategy_id,"provenance":revision.provenance,"relationship_summary":revision.relationship_summary, **self.context.binding(derived)})
        return revision, status

    def _validate_revision(self, revision, task, eda_index, validation_budget_seconds=None):
        """The validator sees a job-local binding, never a mutable global stage."""
        if getattr(self,'runtime_binding',None):assert_runtime_identity(self.runtime_binding,self.config)
        self.context.load()
        binding = self.context.binding(revision.derived)
        static_dir = revision.directory / f"precheck_{revision.repair_index:02d}"
        validation_dir = revision.directory / f"validation_{revision.repair_index:02d}"
        static = check_rtl(revision.source, task.top_module)
        static["interface_check"]=candidate_interface_report(revision.source,self.context.load())
        static["issues"].extend({"kind": "interface_or_scope", "message": e}
                                for e in check_candidate_interface(revision.source, self.context.load()))
        syntax = ({"status":"not_executed","reason":"cheap_precheck_blocked","tool":None}
                  if static["issues"] else syntax_check(revision.source_path, task.top_module, static_dir, config=self.config))
        atomic_write_json(static_dir / "syntax_check.json", syntax)
        static["syntax_check"] = syntax
        if syntax["status"] == "failed":
            errors=syntax.get("candidate_errors",[])
            static["issues"].extend(e for e in errors if e.get("kind") in {"syntax_error","elaboration_error"})
            if not static["issues"]:
                static["warnings"].append("standalone frontend inconclusive; authoritative validation required")
        static["status"] = "BLOCK" if static["issues"] else "PASS"
        atomic_write_json(static_dir / "static_check.json", static)
        elapsed, eda_called = 0.0, static["status"] != "BLOCK"
        if not eda_called:
            result = {"passed": False, "stage": "precheck", "error_type": "static_rtl_error",
                      "summary": "; ".join(x["message"] for x in static["issues"]),
                      "warnings": static["warnings"], "source": str(revision.source_path),
                      "candidate_errors":[item for item in static["issues"] if item["kind"] != "syntax_diagnostic_unavailable"][:8]}
        else:
            started = time.monotonic()
            try:
                if self.worker_boundary is None:
                    record = self.eda.validate(task, revision.source_path, validation_dir)
                    result = dict(record.result)
                else:
                    payload = {"task_path": str(task.root), "source_path": str(revision.source_path),
                               "output_dir": str(validation_dir), "mock_eda_scenario_index": eda_index,
                               "context_binding": {**binding, "facts_path": str(self.context.path)}}
                    if getattr(self,'runtime_binding',None):payload['runtime_identity']=self.runtime_binding
                    response = self.worker_boundary.call(AgentMessage("1.0", "vivado-validate", task.task_id, self.run_dir.name, payload))
                    result = dict(response["result"])
                result.pop("public_diagnostics",None)  # Only Controller-owned probes may populate this field.
                result["rtl_version"] = revision.revision_id
            except (EdaAdapterError, ModelClientError) as exc:
                result = {"passed": False, "stage": "environment", "error_type": "eda_adapter_error", "summary": str(exc)}
                if hasattr(exc,"cleaned"):
                    result.update(local_cleanup_confirmed=exc.cleaned,owned_process_pid=exc.pid)
            if not result.get('passed') and not is_environment_failure(result) and result.get('stage')=='simulation' and 'timeout' not in str(result.get('error_type','')).lower():
                from ..core.eda_adapter import run_public_diagnostics
                try:
                    result['public_diagnostics']=run_public_diagnostics(revision.source_path,self.context.load(),validation_dir/'public_diagnostics',budget_seconds=max(0,min(60,(self.config['search']['max_eda_seconds'] if validation_budget_seconds is None else validation_budget_seconds)-(time.monotonic()-started))))
                    atomic_write_json(validation_dir/'public_diagnostics.json',result['public_diagnostics'])
                except EdaAdapterError as exc:
                    if hasattr(exc,'cleaned') and not exc.cleaned:
                        result.update(local_cleanup_confirmed=False,owned_process_pid=exc.pid)
                        result.update(stage='environment',error_type='public_probe_cleanup_unknown')
            elapsed = time.monotonic() - started
        if result.get("local_cleanup_confirmed") is False:
            atomic_write_json(worker_barrier_path(self.config), {"cleanup_confirmed":False,"pid":result.get("owned_process_pid"),
                              "phase":"validator_outer_timeout","revision_id":revision.revision_id,"created_at":utc_timestamp()})
        if not (validation_dir / "result.json").exists():
            atomic_write_json(validation_dir / "result.json", result)
        atomic_write_json(validation_dir / "search_binding.json", {
            "revision_id": revision.revision_id, "source_hash": revision.source_hash, **binding})
        return result, static, eda_called, elapsed, validation_dir

    def _initialization_failure(self, store, manifest, task, started, exc):
        """Finalize failures before the event loop without claiming an RTL attempt."""
        from ..core.output_protocol import error_details
        self.stop.set()
        error = error_details(type(exc).__name__, str(exc))
        wall = round(time.monotonic() - started, 6)
        atomic_write_json(self.run_dir / "initialization_failure.json", {
            "stage":"initialization", "error":error, "exception_type":type(exc).__name__,
            "original_message":str(exc)})
        atomic_write_json(self.run_dir / "model_calls.json", self.calls)
        events = [{"event":"initialization_failed", "elapsed_seconds":wall, "error":error}]
        append_event(self.run_dir / "pipeline_events.jsonl", events[0], durable=True)
        atomic_write_json(self.run_dir / "pipeline_events.json", events)
        final = {"schema_version":"2.0", "mode":"candidate_search",
                 "pipeline_version":PIPELINE_VERSION, "policy_version":POLICY_VERSION,
                 "mock":manifest["mock"], "task_id":task.task_id, "task_version":task.version,
                 "passed":False, "stop_reason":"initialization_failure", "error":error,
                 "first_attempt_passed":False, "attempt_count":0, "candidate_count":0,
                 "generated_candidate_count":0, "repair_count":0, "attempts":[],
                 "model_call_count":self.call_count, "model_calls":self.calls,
                 "model_failure_count":sum(c["status"] == "failed" for c in self.calls),
                 "model_seconds":sum(c["elapsed_seconds"] for c in self.calls),
                 "model_usage":{k:{"reported_sum":sum(c["usage"][k] for c in self.calls if c["usage"][k] is not None),
                                   "unreported_calls":sum(c["usage"][k] is None for c in self.calls)}
                                for k in ("input_tokens","output_tokens","reasoning_tokens")},
                 "eda_seconds":0.0, "wall_clock_seconds":wall, "solution_ready_seconds":None,
                 "drain_seconds":0.0, "drain_status":"backend_state_unknown" if self.backend_unknown else "completed",
                 "discarded_model_jobs":0, "max_pending_validation":0,
                 "final_source":None, "final_source_hash":None, "context_binding":None,
                 "transitions":events, "started_at":manifest["started_at"], "ended_at":utc_timestamp()}
        final["runtime_identity"]=getattr(self,"runtime_binding",None)
        final.update(backend_summary(self.calls))
        final["local_worker_state"] = "unknown" if worker_barrier_path(self.config).exists() else "clear"
        if final["local_worker_state"] == "unknown": final["next_task_allowed"] = False
        store.finish(final)
        return {**final, "run_dir":str(self.run_dir), "environment_failure":True}

    def run(self, problem, output_root=None, run_id=None):
        started = time.monotonic()
        task = problem if isinstance(problem, TaskSpec) else load_task(problem)
        public, search = task.public_snapshot(), self.config["search"]
        self.run_dir = reserve_run_directory(output_root or self.config["experiment"]["output_root"], run_id)
        self.call_count, self.worker_model_index, self.calls = 0, 0, []
        self.stop, self.backend_unknown = Event(), False
        self.model_timed_out, self.model_service_busy = False, False
        self.protocol_blocked, self.rtl_protocol_failed = False, False
        self.last_rtl_protocol_error = None
        self.worker_boundary = None
        store = RunStore(self.run_dir, "candidate_search")
        manifest = {"schema_version": "2.0", "run_id": self.run_dir.name, "mode": "candidate_search",
                    "pipeline_version": PIPELINE_VERSION, "policy_version": POLICY_VERSION,
                    "mock": self.config["model"]["service_type"] == "mock" or self.config["eda"]["adapter"] == "mock",
                    "started_at": utc_timestamp(), "ended_at": None,
                    "code_version": code_version(Path(__file__).resolve().parents[2]),
                    "task_id": task.task_id, "task_version": task.version,
                    "model": {"id": self.config["model"]["id"], "revision": self.config["model"]["revision"]}}
        self.runtime_binding=None
        identity=runtime_identity(self.config)
        self.runtime_binding=identity_binding(identity)
        atomic_write_json(self.run_dir/'runtime_identity.json',identity)
        manifest['runtime_identity']=self.runtime_binding
        manifest['code_version']='sha256:'+self.runtime_binding['code_hash']
        manifest['git_version']=identity['git']
        store.initialize(redacted_snapshot(self.config), public, manifest)
        try:
            assert_no_worker_barrier(self.config)
            self.worker_boundary = WorkerBoundary(self.config, self.run_dir, runtime_binding=self.runtime_binding) if self.config["agent"]["execution_mode"] == "workers" else None
            facts = build_task_facts(public)
            freeze_facts(self.run_dir / "task_facts.json", facts)
            self.context = StageContext(self.run_dir / "task_facts.json")
            memory = FailureMemory(search["failure_memory_root"])
            self.past = compact_memory(memory.retrieve(public, search["memory_limit"]))
            atomic_write_json(self.run_dir / "context" / "memory.json", self.past)
            derived = build_derived(facts, None)
            limit = self.config["orchestration"]["max_model_calls"]
            if limit > 1 and self.config["analysis"]["mode"] == "before_generation":
                prompt = self._prompt("analyst", self.run_dir / "context" / "analyst_prompt.txt", memory=self.past)
                try:
                    response = self._generate_stage(prompt, task, self.run_dir / "context" / "analyst_response", kind="analyst", reserve_calls=1)
                    derived = build_derived(facts, _json_object(response.text))
                except ModelClientError as exc:
                    atomic_write_json(self.run_dir / "context" / "analyst_failure.json", {"error": str(exc), "fallback": "source_derived"})
            atomic_write_json(self.run_dir / "derived_spec.v1.json", derived)
            # Total slots include one optional rebuild; ordinary generation is A/B only.
            selection = candidate_plan(derived["task_profile"], search["strategies"], min(2, search["max_candidates"]))
            atomic_write_json(self.run_dir / "context" / "candidate_strategy_selection.json", selection)
        except Exception as exc:
            return self._initialization_failure(store, manifest, task, started, exc)
        strategies, pending, feedbacks = deque(selection["selected"]), deque(), deque()
        attempts, events, seen = [], [], {}
        method_history = []
        validations, eda_seconds, generated, max_buffer, discarded = 0, 0.0, 0, 0, 0
        mf = vf = job = validating = None
        best = reason = ready_seconds = None
        validation_started, rebuilt = 0.0, False
        handoff_index = {"derived_specification": {"path": "derived_spec.v1.json"}}
        speculation = self.config["speculation"]
        timing_samples=load_timing_history(self.config)
        atomic_write_json(self.run_dir/"timing_basis.json",{"mode":speculation["timing_mode"],"samples":timing_samples,"fallback":"wait_feedback_when_samples_insufficient"})
        last_admission = None
        last_action_deferred = None
        atomic_write_json(self.run_dir / "context" / "search_policy.json", {
            "policy_version": POLICY_VERSION, **speculation,
            "risk_controls_dispatch": False, "completion_estimate": "unknown"})

        def event(name, **data):
            nonlocal max_buffer
            max_buffer = max(max_buffer, len(pending))
            events.append({"event": name, "state": name.upper(), "at": utc_timestamp(),
                           "elapsed_seconds": round(time.monotonic() - started, 6), **data})
            append_event(self.run_dir / "pipeline_events.jsonl", events[-1], durable=name in {"validation_finished","dispatch_stopped","final","stop"})
            atomic_write_json(self.run_dir / "search_state.json", {
                "schema_version": "2.0", "pipeline_version": PIPELINE_VERSION,
                "current_state": name.upper(), "event_count": len(events), "events_file":"pipeline_events.jsonl",
                "model_busy": mf is not None, "validation_busy": vf is not None,
                "pending_validation": [r.revision_id for r in pending],
                "pending_feedback": [f[0].revision_id for f in feedbacks],
                "model_calls": self.call_count, "validations": validations,
                "reserved_validation_slots": len(pending) + int(vf is not None) + int(mf is not None),
                "stop_dispatch": self.stop.is_set()})
            atomic_write_json(self.run_dir / "context" / "shared_context.json", {
                "schema_version": "2.0", "facts_ref": facts["facts_id"], "task_facts_path": "task_facts.json",
                "current_stage": name, "handoffs": handoff_index,
                "program_metadata": {"task_id": task.task_id, "run_id": self.run_dir.name, "model_id": self.config["model"]["id"]}})

        def resources(cost=1):
            return (not self.stop.is_set() and not self.protocol_blocked and self.call_count + cost <= limit
                    and validations + len(pending) + int(vf is not None) < search["max_vivado_calls"]
                    and eda_seconds + (time.monotonic() - validation_started if vf else 0) < search["max_eda_seconds"]
                    and time.monotonic() - started < search["max_wall_clock_seconds"])

        rebuild_calls = action_cost("rebuild",self.config["analysis"]["mode"])
        decisions = []

        def candidate_job(role="synthesizer", failure=None):
            nonlocal generated
            generated += 1
            cid = f"candidate_{generated:02d}" + ("_rebuild" if role == "rebuild" else "")
            directory = self.run_dir / "candidates" / cid
            return {"role": role, "candidate_id": cid, "repair_index": 0,
                    "directory": directory, "candidate_dir": directory,
                    "derived": failure[0].derived if failure else derived,
                    "parent": failure[0] if failure else None,
                    "feedback": failure[1] if failure else None,
                    "strategy": strategies.popleft() if role == "synthesizer" else selection["selected"][0],
                    "attempted_methods":copy.deepcopy(method_history[-32:]),
                    "analyst_advice_visible":self.config["analysis"]["mode"] != "disabled" and not (role == "synthesizer" and generated == 2),
                    "context_policy_reason":("analysis_disabled" if self.config["analysis"]["mode"] == "disabled" else
                                             "reconstruction_with_evidence" if role == "rebuild" else
                                             "independent_alternative" if generated == 2 else "initial_policy"),
                    "cost": action_cost("rebuild" if role=="rebuild" else "generate",self.config["analysis"]["mode"])}

        def repair_job(failure):
            revision, feedback = failure
            review = revision.repair_index == 0 and not evidence_capabilities(feedback)["direct_repair_supported"] and resources(action_cost("review_then_repair",self.config["analysis"]["mode"]))
            return {"role": "repairer", "candidate_id": revision.candidate_id,
                    "repair_index": revision.repair_index + 1,
                    "directory": revision.directory / f"repair_{revision.repair_index + 1:02d}",
                    "candidate_dir": revision.directory, "derived": revision.derived,
                    "parent": revision, "feedback": feedback, "review": review, "cost": action_cost("review_then_repair" if review else "direct_repair",self.config["analysis"]["mode"]),
                    "analyst_advice_visible":revision.analyst_advice_visible,"context_policy_reason":"inherit_parent"}

        event("pipeline_started", policy_version=POLICY_VERSION, buffer_capacity=1, drain_policy="natural_completion")
        with ThreadPoolExecutor(max_workers=1, thread_name_prefix="rtl-model") as models, ThreadPoolExecutor(max_workers=1, thread_name_prefix="rtl-eda") as validators:
            while True:
                # Consume verification first: success wins over speculative model output.
                if vf is not None and vf.done():
                    try:
                        result, static, eda_called, elapsed, validation_dir = vf.result()
                    except Exception as exc:
                        result = {"passed": False, "stage": "environment", "error_type": "pipeline_validation_error", "summary": str(exc)}
                        static, eda_called = {"status": "not_completed"}, False
                        elapsed = time.monotonic() - validation_started
                        validation_dir = validating.directory / f"validation_{validating.repair_index:02d}"
                        atomic_write_json(validation_dir / "infrastructure_failure.json", result)
                    revision = validating
                    for method in method_history:
                        if method["revision_id"] == revision.revision_id and result.get("passed"):
                            method["outcome"] = "passed"
                    vf = validating = None
                    validations += int(eda_called)
                    eda_seconds += elapsed
                    attempts.append({"candidate_id": revision.candidate_id, "revision_id": revision.revision_id,
                        "repair_index": revision.repair_index, "source_path": str(revision.source_path),
                        "source_hash": revision.source_hash, "validation": result,
                        "wall_clock_seconds": elapsed, "timings": result.get("timings", {}),
                        "model_seconds": revision.model_seconds, "static_check": static, "cache_hit": False,
                        **self.context.binding(revision.derived)})
                    event("validation_finished", revision_id=revision.revision_id, source_hash=revision.source_hash, passed=bool(result.get("passed")))
                    if result.get("passed"):
                        best, reason, ready_seconds = revision, "success", time.monotonic() - started
                        atomic_write_json(self.run_dir / "solution_ready.json", {
                            "passed": True, "source_path": str(revision.source_path), "source_hash": revision.source_hash,
                            "revision_id": revision.revision_id, "solution_ready_seconds": ready_seconds,
                            "model_draining": mf is not None, **self.context.binding(revision.derived)})
                    elif is_environment_failure(result):
                        reason = "environment_failure"
                    elif not reason:
                        feedback = project_safe_feedback(result, self.config["eda"]["validator_root"],
                                                         audit_path=validation_dir / "feedback_projection_audit.json")
                        if feedback.get('candidate_feedback_allowed') and 'public_diagnostics' in result:
                            feedback['public_diagnostics']=result['public_diagnostics']
                        if 'execution_trace' in feedback:
                            from ..core.failure_evidence import trace_readiness
                            feedback['replay']=trace_readiness(feedback['execution_trace'],[p['name'] for p in self.context.load()['interface']['ports'] if p['direction']=='input'])
                        feedback["candidate_binding"] = {"revision_id":revision.revision_id,"source_hash":revision.source_hash}
                        feedback["validation_id"] = str(validation_dir.relative_to(self.run_dir)).replace("\\", "/")
                        atomic_write_json(validation_dir / "failure_evidence.json", build_failure_evidence(result, feedback))
                        atomic_write_json(validation_dir / "diagnosis.json", {
                            "safe_feedback": feedback, "revision_id": revision.revision_id, "source_hash": revision.source_hash})
                        memory.record(public, feedback, revision.revision_id)
                        for method in method_history:
                            if method["revision_id"] == revision.revision_id:
                                method["outcome"] = "failed"
                                method["failure_summary"] = feedback.get("summary", "")[:1000]
                                if feedback.get("public_diagnostics",{}).get("status")=="executed":
                                    method["behavior_summary"]="Executed public cases, not global equivalence: "+json.dumps(feedback["public_diagnostics"]["cases"][:3],ensure_ascii=True)[:1100]
                        if feedback.get("candidate_feedback_allowed"):
                            feedbacks.append((revision, feedback))
                            event("feedback_queued", revision_id=revision.revision_id, source_hash=revision.source_hash,
                                  capabilities=evidence_capabilities(feedback, scope=revision.derived["task_profile"].get("implementation_scope", {}).get("value", "unknown")))
                    if reason:
                        self.stop.set()
                        event("dispatch_stopped", reason=reason, dropped_validation=[r.revision_id for r in pending])
                        pending.clear(); feedbacks.clear(); strategies.clear()
                if mf is not None and mf.done():
                    future, completed_job = mf, job
                    mf = job = None
                    try:
                        revision, status = future.result()
                    except RuntimeIdentityError as exc:
                        reason = "runtime_identity_mismatch"
                        self.stop.set(); pending.clear(); feedbacks.clear(); strategies.clear()
                        atomic_write_json(completed_job["directory"] / "job_failure.json", {"code":exc.code,"error":str(exc),"role":completed_job["role"]})
                        event("model_job_failed", role=completed_job["role"], candidate_id=completed_job["candidate_id"])
                        event("dispatch_stopped", reason=reason)
                    except EvidenceBudgetError as exc:
                        reason = "context_evidence_incomplete"
                        self.stop.set(); pending.clear(); feedbacks.clear(); strategies.clear()
                        atomic_write_json(completed_job["directory"] / "job_failure.json", {"code":exc.code,"error":str(exc),"role":completed_job["role"]})
                        event("model_job_failed", role=completed_job["role"], candidate_id=completed_job["candidate_id"])
                        event("dispatch_stopped", reason=reason)
                    except ModelClientError as exc:
                        atomic_write_json(completed_job["directory"] / "job_failure.json", {"error": str(exc), "role": completed_job["role"]})
                        event("model_job_failed", role=completed_job["role"], candidate_id=completed_job["candidate_id"])
                    except Exception as exc:
                        atomic_write_json(completed_job["directory"] / "job_failure.json", {"error": str(exc), "role": completed_job["role"], "infrastructure": True})
                        if not reason:
                            reason = "pipeline_infrastructure_error"
                        self.stop.set()
                        pending.clear(); feedbacks.clear(); strategies.clear()
                        event("dispatch_stopped", reason=reason)
                    else:
                        method_history.append({"revision_id":revision.revision_id,"source_hash":revision.source_hash,
                            "strategy_id":revision.root_strategy_id,"parent_revision_id":revision.parent_revision_id,
                            "analyst_advice_visible":revision.analyst_advice_visible,"relationship_summary":revision.relationship_summary,
                            "outcome":"generated","failure_summary":""})
                        atomic_write_json(self.run_dir / "attempted_methods.json", method_history)
                        event("model_job_finished", revision_id=revision.revision_id, source_hash=revision.source_hash)
                        if self.stop.is_set():
                            discarded += 1
                            atomic_write_json(completed_job["directory"] / "disposition.json", {"status": "discarded_after_stop", "reason": reason or "backend_state_unknown"})
                            event("model_drained", revision_id=revision.revision_id, disposition="discarded")
                        elif lexical_fingerprint(revision.source) in seen:
                            duplicate_of=seen[lexical_fingerprint(revision.source)]
                            atomic_write_json(completed_job["directory"] / "disposition.json", {"status":"duplicate_skipped","duplicate_of":duplicate_of,"fingerprint_kind":lexical_fingerprint(revision.source)[0]})
                            event("duplicate_skipped", revision_id=revision.revision_id, source_hash=revision.source_hash, duplicate_of=duplicate_of, fingerprint_kind=lexical_fingerprint(revision.source)[0])
                        else:
                            seen[lexical_fingerprint(revision.source)] = revision.revision_id
                            pending.append(revision)
                            handoff_index[revision.candidate_id] = {"source_path": str(revision.source_path.relative_to(self.run_dir))}
                            event("candidate_queued", revision_id=revision.revision_id, source_hash=revision.source_hash)
                if (self.backend_unknown or self.model_timed_out or self.model_service_busy) and not reason:
                    reason = ("model_timeout_backend_unknown" if self.model_timed_out and self.backend_unknown else
                              "backend_state_unknown" if self.backend_unknown else
                              "model_timeout" if self.model_timed_out else "model_service_busy")
                    self.stop.set(); pending.clear(); feedbacks.clear(); strategies.clear()
                    event("dispatch_stopped", reason=reason)
                if reason:
                    active = [f for f in (mf, vf) if f is not None]
                    if not active:
                        break
                    wait(active, timeout=0.05, return_when=FIRST_COMPLETED)
                    continue
                if time.monotonic() - started >= search["max_wall_clock_seconds"]:
                    reason = "wall_clock_dispatch_budget_exhausted"
                    self.stop.set(); pending.clear(); feedbacks.clear(); strategies.clear()
                    event("dispatch_stopped", reason=reason)
                    continue
                if vf is None and pending:
                    if validations >= search["max_vivado_calls"] or eda_seconds >= search["max_eda_seconds"]:
                        reason = "validation_budget_exhausted"
                        self.stop.set(); pending.clear(); feedbacks.clear(); strategies.clear()
                        event("dispatch_stopped", reason=reason)
                        continue
                    validating = pending.popleft()
                    validation_started = time.monotonic()
                    vf = validators.submit(self._validate_revision, validating, task, validations, validation_budget_seconds=search["max_eda_seconds"]-eda_seconds)
                    event("validation_started", revision_id=validating.revision_id, source_hash=validating.source_hash)
                if mf is None and vf is not None:
                    admission = speculation_admission(
                        **speculation, timing_samples=timing_samples, validation_elapsed_seconds=time.monotonic()-validation_started, remaining_calls=limit - self.call_count,
                        free_validations=search["max_vivado_calls"] - validations - len(pending) - int(vf is not None),
                        strategy_available=bool(strategies), candidate_available=generated < search["max_candidates"],
                        buffer_full=bool(pending), feedback_pending=bool(feedbacks),
                        stopped=self.stop.is_set() or self.protocol_blocked, backend_unknown=self.backend_unknown,
                        wall_seconds_left=search["max_wall_clock_seconds"] - (time.monotonic() - started),
                        eda_seconds_left=search["max_eda_seconds"] - eda_seconds - (time.monotonic() - validation_started))
                    if admission_decision_key(admission) != admission_decision_key(last_admission):
                        event("speculation_allowed" if admission["allowed"] else "speculation_denied", **admission)
                        last_admission = admission
                if mf is None and not pending and resources():
                    next_job = None
                    repairable = [f for f in feedbacks if f[0].repair_index < search["max_repairs_per_candidate"]]
                    concrete = next((f for f in repairable if evidence_capabilities(f[1])["direct_repair_supported"]), None)
                    reconstruction = next((f for f in feedbacks if f[0].repair_index > 0 and evidence_capabilities(f[1], scope=f[0].derived["task_profile"].get("implementation_scope", {}).get("value", "unknown"))["reconstruction_after_failed_repair"]), None)
                    if concrete:
                        feedbacks.remove(concrete); next_job = repair_job(concrete)
                    elif (reconstruction and not strategies and not rebuilt and vf is None
                            and generated < search["max_candidates"] and resources(rebuild_calls)):
                        next_job = candidate_job("rebuild", reconstruction); rebuilt = True
                    elif feedbacks:
                        # Known failures take precedence over speculative work.
                        if strategies:
                            next_job = candidate_job()
                        elif repairable:
                            # Do not spend a second vague review while a repair result can
                            # decide between success and reconstruction. Concrete repairs
                            # above remain admissible; there is no permanent call reserve.
                            defer = (vf is not None and (validating.candidate_id.endswith('_rebuild') or
                                     (validating.repair_index > 0 and not rebuilt
                                      and generated < search["max_candidates"] and resources(rebuild_calls))))
                            if defer:
                                if last_action_deferred != validating.revision_id:
                                    event("action_deferred", action="review_then_repair",
                                          reason=("await_reconstruction_validation_before_unlocalized_repair" if validating.candidate_id.endswith("_rebuild") else "await_repair_validation_before_unlocalized_review"),
                                          revision_id=validating.revision_id)
                                    last_action_deferred = validating.revision_id
                            else:
                                failure = repairable[0]; feedbacks.remove(failure); next_job = repair_job(failure)
                        elif (not rebuilt and vf is None and generated < search["max_candidates"] and resources(rebuild_calls)):
                            next_job = candidate_job("rebuild", feedbacks[-1]); rebuilt = True
                    elif strategies and vf is None:
                        next_job = candidate_job()
                    elif vf is not None:
                        if admission["allowed"]:
                            next_job = candidate_job()
                            next_job["reserve_calls"] = speculation["failure_reserve_calls"]
                            next_job["speculative"] = True
                    if next_job:
                        action = ("rebuild" if next_job["role"] == "rebuild" else
                                  "review_then_repair" if next_job.get("review") else
                                  "direct_repair" if next_job["role"] == "repairer" else "generate")
                        reason_code = (("aggregate_failure_after_repair" if evidence_capabilities(reconstruction[1])["aggregate_only"] else "temporal_observation_after_failed_repair") if action == "rebuild" and reconstruction else
                                       ("located_tool_error" if evidence_capabilities(concrete[1])["located_tool_error"] else "observed_io_direct_repair") if action == "direct_repair" and concrete else
                                       "unlocalized_failure_first_review" if action == "review_then_repair" else
                                       "last_repair_opportunity" if action == "direct_repair" else
                                       "failed_methods_exhausted" if action == "rebuild" else "compatible_derivation")
                        alternatives = []
                        if action == "review_then_repair":
                            alternatives.append({"action":"rebuild", "reason":"no_failed_repair_requiring_reconstruction_or_not_admissible"})
                        if action == "rebuild" and repairable:
                            alternatives.append({"action":"review_then_repair", "reason":"prefer_reconstruction_after_failed_repair"})
                        decision = {"selected_action":action,"reason_code":reason_code,"required_calls":next_job["cost"],
                                    "required_validations":1,"alternatives_not_selected":alternatives,
                                    "call_budget_tradeoffs":call_budget_tradeoffs(action,limit-self.call_count,self.config['analysis']['mode']),
                                    "cost_basis":"minimum_calls_protocol_retries_consume_actual_remaining_budget",
                                    "remaining_calls_before":limit-self.call_count,"candidate_id":next_job["candidate_id"],
                                    "evidence_capabilities":evidence_capabilities(next_job["feedback"],scope=next_job["derived"]["task_profile"].get("implementation_scope",{}).get("value","unknown")) if next_job.get("feedback") else None}
                        decisions.append(decision)
                        atomic_write_json(self.run_dir / "action_decisions.json", decisions)
                        event("action_selected", **decision)
                        job = next_job
                        mf = models.submit(self._model_job, job, task)
                        event("model_job_started", role=job["role"], candidate_id=job["candidate_id"],
                              parent_revision=job["parent"].revision_id if job.get("parent") else None,
                              reserved_model_calls=job["cost"], reserved_validation_slots=1,
                              failure_reserve_calls=job.get("reserve_calls", 0),
                              speculative=job.get("speculative", False))
                active = [f for f in (mf, vf) if f is not None]
                if not active:
                    reason = ("model_protocol_error" if self.protocol_blocked or self.rtl_protocol_failed else
                              "model_call_budget_exhausted" if self.call_count >= limit else
                              "validation_budget_exhausted" if validations >= search["max_vivado_calls"] or eda_seconds >= search["max_eda_seconds"] else
                              "candidate_search_exhausted")
                    self.stop.set()
                    break
                wait(active, timeout=0.05, return_when=FIRST_COMPLETED)
        event("final" if best else "stop", reason=reason)
        atomic_write_json(self.run_dir / "pipeline_events.json", events)
        wall = time.monotonic() - started
        timing_observations = pipeline_timings(events, ready_seconds)
        atomic_write_json(self.run_dir / "speculation_timings.json", timing_observations)
        blockers = {
            "applicable":reason == "candidate_search_exhausted",
            "remaining_model_calls":max(0, limit-self.call_count),
            "remaining_validations":max(0, search["max_vivado_calls"]-validations),
            "generated_candidates":generated,"candidate_limit":search["max_candidates"],
            "ordinary_strategy_ids_left":[s["id"] for s in strategies],
            "repairable_revisions":[r.revision_id for r,f in feedbacks if r.repair_index < search["max_repairs_per_candidate"]],
            "rebuild_used":rebuilt,
            "blocked_reasons": (["candidate_limit_reached"] if generated >= search["max_candidates"] else [])
                + (["rebuild_call_budget_insufficient"] if limit-self.call_count < rebuild_calls else [])
                + (["validation_budget_exhausted"] if validations >= search["max_vivado_calls"] or eda_seconds >= search["max_eda_seconds"] else [])
                + (["ordinary_strategies_exhausted"] if not strategies else [])
                + (["no_repairable_feedback"] if not any(r.repair_index < search["max_repairs_per_candidate"] for r,f in feedbacks) else [])
                + (["rebuild_already_used"] if rebuilt else [])
                + (["no_available_failure_feedback"] if not feedbacks else [])}
        atomic_write_json(self.run_dir / "attempted_methods.json", method_history)
        atomic_write_json(self.run_dir / "observed_behavior_comparison.json",compare_public_behaviors(attempts))
        atomic_write_json(self.run_dir/"timing_history_update.json",save_timing_history(self.config,self.calls,attempts))
        atomic_write_json(self.run_dir / "search_exhaustion.json", blockers)
        final = {"schema_version": "2.0", "mode": "candidate_search", "pipeline_version": PIPELINE_VERSION, "policy_version": POLICY_VERSION,
            "mock": manifest["mock"], "task_id": task.task_id, "task_version": task.version,
            "passed": best is not None, "stop_reason": reason, "search_exhaustion":blockers,
            "first_attempt_passed": bool(best and best.candidate_id == "candidate_01" and best.repair_index == 0),
            "attempt_count": len(attempts), "candidate_count": len({a["candidate_id"] for a in attempts}),
            "generated_candidate_count": generated, "repair_count": sum(a["repair_index"] > 0 for a in attempts),
            "model_call_count": self.call_count, "context_binding": self.context.binding(best.derived if best else derived),
            "model_seconds": round(sum(c["elapsed_seconds"] for c in self.calls), 6),
            "eda_seconds": round(eda_seconds, 6), "wall_clock_seconds": round(wall, 6),
            "solution_ready_seconds": round(ready_seconds, 6) if ready_seconds is not None else None,
            "speculation_timings":timing_observations,
            "drain_seconds": round(wall - ready_seconds, 6) if ready_seconds is not None else 0.0,
            "drain_status": "backend_state_unknown" if self.backend_unknown else "completed",
            "discarded_model_jobs": discarded, "max_pending_validation": max_buffer,
            "final_source": str(best.source_path) if best else None, "final_source_hash": best.source_hash if best else None,
            "model_calls": self.calls, "model_failure_count": sum(c["status"] == "failed" for c in self.calls),
            "model_usage": {k: {"reported_sum": sum(c["usage"][k] for c in self.calls if c["usage"][k] is not None),
                                 "unreported_calls": sum(c["usage"][k] is None for c in self.calls)}
                            for k in ("input_tokens", "output_tokens", "reasoning_tokens")},
            "attempts": attempts, "transitions": events, "started_at": manifest["started_at"], "ended_at": utc_timestamp()}
        final["runtime_identity"]=getattr(self,"runtime_binding",None)
        final.update(backend_summary(self.calls))
        final["local_worker_state"] = "unknown" if worker_barrier_path(self.config).exists() else "clear"
        if final["local_worker_state"] == "unknown": final["next_task_allowed"] = False
        store.finish(final)
        return {**final, "run_dir": str(self.run_dir), "environment_failure": reason in {"environment_failure","backend_state_unknown","model_service_busy"} or not final["next_task_allowed"]}
