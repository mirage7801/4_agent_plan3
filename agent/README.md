# Agent 当前架构

2026-10-29：[诊断与结构检查修复](../docs/agent-bugfixes-20261029.md)。端口诊断采用明确短语，未初始化特征先于通用状态匹配；结构检查共用 `model.rtl_lex.mask_noncode`，Repairer 检查列表不再作为排他边界。共同词法现位于新增的model/rtl_lex.py；agent模块数保持29。baseline生成提示与配置不变。

工程：`D:/AMD/4_agent_plan3`。唯一Controller：`orchestration/candidate_search.py`，执行版本 `bounded_pipeline_resource_v2`，资源策略 `resource_time_admission_v3`。

```text
agent/
├─ cli.py / worker_cli.py / resume.py
├─ orchestration/
│  └─ candidate_search.py       # 唯一派发、候选Revision、槽位/反馈/预算控制
├─ runtime/
│  ├─ run.py                    # run_task：运行生命周期、任务清单、报告收尾
│  ├─ worker_boundary.py        # 独立进程消息、身份/事实绑定、异常恢复
│  └─ reporting.py              # collect_evidence：只收集已落盘证据
├─ contracts/
│  ├─ schemas.py                # 唯一嵌套字段合同源
│  └─ messages.py               # worker信封、身份和响应校验
└─ core/
   ├─ task.py / task_facts.py / task_profile.py / stage_context.py
   ├─ prompts.py / repair_strategy.py / search_policy.py
   ├─ static_checks.py / output_protocol.py
   ├─ diagnostics.py / feedback.py / failure_evidence.py / failure_memory.py
   └─ eda_adapter.py / storage.py
```

## 实际执行

`run.ps1/run.sh/run_closed_loop.ps1 → agent.cli → runtime.run.run_task → CandidateSearchRunner`。

模型：`StageContext → _model_job → _generate_stage → execute_call → serve.factory/HttpModelClient → BackendLease → HTTP`。workers仅在execute_call外增加`runtime.worker_boundary → agent.worker_cli`进程边界；两种模式由同一个Controller派发，不是两套搜索器。

验证：不可变Revision → 唯一预检 → core.eda_adapter（进程内直接调用，workers经vivado-validate）→ 版本/源码哈希绑定反馈。Vivado原始结果不改，内部结果由Controller附加rtl_version。报告：runtime.reporting.collect_evidence，两种模式均直接调用，不再启动report worker；resume仅恢复已有证据，不派发模型/EDA。

Analyst/Synthesizer/Reviewer/Repairer是模型提示角色；worker、报告收集和EDA适配器是程序执行边界。模型与验证各1槽、待验证1位；按资源准入提前生成B。通过后停止新派发，已有生成自然结束。没有旧主循环、关键词风险路由、跨运行验证缓存或独立Planner。

## 保留和删除

删除未使用的TaskEnvelope/ValidationRequest/ScriptProposal/GenerationRequest/ValidationResponse及VersionRegistry。Revision和不可变候选快照已经承担当前版本管理；未保留另一套current.json注册器。消息模块从contracts/common/messages.py移到contracts/messages.py；worker边界从runtime/scheduler移到runtime。旧SchedulerAgent包装被普通run_task函数替代，报告包装改为collect_evidence函数，VivadoAgent包装删除。旧导入不保留兼容别名。

`scheduler/task_manifest.json`与`scheduler/messages/`是既有运行产物路径，继续保留便于报告/审计；这个目录不代表另一个调度器。历史runs/reports及日期验收文档不改写。只读报告仍可识别历史versions目录。

## 输出、超时和验收

全局格式定义在model/framing.py，JSON字段定义在contracts/schemas.py；代码严格支持唯一一层完整answer包装。来源引用仅忽略空白，禁止跨未引用行拼接。分析失败不协议重试；同类代码协议错误连续出现时停止新生成，已有合法候选继续验证。

所有角色8912输出、生成请求300秒、独立收尾120秒；404/405立即退出3且保留pending，未知状态禁止下一题。参考服务状态接口必须另行部署，本次不重启远端。

运行：`python -B -m agent.cli run --problem <task> --config config/experiment.example.json --output runs`。
验收：`python -B -m unittest discover -s tests -v`。实际CLI/HTTP与独立假验证器覆盖两种模式的角色链、修复/重建、资源准入、并行、停止后收尾和输出协议，不只检查版本字符串。替身不是实际GPU/Vivado测评证据。

[唯一详细架构](../docs/candidate-search-architecture.md) · [接口](../docs/interfaces.md) · [精简记录](../docs/agent-structure-20261028.md)

## Analyst 实施建议合同（2026-10-29）

Analyst只输出implementation_notes和ambiguities，重分析额外输出reassessment。移除risk/derivations/模型task_profile/unresolved_questions以及派生profile_proposal_audit等旧字段和无用校验函数。derived_spec升级3.0，引用来源核验不代表语义正确，所有例子均未验证；结构错误回退，坏引用逐条剔除审计。分析调用时机由analysis.mode控制；当前动作选择和资源规则见三批链路修复。

复用contracts/schemas.py、core/task_facts.py、output_protocol.py、prompts.py、stage_context.py与唯一Controller，无新增Agent/框架/生产目录。tests/test_analyst.py及两种模式的实际CLI/HTTP链检查非空建议传递、坏引用隔离、重分析源码绑定与后续生成。详见[当前合同与验收](../docs/analyst-contract-20261029.md)。

## Reviewer 针对性诊断（2026-10-29）

Reviewer输入绑定失败候选、revision_id/source_hash和对应安全反馈；输出issues（最多4）与limitations（最多3），删除risk/required_checks，observed_behavior替换为predicted_behavior。来源/行号/代码片段错误逐条拒绝，合法意见仅标未验证；Repairer检查绑定一致后接收。审查最多一次，无协议重试；空结果不等于通过，最终仍由原有预检和EDA验证。

删除execute_review_checks及其验证队列携带/重复产物路径，现有真实预检保留。复用原schemas/prompts/task_facts/stage_context/output_protocol与唯一Controller，不新增生产模块或Agent框架。合同、路径和验收见[Reviewer改造](../docs/reviewer-contract-20261029.md)。


## 搜索、证据与上下文更新（2026-10-29）

当前普通候选最多 A/B，第三候选名额用于一次失败重建；调用/验证预算不增加。未知画像有通用第二策略。诊断直达、Reviewer 隔离分析建议、重建证据直传、阶段输入裁剪与可选精确 token 预检，见 [当前行为与验收](../docs/search-evidence-context-20261029.md)。8912/300 秒与自然收尾不变，baseline 不变，无新增 Agent/目录。


当前三批修复见 [三批链路修复](../docs/three-batch-hardening-20261029.md)。第一批统一必要证据、候选反馈绑定、前端路径诊断和 Reviewer 单份源码视图。


三批修复现已覆盖：analysis.mode、B意见隔离、动作选择、反馈身份、必要错误保留、Reviewer单份源码、准确的重放状态，以及speculation.time_reserve和speculation_timings。当前默认after_failure；8912/300秒、自然收尾与baseline生成语义不变。


当前词法、候选推导及运行链路更新见 [三批实施说明](../docs/semantic-hardening-20261029.md)。共同词法位于model/rtl_lex.py，B修复继承意见隔离策略。


2026-10-30 当前边界修复与顺序验收见 [边界、证据与调度修复](../docs/boundary-evidence-hardening-20261030.md)。未知接口/预处理/前端能力限制交给权威验证；worker 异常统一确认后端状态。


2026-10-30 当前运行规则：默认 analysis.mode=after_failure；speculation.timing_mode=observed，耗时样本不足等待 A 反馈；远端 SiliconMind 配置启用身份核验后的准确 token 预检。动作预算记录放弃的调用机会，策略版本 resource_time_admission_v3。详见 [边界、证据与调度修复](../docs/boundary-evidence-hardening-20261030.md)。8912/300 秒与后端自然结束规则不变。


2026-10-30 当前词法、诊断完整性和运行身份规则见 [三批精确修复](../docs/precision-hardening-20261030.md)。转义标识符不当成结构关键字；diagnostic_coverage 明确说明安全 warning 省略/缩短；runtime_identity.json 绑定源码和脱敏有效配置，普通 worker 派发前核验。单 Controller、8912 token、300秒及自然收尾保持不变。
