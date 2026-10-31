# 有界候选流水线与任务事实

更新时间：2026-10-30。当前工程：`D:/AMD/4_agent_plan3`。执行版本：`bounded_pipeline_resource_v2`。本文为唯一详细架构。

## 实际入口与执行图

```text
run.ps1 / run.sh / run_closed_loop.ps1
 → agent.cli → runtime.run.run_task → CandidateSearchRunner（唯一Controller）
 → task_facts冻结 → 来源派生/按配置分析 → 资源与时间准入、兼容策略
 → 事件循环：模型槽1 + 验证槽1 + 待验证缓冲位1
     模型：StageContext → _model_job → _generate_stage → execute_call → HTTP
     验证：不可变Revision → 唯一预检 → 既有EDA适配器 → 安全反馈
 → 成功锁定 → 停止派发 → 当前生成自然结束 → 完整消耗/报告
```

workers模式在execute_call和EDA外增加版本化消息/子进程边界；Controller完全相同，不代表多模型并发。WorkerBoundary通过锁分配消息编号。验证与模型分别携带自己的事实绑定，不再读写共享stage_binding。

旧“先生成所有候选→审查全部→排序→验证”的主循环已删除，不作为后备模式存在。没有新增顶层调度框架、数据库、外部依赖或角色加载器。

## 三类工作与不变量

- 待验证：不可变Revision（candidate_id、repair_index、source、source_path、derived、source_hash）。FIFO送入验证槽。
- 待处理反馈：绑定Revision和安全反馈；不会修改当前模型请求。
- 待生成：Controller在模型空闲时选择独立生成、修复/按需审查或最后的重建；不预先生成一长串任务。

同一时刻最多一个模型请求、一个验证任务和一个已生成但尚未验证的版本。缓冲满时不派发新模型任务。模型调用期间到达的反馈排队，当前调用结束后重新决策。

验证结束优先于模型结束被处理；通过结果锁定实际被验证的source_path/hash，不会被后到的生成/修复输出覆盖。所有源码版本独立落盘；修复反馈不能错配给其他候选。

## 资源准入与后续决策

关键词风险路由已删除，core/risk.py不再存在。单一纯函数core/search_policy.py:speculation_admission只判断资源与时间，不运行模型/EDA，不另建Controller。policy_version=resource_time_admission_v3。action_cost统一最小调用成本，耗时缓存仅保存隔离后的数值观测。

A进入验证后，模型槽空闲、缓冲为空、无待处理反馈时，检查speculation.enabled、兼容策略、候选名额、剩余模型/验证预算和派发时限。failure_reserve_calls只允许1或2，默认2。启动B需要1+failure_reserve_calls次剩余请求；空闲验证名额至少2个，分别用于B及一份后续修复，不含当前在验和待验版本。

预留是全题一套后续处理机会，不是每个候选各一套。B每次实际请求及协议重试都受reserve_calls保护；不能先准入再用纠错重试花掉保留调用。反馈到达后按证据选择动作，历史题序和类别数量不控制当前预算；Analyst与Reviewer均不再输出risk；资源准入不读取模型风险等级。

默认timing_mode=observed：同模型/端点/EDA配置及Controller源码的生成、验证耗时各至少两条时，以窗口最大值×1.25估计重叠；样本不足等反馈。fixed_window显式使用配置窗口，feedback_first关闭提前生成。completion_estimate=heuristic_not_guaranteed，不承诺软deadline前完成。speculation_allowed/speculation_denied记录实际准入原因、预算和保留数；相同连续判断不反复写入。

模型空闲、缓冲为空时按顺序选择：

1. 明确定位的工具错误或实际输入输出不一致：优先直接修复；单点观测不宣称时序可重放。
2. 修复后仍为无定位功能失败、普通策略耗尽且资源允许：可以优先重建。
3. 笼统功能失败且有剩余独立策略：生成另一个普通候选。
4. 无定位反馈按需Reviewer＋Repairer；预算不足两次时只能选择直接修复。修复或重建验证期间，暂缓缺少定位的旧候选修复，等结果再花调用。
5. 其他候选和修复工作耗尽后，仍可在名额、调用和验证预算允许时进行一次重建。

反馈阶段名本身不能证明可直接修复。工具不支持、未完成预处理和接口未知交给权威EDA。Reviewer建议是advisory；安全轨迹只从授权投影接收，公开辅助样例必须实际执行且不能覆盖权威通过状态。

## 预算与停止

每次实际模型请求发送前计数；协议重试和失败同样计数。默认after_failure先生成A；显式before_generation的初始分析为首份代码预留一次调用；分析失败回退来源派生。max_model_calls=1时直接生成，不发分析请求。

Reviewer→Repairer是两次调用；Rebuild→Synthesizer在分析启用时两次、disabled时仅生成一次。启动前预留完整最小调用数和一个验证位置；前半段分析/审查均不做协议重试；保留后半段最后一次代码调用。通过后stop信号会阻止任何尚未开始的后半段或重试。

max_candidates包含重建新根候选，不包含同一候选修复版本。具体错误优先修复；同一候选修复后仍仅有汇总功能失败时，重建可优先于另一轮模糊审查。新derived.v2不改变旧版本。重建需要完整调用预算和验证位置：启用分析为两次，disabled 为一次，不产生“只分析无代码”的预算尾巴。

验证位置预留考虑实际EDA调用数、在验和待验代码。预检阻断不虚增Vivado调用。max_eda_seconds及max_wall_clock_seconds是派发门限：进行中的请求自然结束，因此不是强杀式硬deadline。

成功立即写solution_ready.json、停止派发并丢弃排队工作。模型当前请求自然结束：保留原始响应/消耗，产物记discarded_after_stop，不再送验。CLI等待收尾后返回；solution_ready_seconds与含收尾的wall_clock_seconds分别记录，drain_seconds不隐藏。

客户端超时不证明远端已停，禁止本运行后续请求，并由HTTP客户端按持久化request_id等待匹配终态且服务空闲。确认结束后保留本题超时结论再返回；无法确认则记录drain_status=backend_state_unknown、退出3并阻止批次继续，下一运行也必须经过同一pending屏障。服务端取消接口未实现，不发送取消，不杀共享模型服务。

环境失败停止派发，不请求RTL修复。派发停止后若已有验证仍在运行，会自然结束；其权威通过证据仍可形成成功结果。

## 四类数据与权威

| 产物 | 内容与约束 |
|---|---|
| task_facts.json | 完整公开原题、来源哈希、接口/范围和行索引；冻结，不原地改写 |
| derived_spec.vN.json | schema 3.0：implementation_notes、ambiguities、reassessment、逐条拒绝审计、程序task_profile；每个候选独立绑定 |
| handoffs/*.json | 角色白名单增量及事实/派生引用；不复制全量原题或其他候选历史 |
| 验证与调用记录 | 实际观测、预算、耗时和原始审计；不授权更改题意 |

原题与接口 > 来源核验派生 > Reviewer、模板和记忆。哈希证明完整性，不证明解析或推理正确。接口/任务特征是有界英文模式匹配，unknown/conflict不注入强制语义。source_check只证明引文匹配，模型语义与例子统一unverified；旧verified/hypotheses字段已删除。

每阶段StageContext重新读取事实，注入真实内容；Repairer始终读原题、本版本源码、对应安全反馈。Synthesizer候选互不读取代码与失败历史。Reviewer读取当前候选、程序版本/哈希绑定、对应安全验证反馈、原题和辅助检查。坏引用、代码定位或冲突范围的条目被单独拒绝；合法意见仍为未验证假设，进入Repairer时再次核对版本绑定。来源检查不证明反例真实。

task_profile→applicable_checks/candidate_plan→StageContext→实际HTTP链保持。*.checks.json记录enabled/skipped及原因；提示检查不是已执行测试。Reviewer检查申请路径已删除；接口/组合范围与语法预检直接由程序执行，不依赖模型提出请求。

## 预检、去重与安全反馈

只有core/static_checks.py一套预检：调用可用Icarus/Verilator、结构检查、公开接口和范围检查，再进入既有EDA。无独立前端时记not_executed，不伪造parser通过。有限ANSI/参数化支持不等于完整SV解析。

源码SHA-256用于本次运行精确去重；不变修复和重复候选不重复验证，不宣称识别语义等价。删除validation_cache.py及跨运行缓存路径，避免不完整工具/TB/XDC指纹复用错误证据。

project_safe_feedback保持验证器安全投影；TB/reference/XDC/原始私有日志不进入模型。failure_evidence保留分析观测，Repairer使用合同受限的safe_feedback。历史记忆默认关闭，启用时只传最多3条脱敏错误摘要，不声称已形成成功修复知识库。

## 输出协议及执行证据

代码角色和baseline固定8912；分析/审查统一8912。RTL_CODE/answer严格独占行边界；schemas.py为唯一合同源。execute_call供进程内和worker共用；LLM消息2.0，EDA1.0；报告直接函数调用。

原始think只在call_NN/audit中保存，不向下游传递。协议重试附带具体校验错误，仍走同一事实上下文和预算。失败消耗未知为null，不填零。

pipeline_events.jsonl追加记录实际派发/完成/反馈/丢弃，结束时导出pipeline_events.json；search_state记录槽位与预留；solution_ready绑定通过版本。final带pipeline_version、policy_version、source_hash、solution_ready_seconds、drain_seconds、max_pending_validation和所有调用消耗。runtime.reporting.collect_evidence收集这些产物。

验收：tests/test_pipeline.py在真实CLI、实际HTTP和独立验证子进程间设置双向等待，验证A验证时B生成，A反馈在B期间排队、修复仍绑定A，通过后模型自然返回且不重试。两种execution_mode均覆盖。tests/test_policy_http_chain.py进一步覆盖按需审查、修复、最后重建及派生隔离；tests/test_output_protocol.py覆盖边界/预算/失败审计。

这些是受控替身的真实调用链测试，不是大模型推理或真实Vivado运行。真实正确率、资源竞争、吞吐与墙钟收益须用新的同批配对实验确认。历史runs/reports/logs不改写。

恢复只重建已有证据和通过的实际修复路径，不自动恢复模型/EDA任务；通过后收尾中断时仍能从不可变验证证据恢复结果。

当前资源策略验收见[2026-10-25记录](resource-admission-verification-20261025.md)；2026-10-23流水线记录保留为历史证据。

## 内部合同与失败收尾（2026-10-25）

修复生产端，不放宽 schemas.py：来源引用保序去重，所有范围冲突合并后再派生 clocked/component，profile_for 与 StageContext 共用语义检查。事实形成时即自检，避免把程序产生的非法数据误记成模型失败。

验证原始输出保持完整；进入模型的 warnings 受合同限制并保留投影计数。execute_call 将空异常规范为合法失败信封，原始异常留在审计目录。初始化期间异常由本 Controller 形成失败 final/manifest/调用统计，并交给现有 runtime.reporting.collect_evidence；存储本身不可写时不能承诺落盘。

未新增路由器、框架或运行路径。实际模型入口继续经 StageContext → execute_call → HTTP；两种执行模式共用该实现。验收见[内部合同修复记录](internal-contract-verification-20261025.md)。

## 思考边界修复（2026-10-25）

思考边界：前导think不再作嵌套XML解析，引用标签作为正文；候选结束标签仅在其后为完整最终区域时确认。model/framing.py仍是唯一最终区域边界实现，model/extraction.py与core/output_protocol.parse_json_answer共同消费，baseline复用RTL提取器。不改变唯一Controller、资源准入或worker边界。

## 超时后端自然收尾（2026-10-25）

执行链追加实际客户端屏障：execute_call → serve.factory/HttpModelClient → BackendLease（持久化request_id）→ HTTP；workers仍共用execute_call。超时先在客户端自然收尾，再由原Controller锁定停止原因并禁止新派发。pending跨进程保留；批次退出3即停。无新Agent、旧主循环或取消协议。详见 [后端收尾](backend-drain-20261025.md)。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](protocol-alignment-20261028.md)。

## Agent结构精简（2026-10-28）

实际入口为agent.cli → runtime.run.run_task → 唯一CandidateSearchRunner。消息合同在contracts/messages.py，worker边界在runtime/worker_boundary.py，证据收集在runtime/reporting.py。删除无消费者的五个数据类/VersionRegistry及roles深层转发包装，不保留旧导入别名；scheduler运行产物路径继续使用。当前目录与验收见 [结构精简](agent-structure-20261028.md)。

## Analyst 职责（2026-10-29）

首次分析仅在analysis.mode=before_generation且max_model_calls>1时最多一次，保留至少一次代码生成；失败不做协议重试，冻结原题与接口继续供生成使用。只产出影响实现的行为关系、边界/优先级、必要例子和实施相关歧义，允许空列表。结构错误整体回退，引用错误逐条剔除并审计。建议经StageContext按模型视图进入A生成/修复；B首次生成与Reviewer隐藏分析意见，不能改程序task_profile或作为强制测试。

最后重建使用独立指令与严格reassessment合同，包含绑定失败源码、版本、哈希、反馈与旧分析；后续生成收到next_attempt_change及证据限制。调度仍为唯一CandidateSearchRunner，资源准入不变。详见[Analyst合同与验收](analyst-contract-20261029.md)。

## Reviewer 针对性诊断（2026-10-29）

Reviewer输入绑定失败候选、revision_id/source_hash和对应安全反馈；输出issues（最多4）与limitations（最多3），删除risk/required_checks，observed_behavior替换为predicted_behavior。来源/行号/代码片段错误逐条拒绝，合法意见仅标未验证；Repairer检查绑定一致后接收。审查最多一次，无协议重试；空结果不等于通过，最终仍由原有预检和EDA验证。

删除execute_review_checks及其验证队列携带/重复产物路径，现有真实预检保留。复用原schemas/prompts/task_facts/stage_context/output_protocol与唯一Controller，不新增生产模块或Agent框架。合同、路径和验收见[Reviewer改造](reviewer-contract-20261029.md)。

## 2026-10-29 诊断与预检补充

本次四项确定性修复见 [修复范围与链路验收](agent-bugfixes-20261029.md)。共享文本预处理位于 `model/rtl_lex.py::mask_noncode`，由原有静态检查和接口范围检查复用；不增加 Controller、角色或目录。Repairer 检查列表仅作提醒。baseline、8912 输出上限、300 秒请求超时、资源准入与自然收尾保持不变。



## 搜索、证据与上下文更新（2026-10-29）

当前普通候选最多 A/B，第三候选名额用于一次失败重建；调用/验证预算不增加。未知画像有通用第二策略。诊断直达、Reviewer 隔离分析建议、重建证据直传、阶段输入裁剪与可选精确 token 预检，见 [当前行为与验收](search-evidence-context-20261029.md)。8912/300 秒与自然收尾不变，baseline 不变，无新增 Agent/目录。


当前三批修复见 [三批链路修复](three-batch-hardening-20261029.md)。第一批统一必要证据、候选反馈绑定、前端路径诊断和 Reviewer 单份源码视图。


三批修复现已覆盖：analysis.mode、B意见隔离、动作选择、反馈身份、必要错误保留、Reviewer单份源码、准确的重放状态，以及speculation.time_reserve和speculation_timings。当前默认after_failure；8912/300秒、自然收尾与baseline生成语义不变。


当前词法、候选推导及运行链路更新见 [三批实施说明](semantic-hardening-20261029.md)。共同词法位于model/rtl_lex.py，B修复继承意见隔离策略。


2026-10-30 当前边界修复与顺序验收见 [边界、证据与调度修复](boundary-evidence-hardening-20261030.md)。未知接口/预处理/前端能力限制交给权威验证；worker 异常统一确认后端状态。


2026-10-30 当前运行规则：默认 analysis.mode=after_failure；speculation.timing_mode=observed，耗时样本不足等待 A 反馈；远端 SiliconMind 配置启用身份核验后的准确 token 预检。动作预算记录放弃的调用机会，策略版本 resource_time_admission_v3。详见 [边界、证据与调度修复](boundary-evidence-hardening-20261030.md)。8912/300 秒与后端自然结束规则不变。


2026-10-30 当前词法、诊断完整性和运行身份规则见 [三批精确修复](precision-hardening-20261030.md)。转义标识符不当成结构关键字；diagnostic_coverage 明确说明安全 warning 省略/缩短；runtime_identity.json 绑定源码和脱敏有效配置，普通 worker 派发前核验。单 Controller、8912 token、300秒及自然收尾保持不变。
