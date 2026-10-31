"""Resource/time admission and bounded latency observations; no model risk or second execution loop."""
from __future__ import annotations

POLICY_VERSION = "resource_time_admission_v3"


def speculation_admission(*, enabled, failure_reserve_calls, remaining_calls,
                          free_validations, strategy_available, candidate_available, time_reserve,
                          model_busy=False, buffer_full=False, feedback_pending=False,
                          validation_active=True, stopped=False, backend_unknown=False,
                          wall_seconds_left=1.0, eda_seconds_left=1.0, timing_mode="fixed_window", timing_samples=None, validation_elapsed_seconds=0.0):
    """free_validations already excludes completed and in-flight/waiting jobs.

    One new candidate plus one future repair require two free validations.
    Fixed configured allowances are conservative dispatch gates, not backend
    duration predictions or promises of completion before the soft deadline.
    """
    required_wall = sum(time_reserve.values())
    required_eda = time_reserve["validation_seconds"]
    timing_samples=timing_samples or {}
    generation=timing_samples.get('generation_seconds',[])
    validation=timing_samples.get('validation_seconds',[])
    enough=len(generation)>=2 and len(validation)>=2
    basis='local_duration_samples' if timing_mode=='observed' and enough else 'fixed_configured_allowances'
    generation_estimate=max(generation)*1.25 if basis=='local_duration_samples' else time_reserve['generation_seconds']
    validation_estimate=max(validation)*1.25 if basis=='local_duration_samples' else time_reserve['validation_seconds']
    remaining_estimate=max(0,validation_estimate-validation_elapsed_seconds)
    checks = (
        (stopped or backend_unknown, "pipeline_stopped"),
        (not enabled, "speculation_disabled"),
        (not validation_active, "no_active_validation"),
        (model_busy, "model_busy"),
        (buffer_full, "buffer_full"),
        (feedback_pending, "feedback_has_priority"),
        (not strategy_available, "no_compatible_strategy"),
        (not candidate_available, "candidate_limit_reached"),
        (remaining_calls < 1 + failure_reserve_calls, "insufficient_model_budget"),
        (free_validations < 2, "insufficient_validation_budget"),
        (wall_seconds_left <= 0, "dispatch_deadline_reached"),
        (eda_seconds_left <= 0, "eda_budget_exhausted"),
        (wall_seconds_left < required_wall, "insufficient_wall_time_reserve"),
        (eda_seconds_left < required_eda, "insufficient_eda_time_reserve"),
        (timing_mode=='feedback_first', "feedback_first_policy"),
        (timing_mode=='observed' and not enough, "insufficient_timing_samples_wait_feedback"),
        (remaining_estimate < generation_estimate, "insufficient_expected_overlap"),
    )
    reason = next((reason for blocked, reason in checks if blocked), "resources_available")
    return {"policy_version": POLICY_VERSION, "allowed": reason == "resources_available",
            "reason_code": reason, "remaining_model_calls": remaining_calls,
            "free_validation_slots": free_validations,
            "failure_reserve_calls": failure_reserve_calls,
            "required_model_calls": 1 + failure_reserve_calls,
            "required_validation_slots": 2, "required_wall_seconds":required_wall,
            "required_eda_seconds":required_eda,"time_reserve_basis":basis,"timing_mode":timing_mode,
            "generation_sample_count":len(generation),"validation_sample_count":len(validation),
            "estimated_generation_seconds":generation_estimate,"estimated_validation_remaining_seconds":remaining_estimate,
            "completion_estimate":"heuristic_not_guaranteed"}


def admission_decision_key(value):
    """Do not emit a new event on every millisecond of elapsed validation."""
    if value is None:return None
    return tuple(value.get(k) for k in ('allowed','reason_code','time_reserve_basis','generation_sample_count','validation_sample_count'))


def action_cost(action, analysis_mode):
    return {'generate':1,'direct_repair':1,'review_then_repair':2,'rebuild':1 if analysis_mode=='disabled' else 2}[action]


def call_budget_tradeoffs(action, remaining, analysis_mode):
    after=remaining-action_cost(action,analysis_mode)
    return [{'action':name,'required_calls':action_cost(name,analysis_mode),'affordable_before':remaining>=action_cost(name,analysis_mode),
             'affordable_after':after>=action_cost(name,analysis_mode),'lost_due_to_this_action':remaining>=action_cost(name,analysis_mode)>after}
            for name in ('generate','direct_repair','review_then_repair','rebuild') if name!=action]


def timing_history_path(config):
    import hashlib,json
    from pathlib import Path
    key={'model':{k:config['model'][k] for k in ('url','id','revision')},
         'eda':{k:config['eda'][k] for k in ('adapter','validator_root','target_part','timeouts')},
         'controller_hash':hashlib.sha256((Path(__file__).parents[1]/'orchestration/candidate_search.py').read_bytes()).hexdigest()}
    digest=hashlib.sha256(json.dumps(key,sort_keys=True).encode()).hexdigest()
    return Path(config['model']['backend_drain']['state_root'])/'timing-history'/(digest+'.json')


def load_timing_history(config):
    import json,math
    empty={'generation_seconds':[],'validation_seconds':[]}
    if config['model']['service_type']!='http':return empty
    try:
        path=timing_history_path(config)
        if path.stat().st_size>8192:return empty
        value=json.loads(path.read_text(encoding='utf-8'))
        if set(value)!=set(empty):return empty
        for key,values in value.items():
            if not isinstance(values,list) or len(values)>16 or any(type(v) not in (int,float) or not math.isfinite(v) or v<=0 or v>config['search']['max_wall_clock_seconds'] for v in values):return empty
        return value
    except (OSError,ValueError,TypeError):return empty


def save_timing_history(config, calls, attempts):
    """Timing only, no task classes, source, feedback, pass rates or shared budgets."""
    import math
    from .storage import atomic_write_json
    if config['model']['service_type']!='http':return {'status':'not_applicable_mock_model'}
    value=load_timing_history(config)
    generation=[c.get('elapsed_seconds') for c in calls if c.get('status')=='success' and c.get('response_kind')=='rtl']
    validation=[a.get('wall_clock_seconds') for a in attempts if a.get('validation',{}).get('stage') in {'simulation','synthesis','complete'} and a.get('static_check',{}).get('status')=='PASS']
    for key,values in [('generation_seconds',generation),('validation_seconds',validation)]:
        value[key]=(value[key]+[v for v in values if type(v) in (float,int) and math.isfinite(v) and 0<v<=config['search']['max_wall_clock_seconds']])[-16:]
    try:
        atomic_write_json(timing_history_path(config),value)
        return {'status':'recorded','generation_sample_count':len(value['generation_seconds']),'validation_sample_count':len(value['validation_seconds'])}
    except OSError:return {'status':'unavailable'}
