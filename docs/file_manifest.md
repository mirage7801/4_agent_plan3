# 当前文件清单

当前工程根目录：`D:/AMD/4_agent_plan3`。架构详见 [candidate-search-architecture.md](candidate-search-architecture.md)。

| 路径 | 职责 |
|---|---|
| agent/core/task.py | task 1.0加载和公开快照 |
| agent/core/task_facts.py | 原题/接口冻结、派生来源检查、审查过滤、接口范围检查 |
| agent/core/task_profile.py | 来源支持的任务特征、模型建议核对、兼容候选策略 |
| agent/core/stage_context.py | 所有模型阶段的统一输入、可见范围、增量交接 |
| agent/core/prompts.py | baseline提示词和角色指令 |
| agent/orchestration/candidate_search.py | 唯一有界流水线Controller、Revision、模型/验证槽、反馈队列、预算与自然收尾 |
| agent/core/static_checks.py | 唯一结构预检 |
| agent/core/feedback.py / failure_evidence.py | 安全反馈与失败观测 |
| agent/core/search_policy.py / repair_strategy.py | 纯资源准入与条件修复提示；task_profile仅判断策略兼容性 |
| agent/core/failure_memory.py | 有界失败记忆；验证仅在Controller运行内去重 |
| agent/core/storage.py | 原子产物和不可覆盖运行目录 |
| agent/worker_cli.py / runtime/worker_boundary.py | 保持既有执行边界，核对context_binding |
| agent/resume.py | 核对事实版本的证据恢复，不自动续跑 |
| agent/contracts/messages.py / runtime/ | 既有公共消息与实际使用的验证/报告模块 |
| model/ / serve/ / config/ | 模型协议、服务与统一配置 |
| baseline/ | 同模型单次生成基线 |
| report/ | 保存证据统计 |
| tests/test_task_facts_context.py | 本版事实/输入/权限/修复/分支隔离回归 |
| tests/其余测试 | 现有模型、验证器、消息和报告回归 |

移除：agent/core/spec_review.py、agent/core/static_precheck.py，以及两个旧架构说明文件（architecture 和 four-agent-architecture）；详细架构统一保留 candidate-search-architecture.md。对应引用已更新。未删除历史运行、日志、报告、题目或验证资产。

本阶段另删除agent/roles/rtl/llm_agent/agent.py、其__init__.py及上层rtl/__init__.py。新增tests/test_task_profile_policy.py和tests/test_policy_http_chain.py；不改题目和验证器资产。


输出协议阶段新增：agent/contracts/schemas.py（单一闭合合同与项目子集验证器）、agent/core/output_protocol.py（统一审计/解析/失败信封）、model/framing.py（严格区域边界）、tests/test_output_protocol.py和tests/protocol_fixtures.py。修改原有提取器以删除旧回退；没有遗留第二套生产解析链。所有新路径在当前plan3工程内，历史运行不迁移。

流水线阶段删除agent/core/validation_cache.py；新增tests/test_pipeline.py、docs/pipeline-verification-20261023.md及合成证据JSON。没有新增生产队列模块或第二套Controller。WorkerBoundary增加并发消息编号锁；runtime.reporting.collect_evidence收集队列和成功就绪证据。

2026-10-25：删除agent/core/risk.py，新增agent/core/search_policy.py和tests/test_search_policy.py；复用原Controller，没有新增执行框架。当前验收见resource-admission-verification-20261025.md。

2026-10-25 内部合同修复：复用 task_profile/task_facts/stage_context/output_protocol/feedback、原 Controller 与 runtime.reporting.collect_evidence；新增 tests/test_internal_contracts.py 和 docs/internal-contract-verification-20261025.md（及 JSON 证据）。没有新增生产模块或移除历史产物；入口和相对路径仍以 D:/AMD/4_agent_plan3 为根，暂存/备份不参与运行。

## 思考边界修复（2026-10-25）

思考边界修复：修改model/framing.py并扩展tests/test_policy_http_chain.py；新增tests/test_think_framing.py。无新增生产模块、框架或旧入口；已有运行记录不改写，所有路径以D:/AMD/4_agent_plan3为根。

## 超时后端自然收尾（2026-10-25）

新增serve/backend_lifecycle.py（端点锁/持久化/状态轮询）、serve/request_state.py（服务端请求注册表）、scripts/run_batch.py（遵守退出3的逐题入口）、tests/test_backend_drain.py及docs/backend-drain-20261025.md。沿用现有Controller与factory，无新增框架或废弃链路。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](protocol-alignment-20261028.md)。

## Agent结构精简（2026-10-28）

实际入口为agent.cli → runtime.run.run_task → 唯一CandidateSearchRunner。消息合同在contracts/messages.py，worker边界在runtime/worker_boundary.py，证据收集在runtime/reporting.py。删除无消费者的五个数据类/VersionRegistry及roles深层转发包装，不保留旧导入别名；scheduler运行产物路径继续使用。当前目录与验收见 [结构精简](agent-structure-20261028.md)。

## Analyst 实施建议合同（2026-10-29）

Analyst只输出implementation_notes和ambiguities，重分析额外输出reassessment。移除risk/derivations/模型task_profile/unresolved_questions以及派生profile_proposal_audit等旧字段和无用校验函数。derived_spec升级3.0，引用来源核验不代表语义正确，所有例子均未验证；结构错误回退，坏引用逐条剔除审计。首次调用条件和资源准入不变。

复用contracts/schemas.py、core/task_facts.py、output_protocol.py、prompts.py、stage_context.py与唯一Controller，无新增Agent/框架/生产目录。tests/test_analyst.py及两种模式的实际CLI/HTTP链检查非空建议传递、坏引用隔离、重分析源码绑定与后续生成。详见[当前合同与验收](analyst-contract-20261029.md)。

## Reviewer 针对性诊断（2026-10-29）

Reviewer输入绑定失败候选、revision_id/source_hash和对应安全反馈；输出issues（最多4）与limitations（最多3），删除risk/required_checks，observed_behavior替换为predicted_behavior。来源/行号/代码片段错误逐条拒绝，合法意见仅标未验证；Repairer检查绑定一致后接收。审查最多一次，无协议重试；空结果不等于通过，最终仍由原有预检和EDA验证。

删除execute_review_checks及其验证队列携带/重复产物路径，现有真实预检保留。复用原schemas/prompts/task_facts/stage_context/output_protocol与唯一Controller，不新增生产模块或Agent框架。合同、路径和验收见[Reviewer改造](reviewer-contract-20261029.md)。
