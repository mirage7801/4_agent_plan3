# AMD RTL Agent — plan3

2026-10-29：[Agent 四项确定性修复](docs/agent-bugfixes-20261029.md)：修正分类误匹配、未初始化分类优先级、字符串结构误判与 Repairer 检查范围指令；baseline 不变。

当前工程：`D:/AMD/4_agent_plan3`。执行版本：`bounded_pipeline_resource_v2`。

单模型生成 RTL，使用既有 Vivado 验证器完成编译、仿真、综合。当前 Controller 已替换为有界流水线：一个模型执行槽、一个验证执行槽、一个待验证缓冲位。模型调用之间串行，验证调用之间串行；模型与验证可以重叠。不存在可切回旧串行搜索器的配置。

```text
公开原题 → 冻结 task_facts → 来源派生/按需分析 → 兼容策略、资源与时间准入
                           ↓
模型槽：生成 A → 生成 B → 根据 A 的反馈修复 A1 → …
验证槽：         验证 A → 验证 B → 验证 A1 → …
                           ↓
通过：锁定通过的源码 → 停止派发 → 当前生成自然结束 → 最终统计
```

删除关键词风险路由。A验证期间，提前生成B须有兼容策略、候选名额、B自身及失败处理的模型预算，并留出B和后续修复两次验证机会（不含当前在验A）。默认保留两次模型调用；资源不足或耗时样本不足则等反馈。反馈绑定候选版本与源码 SHA-256，不会注入正在生成 B 的请求。明确结构错误/实际输入输出反例优先修复，单点反例不等于时序可重放；笼统功能失败优先尝试剩余独立候选，之后按需审查和修复。

## 运行

```powershell
Set-Location D:/AMD/4_agent_plan3
python scripts/preflight.py --problem tests/fixtures/mock_counter --config config/mock.e2e.json --output runs --json
python -m agent.cli run --problem tests/fixtures/mock_counter --config config/mock.e2e.json --output runs --run-id pipeline-smoke
python -m unittest discover -s tests -v
```

真实服务使用 `config/experiment.example.json` 或当前 `*.local.json`。运行前核对模型 health 的 ID/revision、8912 输出能力、上下文及验证器资产。相对路径以配置文件目录展开。示例历史 revision 不是当前服务证明。

baseline：`python -m baseline.cli run --problem <task> --config <真实配置> --output runs`。baseline 仍为同模型/生成配置的单次直接生成；其提示与 Agent 阶段提示不同，不把端到端差异直接归因为角色数量。`mock.e2e.json` 是 Agent 的分析→代码→修复响应序列，不能直接供 baseline 使用。

## 成功与自然结束

验证通过时立即保存 `solution_ready.json` 并停止派发。后端暂不实现取消；已有模型调用自然返回，其输出保留审计但不再进入验证队列。CLI 等待该调用结束后返回，确保正常返回时当前请求已收尾。`solution_ready_seconds` 是成功证据就绪时间，`wall_clock_seconds` 包含收尾时间，不能混报。

客户端超时不代表服务器停止计算：客户端停止本题新派发并按请求编号等待后端自然结束；确认终态且空闲才允许下一题，无法确认则记录 `drain_status=backend_state_unknown` 并退出3。调度总时限是停止派发的软上限，进行中的模型/EDA 不被强杀。

## 产物及预期链路

```text
<run>/task_facts.json
<run>/derived_spec.vN.json
<run>/handoffs/*.json
<run>/context/{search_policy,candidate_strategy_selection,shared_context}.json
<run>/candidates/candidate_*/{generation,repair_NN,precheck_NN,validation_NN}/…
<run>/pipeline_events.jsonl     # 追加事件，结束时导出pipeline_events.json
<run>/lifecycle_timing.json     # Runner、清单、报告与CLI main范围计时
<run>/search_state.json         # 两个执行槽、队列、验证预留快照
<run>/solution_ready.json       # 通过的不可变源码、哈希和事实版本
<run>/model_calls.json          # 包含失败和丢弃输出的实际请求消耗
<run>/candidate_search/final.json
<run>/report/evidence_manifest.json
```

实际入口：`run.ps1/run.sh/run_closed_loop.ps1 → agent.cli → runtime.run.run_task → CandidateSearchRunner(bounded_pipeline_resource_v2) → StageContext → execute_call → HTTP`。workers 模式仅增加消息/子进程边界，仍执行同一个 Controller 与输出处理器。CLI、预检和运行记录都显示 pipeline_version；运行证明必须同时检查事件与实际 HTTP 请求，而非只看标记。

链路验收：`python -m unittest tests.test_pipeline tests.test_policy_http_chain tests.test_output_protocol -v`。`test_pipeline` 使用实际 CLI、HTTP 和独立验证子进程进行双向等待：串行旧链路无法通过；覆盖两种执行模式、失败反馈版本绑定、通过后自然结束及禁止协议重试。可通过 `PROTOCOL_EVIDENCE_ROOT` 保存合成证据。

## 边界与说明

原题与接口 > 来源核验派生 > Reviewer/模板/记忆。每阶段重新加载事实；修复含原题。TB/reference/XDC/原始私有验证日志只进入验证器。代码8912、分析统一8912；严格 RTL_CODE/answer 输出区域，think 仅保留在审计。

`max_candidates` 包含重建新分支；重建仅在其他可用工作耗尽、至少剩余两次模型调用且预留验证位置时启动。当前已删除不完整的跨运行验证缓存，仅在本次运行按源码哈希去重。历史记忆默认关闭。

详细说明：[当前架构](docs/candidate-search-architecture.md)、[接口](docs/interfaces.md)、[配置](config/README.md)、[文件清单](docs/file_manifest.md)、[迁移记录](docs/task-facts-migration-20261023.md)、[流水线验收](docs/pipeline-verification-20261023.md)。

本次受控测试不代表真实模型/Vivado 正确率或墙钟提升。历史 reports/runs/logs 不重写、不换路径、不计为当前架构成绩。

## 资源准入更新（2026-10-25）

`speculation.enabled=true`、`failure_reserve_calls=2`为默认值；保留1次时剩余2次请求可生成B，保留2次时至少剩余3次。协议重试不能侵占预留。Analyst与Reviewer均不再输出`risk`；新运行不产生risk_assessment.json。运行预算逐题独立。

链路说明与复验：[资源准入验收](docs/resource-admission-verification-20261025.md)。当前入口和配置相对路径仍以本工程为根，不使用安装暂存目录。

## 内部合同修复（2026-10-25）

修复程序自身生成的重复来源引用、范围冲突后的过期时序特征、超量反馈警告与空异常消息。保持严格合同，不放宽校验；初始化失败也形成最终失败记录。入口、资源准入配置和唯一 Controller 不变。详情见[内部合同验收](docs/internal-contract-verification-20261025.md)。

2026-10-25：所有模型阶段与baseline的单次输出上限统一8912 token，全部当前配置的模型请求超时统一300秒。Qwen参考服务源码已同步8912；已运行的远端服务需要部署对应版本才能更新服务端限制。历史运行与验收证据保留原值。

## 思考边界修复（2026-10-25）

前导思考区解析已修复：正文引用`<think>`不再触发嵌套计数；候选`</think>`必须与紧随其后的完整最终区域共同确认。实际CLI/HTTP回归覆盖两种Agent执行模式与baseline；统一解析器仍为model/framing.py，未新增执行链。

## 超时后端自然收尾（2026-10-25）

单次生成超时仍为300秒；超时后按 request_id 等待 GPU 自然结束，最长独立收尾120秒。状态未知退出3并阻止下一题；迟到答案不用。Agent两种模式与baseline共用实际HTTP屏障，正常响应不额外轮询。串行批次入口 `scripts/run_batch.py`；部署与配置详见 [后端收尾](docs/backend-drain-20261025.md)。参考服务必须同步部署状态接口，本次代码修改不代表远端已更新。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](docs/protocol-alignment-20261028.md)。

## Agent结构精简（2026-10-28）

实际入口为agent.cli → runtime.run.run_task → 唯一CandidateSearchRunner。消息合同在contracts/messages.py，worker边界在runtime/worker_boundary.py，证据收集在runtime/reporting.py。删除无消费者的五个数据类/VersionRegistry及roles深层转发包装，不保留旧导入别名；scheduler运行产物路径继续使用。当前目录与验收见 [结构精简](docs/agent-structure-20261028.md)。

## Analyst 实施建议合同（2026-10-29）

Analyst只输出implementation_notes和ambiguities，重分析额外输出reassessment。移除risk/derivations/模型task_profile/unresolved_questions以及派生profile_proposal_audit等旧字段和无用校验函数。derived_spec升级3.0，引用来源核验不代表语义正确，所有例子均未验证；结构错误回退，坏引用逐条剔除审计。首次调用条件和资源准入不变。

复用contracts/schemas.py、core/task_facts.py、output_protocol.py、prompts.py、stage_context.py与唯一Controller，无新增Agent/框架/生产目录。tests/test_analyst.py及两种模式的实际CLI/HTTP链检查非空建议传递、坏引用隔离、重分析源码绑定与后续生成。详见[当前合同与验收](docs/analyst-contract-20261029.md)。

## Reviewer 针对性诊断（2026-10-29）

Reviewer输入绑定失败候选、revision_id/source_hash和对应安全反馈；输出issues（最多4）与limitations（最多3），删除risk/required_checks，observed_behavior替换为predicted_behavior。来源/行号/代码片段错误逐条拒绝，合法意见仅标未验证；Repairer检查绑定一致后接收。审查最多一次，无协议重试；空结果不等于通过，最终仍由原有预检和EDA验证。

删除execute_review_checks及其验证队列携带/重复产物路径，现有真实预检保留。复用原schemas/prompts/task_facts/stage_context/output_protocol与唯一Controller，不新增生产模块或Agent框架。合同、路径和验收见[Reviewer改造](docs/reviewer-contract-20261029.md)。


## 搜索、证据与上下文更新（2026-10-29）

当前普通候选最多 A/B，第三候选名额用于一次失败重建；调用/验证预算不增加。未知画像有通用第二策略。诊断直达、Reviewer 隔离分析建议、重建证据直传、阶段输入裁剪与可选精确 token 预检，见 [当前行为与验收](docs/search-evidence-context-20261029.md)。8912/300 秒与自然收尾不变，baseline 不变，无新增 Agent/目录。


当前三批修复见 [三批链路修复](docs/three-batch-hardening-20261029.md)。第一批统一必要证据、候选反馈绑定、前端路径诊断和 Reviewer 单份源码视图。


三批修复现已覆盖：analysis.mode、B意见隔离、动作选择、反馈身份、必要错误保留、Reviewer单份源码、准确的重放状态，以及speculation.time_reserve和speculation_timings。当前默认after_failure；8912/300秒、自然收尾与baseline生成语义不变。


当前词法、候选推导及运行链路更新见 [三批实施说明](docs/semantic-hardening-20261029.md)。共同词法位于model/rtl_lex.py，B修复继承意见隔离策略。


2026-10-30 当前边界修复与顺序验收见 [边界、证据与调度修复](docs/boundary-evidence-hardening-20261030.md)。未知接口/预处理/前端能力限制交给权威验证；worker 异常统一确认后端状态。


2026-10-30 当前运行规则：默认 analysis.mode=after_failure；speculation.timing_mode=observed，耗时样本不足等待 A 反馈；远端 SiliconMind 配置启用身份核验后的准确 token 预检。动作预算记录放弃的调用机会，策略版本 resource_time_admission_v3。详见 [边界、证据与调度修复](docs/boundary-evidence-hardening-20261030.md)。8912/300 秒与后端自然结束规则不变。


2026-10-30 当前词法、诊断完整性和运行身份规则见 [三批精确修复](docs/precision-hardening-20261030.md)。转义标识符不当成结构关键字；diagnostic_coverage 明确说明安全 warning 省略/缩短；runtime_identity.json 绑定源码和脱敏有效配置，普通 worker 派发前核验。单 Controller、8912 token、300秒及自然收尾保持不变。
