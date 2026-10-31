# 文档索引

- [任务事实与增量交接架构](candidate-search-architecture.md)：唯一当前架构说明。
- [接口](interfaces.md)：公开题目、模型/worker、验证器和新内部产物。
- [文件清单](file_manifest.md)：当前实现路径。
- [本次迁移](task-facts-migration-20261023.md)：改造、清理和验证范围。
- [历史集成](integration.md)、[真实实验](real-model-experiment.md)、[备份恢复](backup-and-restore.md)。

固定结构保证解析、比较和恢复；动态内容与任务内冻结事实分开管理。历史报告保留当时事实，不用当前路径和新架构去覆盖。

- [历史流水线验收](pipeline-verification-20261023.md)：实际CLI/HTTP/验证子进程的重叠、反馈版本和自然收尾证据。

- [当前资源准入验收](resource-admission-verification-20261025.md)：资源条件真实控制CLI/HTTP派发的验证与安装记录。

## 超时后端自然收尾（2026-10-25）

当前超时后端自然收尾、跨进程恢复、批次投递屏障与部署限制见 [backend-drain-20261025.md](backend-drain-20261025.md)。

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
