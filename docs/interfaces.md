# Interfaces

状态：队友三编排层 v1，外部验证器 schema 1.0 保持只读。

## 权威来源

编排器不复制或修改验证标准。以下文件由 `eda.validator_root` 指向的队友一仓库提供：

- `interfaces/task.schema.json`
- `interfaces/result.schema.json`
- `interfaces/validation_contract.md`
- `tools/validate_rtl.py`
- `tools/feedback_policy.py`

发现冲突时记录并停止联调，不单方面改变公共 schema。

## 模型服务

Python 语义：

```text
generate(prompt, max_tokens, temperature) -> ModelResponse
```

`ModelResponse` 保存 `text`、`model_id`、`revision`、耗时、原始响应、标准/原始结束原因及实际 token 消耗。`MockModelClient` 支持顺序文本、空响应、显式错误和超时。`HttpModelClient` 默认向本地 URL 发送通用 JSON：

```json
{
  "model": "configured-id",
  "revision": "configured-revision",
  "prompt": "...",
  "max_tokens": 8912,
  "temperature": 0.2
}
```

响应文本字段由 `model.response_text_field` 配置，默认 `text`。失败必须显式返回/抛错，不会回退到在线服务。

## EDA CLI

编排器以独立子进程调用：

```text
python tools/validate_rtl.py
  --source <immutable candidate>
  --testbench <private testbench>
  --top <public top>
  --part <configured part>
  --clock-period <configured period>
  --output-dir <attempt validation dir>
  [--constraints <private xdc>]
  [stage timeout flags]
```

适配器要求 stdout 为单个 JSON 对象，并从其实际 `output_dir` 读取磁盘 `result.json`。`schema_version`、通过状态、阶段、错误、摘要、输入、器件、时钟、Vivado 版本和实际输出目录必须一致。

- 退出码 0：全部通过；
- 退出码 1：候选 RTL 失败，可在安全反馈允许时修复；
- 退出码 2：环境/参数/工具链失败，立即停止，不生成 RTL 修复提示。

完整 `result.json` 和验证器日志目录原样保留。编排器不读取原始 Vivado 日志重新判定。

## 安全反馈

优先调用 `tools.feedback_policy.team_two_feedback(result)`。送入模型的结构仅允许：

```json
{
  "stage": "compile",
  "error_type": "syntax_error",
  "summary": "bounded safe summary",
  "warnings": [],
  "candidate_feedback_allowed": true
}
```

消费外部投影后还会硬化任意 XDC、私有 testbench、`reference.v` 和 `faults/` 路径。环境失败必须为 `candidate_feedback_allowed=false`。

## 公开题目

模型和运行快照只接收 `task.txt` 与 `task.json` 中公开的描述、语言、顶层模块、预期源文件名、器件、时钟和超时元数据。`testbench`、`constraints` 只用于 EDA 调用，不写入公开题目快照或提示词；其内容、参考实现和 faults 永不进入模型上下文。

## CLI 和退出码

```text
python -m agent.cli run --problem P --config C --output O
python -m baseline.cli run --problem P --config C --output O
```

成功返回 0；候选/模型失败返回 1；参数、配置、存储或环境失败返回 2。输出根目录始终创建唯一子目录，`--run-id` 发生冲突时增加后缀，不覆盖历史。

## Worker 文件契约

`agent.worker_cli` 使用版本化 JSON envelope。模型 `llm-generate` 请求和响应升级为 **2.0**；`vivado-validate` 及外部验证器 task/result 保持 **1.0**，不修改私有资产。

LLM 请求固定包含 schema_version/message_type/task_id/run_id/payload；payload 严格包含 prompt、top_module、output_dir、response_kind（rtl/analyst/reviewer）、source_name、request_id、max_tokens、context_binding，可选 mock_response_index。绑定包括 facts_path/facts_ref/facts_version/derived_ref。原始文件位于 scheduler/messages/，不会覆盖旧运行。

响应采用成功/失败共用的闭合合同，具体类型与限制统一定义在 `agent/contracts/schemas.py` 的 CALL/LLM_PAYLOAD。包含身份绑定、status、stage、error、generation、usage、rtl_status、原始审计文件和正式产物引用。失败时 source_file/answer_file 可以为空；未知 token 是 null，不是 0。成功状态必须存在对应产物，失败必须有结构化错误。worker 提取失败写信封正常退出；控制器优先读取信封，进程异常且没有信封时补 WORKER_CRASH，尝试恢复解析前已落盘的消耗。错误身份/绑定/产物越界产生基础设施失败，不信任错误响应的消耗。


## 运行记录

顶层保存 `config.snapshot.json`、`public_problem.snapshot.json`、`run_manifest.json` 和 `summary.json`。模式目录保存不可覆盖的 `attempt_NN/` 和 `final.json`。所有 JSON 采用 schema/version 字段并可由 `report.summary` 重新统计。


## plan3 内部任务事实与交接（2026-10-23）

以下是编排层内部扩展，不改变外部 task/result schema 1.0。

- task_facts.json：schema_version=2.0，source(raw_text/sha256/task_version)、interface(module/language/ports/ports_status)、scope、requirements源行索引、explicit_tables/explicit_examples引用、unresolved_questions、verification、facts_version和facts_id。不能存私有资产或模型身份/器件等运行配置。
- derived_spec.vN.json：schema_version=3.0，facts_ref、derived_version、implementation_notes、ambiguities、reassessment、rejected、task_profile。source_check仅证明引用来源，所有模型建议/例子semantic_status=unverified；不再产生verified/hypotheses/risk等旧字段。
- handoffs/*.json：schema_version=2.0、stage、facts_ref、facts_version、derived_ref、delta。delta按角色白名单筛选；不得包含原题、端口/需求全量副本或私有资产。
- context/shared_context.json仅保存程序元数据和产物引用，不复制完整规格、候选代码和验证反馈。
- llm-generate/vivado-validate payload可附加context_binding，包含facts_path、facts_ref、facts_version、derived_ref；worker执行前核对事实哈希，响应原样回显，调度器核对一致。facts_path只供程序使用，不进入模型上下文。旧调用不附加此字段时保持兼容。
- candidate generation/repair/attempt记录保存事实和派生绑定；重建仅创建新派生版本。事实纠错必须新建版本，不由Reviewer或Repairer原地改写。

实现与限制见 [架构](candidate-search-architecture.md)。验证反馈是观测证据；优先级只约束规格/建议，不把测试失败当作更改题意的授权。


## 条件规则内部扩展

- derived_spec.task_profile包含implementation_scope/requested_component/functional_family、clocking、reset和features；特征value/status/requirement_refs的status为source_checked/unknown/not_applicable/conflict。来源模式核验不代表形式证明。
- task_profile仅由程序独立提取。Analyst不输出task_profile，profile_proposal_audit及其无消费者校验函数已删除。
- STAGE_DELTA以applicable_checks替换旧task_rules，每项为check_id/requirement_refs/instruction。prompt同名*.checks.json保存enabled/skipped及原因，明确不是已执行检查。
- context/candidate_strategy_selection.json和重建候选strategy_selection.json记录兼容策略及拒绝原因；generation.json保存实际strategy_id。
- orchestration.roles已移除；实际角色由Controller显式调度。HTTP extra_request_fields不得覆盖prompt/model/revision/max_tokens/temperature。

以上只扩展内部产物，不改变外部验证器task/result schema及worker消息类型。

## 模型输出协议（2026-10-23第三阶段）

唯一执行入口为 `agent/core/output_protocol.py:execute_call`。进程内直接调用，worker 中也调用同一函数；不保留旧全文兜底路径。

| 输出角色 | 区域 | 必需内容 |
|---|---|---|
| Analyst | `<answer>` 与 `</answer>` | implementation_notes、ambiguities |
| Rebuild 分析 | `<answer>` 与 `</answer>` | implementation_notes、ambiguities、reassessment |
| Reviewer | `<answer>` 与 `</answer>` | issues（最多4条）、limitations（最多3条） |
| Synthesizer / Repairer / 重建后生成 | `<RTL_CODE>` 与 `</RTL_CODE>`，可有一层完整独占行 `<answer>` 包装 | 一个完整的指定顶层模块；没有解释 |

所有区域起止标签独占一行，恰好一组，无 Markdown 围栏；除可剥离的前导 think 段（边界确认规则见下文）外不得有外围文本。不配置服务端 stop 字符串。未闭合 think、重复或缺失标签、空内容均失败。`model/framing.py` 定位最终区域；`model/extraction.py` 只在该区域定位合法声明，移除旧 fenced/unfenced/正文 module 兜底。不能补 endmodule。字符串/注释中的 think 不会被全局删除。

`agent/contracts/schemas.py` 是单一合同源：模型输出、task_facts、derived_spec、角色 handoff、LLM 消息的嵌套类型全部闭合。内置验证器只实现这些合同使用的 JSON Schema 子集，不宣称支持任意第三方 JSON Schema；测试检查定义没有使用未实现关键字。无新增第三方依赖。解码拒绝重复键、非有限数字与指数溢出；拒绝类型转换与未知字段；Analyst结构严格，引用内容错误按条拒绝并记录审计，不是静默丢弃。角色提示词从相同 schema 生成 OUTPUT_SCHEMA。

每条implementation_note包含statement/requirement_refs/source_quote/basis（explicit|inferred），可选example（given/expected）；ambiguity包含question/implementation_impact/requirement_refs/source_quote。引用编号不存在或引文不匹配仅拒绝相应条目；结构错误拒绝整个响应。source_check标记exact_source_match或source_match_whitespace_normalized，均不证明statement或example成立。Reviewer issue包含id、requirement_refs、source_quote、candidate_location（start_line/end_line，1-based闭区间）、candidate_excerpt、trigger_condition、expected_behavior、predicted_behavior、reasoning。source_quote复用连续原文空白匹配；candidate_excerpt仅统一换行符，必须精确出现在指定行范围内。引用、行号、片段或重复ID错误逐条拒绝审计，不丢弃其他合法条目；结构错误仍拒绝整体。通过来源与定位检查不证明诊断正确。程序专属哈希、source_check、semantic_status、耗时等不能由模型填写。

Reviewer的required_checks、risk及重复execute_review_checks路径已删除，新运行不产生review_checks.json。既有接口/范围、语法预检和EDA照常执行，不需要模型申请；applicable_checks只作辅助提示，不限制源规格审查范围。

代码调用和 baseline 的 model.max_tokens 固定为8912；所有角色统一使用同一8912上限；agent.analysis_max_tokens仅保留配置兼容且必须等于model.max_tokens。agent.protocol_retries 默认1，代码至多重试一次格式/schema错误；Analyst与重建分析不重试协议，失败使用冻结事实派生；Reviewer不重试，失败记unavailable并保留修复调用。baseline保持单次不重试。实际每次请求均计入 max_model_calls。输入不得被静默截断；上下文配置必须大于8912并与服务一致。本仓库 Qwen 服务使用实际 tokenizer 对聊天模板后的输入计数，超限拒绝，默认 context 为32768并核对模型位置上限。外部服务仍须核实实际限制；配置数值不是后端能力证明。

标准 finish_reason：eos/stop_sequence/length/timeout/cancelled/error/unknown，另存 provider_finish_reason。通用 stop 无法区分 EOS/停止串时记 unknown；不按文本长度猜截断。usage 含 input_tokens/output_tokens/reasoning_tokens/requested_max_tokens，服务没有提供则 null。finish_reason 与 status/rtl_status 分开；length 不自动否定完整代码，eos 不使缺标签变合法。rtl_status=complete 表示输出区域与模块边界完整，不表示语法或功能通过。

每次请求目录为 `<stage_response>/call_NN/`：

```text
call_NN/
  audit/raw_response.txt    # 服务返回文本，允许含 think，只供本地排错
  audit/raw_payload.json    # 服务实际响应，允许含独立 reasoning 字段
  audit/call_metadata.json # 解析前先记消耗，完成后更新状态
  answer.json             # 仅成功的结构化最终答案，或
  <source_name>           # 仅成功提取的 RTL
```

不另建 think 文件，不展示思考，不读取未返回的内部思考。所有下游输入经 StageContext 白名单组装，不扫描审计目录。根 model_calls.json 和 final.model_calls 只保存信封与引用，final.model_usage 分别统计已报告消耗与未报告调用数，避免用部分已知总和冒充全部消耗。

RTL 正式候选保存后，预检调用可用的 Icarus/Verilator 前端，记录命令结果到 syntax_check.json 与本地 syntax.log；然后核对接口/范围，最后进入既有 EDA 验证。未安装独立解析器时明确 not_executed，由配置的真实 EDA 编译阶段完成解析。Mock 验证不是语法/功能通过证据。真实编译前端未在当前机器验证可用，不能用正则计数冒充 parser。


## 有界流水线执行与观测（2026-10-23第四阶段）

唯一Controller为agent/orchestration/candidate_search.py，pipeline_version=bounded_pipeline_resource_v2；workers和in_process均走此路径。旧全量生成/审查/排序循环已替换。模型与EDA各一个执行槽，已生成待验证的缓冲容量固定1；模型请求与EDA请求可以同时存在，不能依赖共享stage_binding。

每个Revision绑定candidate_id、repair_index、source_path、source_hash和事实/派生版本。validation_NN/search_binding.json记录对应哈希；feedback在Controller队列中保留父版本。repair_NN/repair.json含parent_revision/parent_source_hash，修复不能读取其他候选历史。

新增程序观测产物（不改变模型输出或外部EDA schema）：

- pipeline_events.jsonl：追加队列、实际派发、验证完成、反馈、停止派发、自然收尾事件及相对时间。
- search_state.json：model_busy/validation_busy、pending_validation/pending_feedback、已用调用和预留验证位置。
- solution_ready.json：验证通过时立即写入的源码路径、哈希、版本绑定、成功就绪时间及是否正在收尾。
- final.json：pipeline_version、final_source_hash、solution_ready_seconds、drain_seconds、drain_status、discarded_model_jobs、max_pending_validation、generated_candidate_count。

CLI正常返回会等待已有模型请求自然结束；通过后不启动重试、Reviewer、修复、新候选或新验证。落后返回的产物保留审计并写disposition.json=discarded_after_stop，计入实际消耗，不作为通过代码。客户端timeout时backend_state_unknown，不保证服务器已经停止，本运行不再请求；下一运行应先确认服务空闲。

max_wall_clock_seconds为停止派发的软时限，正在执行的模型/验证不强杀。失败的实际消耗照常保留；未知值保持null。solution_ready_seconds不包含后续收尾，wall_clock_seconds包含，禁止拿前者冒充完整端到端墙钟。

Analyst为首份代码预留一次调用，格式失败回退来源派生；Review→Repair预留两次调用和一次验证位置；Rebuild→Generate在analysis.mode非disabled时预留两次、disabled时预留一次调用，均预留一次验证位置，前半段重试不能侵占最后的代码调用。max_candidates包含重建分支；源码重复只在本运行去重，无跨运行缓存。

验收除现有输出合同测试外，运行tests/test_pipeline.py：实际CLI→HTTP及独立验证进程设置双向等待，旧串行链无法通过；覆盖两个执行模式、反馈归属、容量、预算、自然结束与停止后的重试抑制。它不是GPU/Vivado真实性验证。

## 资源准入内部观测（2026-10-25）

执行版本bounded_pipeline_resource_v2；policy_version=resource_admission_v2。新增配置speculation.enabled与failure_reserve_calls=1|2（默认2）。core/search_policy.py替代已删除risk.py，Analyst/Reviewer均已删除模型risk字段。外部EDA/report及LLM消息合同不变。

context/search_policy.json保存实际策略，取代新运行的risk_assessment.json。pipeline_events.jsonl记录speculation_allowed/speculation_denied，含reason_code、remaining_model_calls、free_validation_slots、failure_reserve_calls、required_model_calls、required_validation_slots、completion_estimate=unknown。model_job_started标明speculative与failure_reserve_calls。B协议重试受同一保留数限制。

## 内部生成数据的合同边界（2026-10-25）

- 来源引用按出现顺序去重；build_task_facts 返回前 verify_facts。PROFILE 的结构、来源引用以及 scope/clocked/component 依赖由 task_profile.validate_profile 检查，StageContext 消费派生版本时再次检查。scope=conflict 时，clocked=None/conflict、component=unknown/conflict，不把矛盾来源提升为确定语义。
- 端口识别与合同一致：普通标识符使用 ASCII 字母/下划线开头，后续允许数字和 `$`；不声称支持完整 SystemVerilog 转义标识符。
- safe_feedback.warnings 先脱敏、按合同字符上限截取、保序去重，再限制为 EVIDENCE 的 maxItems（当前128）。validation_NN/feedback_projection_audit.json 记录投影来源及 input_count/unique_count/kept_count/duplicate_count/omitted_unique_count；计数针对该投影入口的脱敏警告，不等于整个 EDA 日志行数。原 result.json 和日志不截断。
- call_NN/audit/exception.json 保存异常类型和原消息。失败信封 error.code/message 保证非空并服从唯一 ERROR 合同上限；空异常不再使错误处理本身校验失败。
- 运行目录和初始快照建立后，事实/上下文/初始分析/策略选择异常写 initialization_failure.json、model_calls.json、pipeline_events.json 及 candidate_search/final.json，stop_reason=initialization_failure、passed=false，关闭 run_manifest，保留已发生的模型调用和未知消耗；runtime.reporting.collect_evidence 收集失败证据，通常CLI 返回2；未知本地收尾或后端状态返回3并禁止下一题。不保证无法读取任务或无法创建/写入运行目录时仍能持久化记录。

外部 EDA/report 合同和模型输出格式未变；pipeline_version=bounded_pipeline_resource_v2、policy_version=resource_admission_v2。没有旧风险调度回退。

2026-10-25：所有模型角色及baseline统一8912 token，当前8份JSON配置模型请求超时300秒。Controller不再按角色选择输出预算；execute_call校验同一全局上限，HTTP客户端的timeout使用model.request_timeout_seconds（workers读取同一配置）。Qwen参考服务默认和最大输出均为8912；此源码修改不等于远端服务已经部署。

## 思考边界修复（2026-10-25）

思考区为不透明正文，不支持嵌套语义。响应以`<think>`开始时，寻找候选`</think>`，其后必须恰好为完整最终区域；恰好一个合格边界才接受，多解拒绝。同行think起止标签兼容；最终区域起止标签仍独占一行。没有结束标签报UNCLOSED_THINK，有结束标签但最终区域非法保留最终区域错误，边界歧义报AMBIGUOUS_THINK_BOUNDARY。finish_reason=length单独保留，不单凭解析错误推断截断；token上限8912及请求超时300秒不变。原始响应只留审计，思考内容不进入候选/交接/下游提示词。

## 超时后端自然收尾（2026-10-25）

模型调用新增可选backend观测；HTTP使用X-Request-ID和GET /requests/{request_id}，仅匹配编号的completed/failed/rejected且busy=false解除屏障。CLI新增退出3和next_task_allowed，final增加backend_state/backend_drain_seconds/model_request_seconds。调用backend合同在agent/contracts/schemas.py；外部EDA/report合同1.0不变。完整状态、耗时口径和兼容边界见 [后端收尾](backend-drain-20261025.md)。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](protocol-alignment-20261028.md)。

## Agent结构精简（2026-10-28）

实际入口为agent.cli → runtime.run.run_task → 唯一CandidateSearchRunner。消息合同在contracts/messages.py，worker边界在runtime/worker_boundary.py，证据收集在runtime/reporting.py。删除无消费者的五个数据类/VersionRegistry及roles深层转发包装，不保留旧导入别名；scheduler运行产物路径继续使用。当前目录与验收见 [结构精简](agent-structure-20261028.md)。

## Analyst 当前合同（2026-10-29）

Rebuild的STAGE_DELTA必须含evidence和previous_attempt（revision_id/source_hash/candidate），StageContext核对源码SHA-256。reassessment必含prior_interpretation、feedback_observation、evidence_sufficient、interpretation_change、next_attempt_change；这些仍是模型建议，不是已证明根因。证据不足须明确记录，不编造。

内部LLM消息仍2.0、外部EDA/report仍1.0、task_facts仍2.0；只有derived_spec升级3.0，文件名仍derived_spec.vN.json。新运行不接受旧Analyst字段，不保留转换别名；历史产物不迁移。answer.json保存结构合法的原始答案，derived_spec记录逐条拒绝的collection/index/reason；模型上下文不包含rejected审计。完整合同、提示与消费边界见[Analyst改造](analyst-contract-20261029.md)。

## Reviewer 当前合同（2026-10-29）

Reviewer与Repairer的STAGE_DELTA必须包含candidate、candidate_binding（revision_id/source_hash）、evidence。绑定由Controller从不可变失败Revision生成，StageContext核对SHA-256；Repairer中的review必须与当前candidate_binding完全一致，禁止其他版本意见串入。

review.json由程序生成status（findings_available/no_supported_findings/unavailable）、candidate_binding、issues、limitations、rejected_issues。可用issue附source_check、candidate_check=exact_candidate_excerpt及semantic_status=unverified，这些不能由模型填写。rejected_issues仅保存index/id/reason，拒绝原文留在调用审计；传给Repairer的review不含拒绝审计。未执行/调用失败使用unavailable，空或全部被拒绝的成功审查使用no_supported_findings，均不能当作验证成功。

共享parse_json_answer仅负责最终区域与严格结构，不再接受无实际作用的facts/candidate参数；来源和定位统一由build_derived/filter_review按条处理。内部消息/handoff仍2.0、task_facts仍2.0、derived_spec仍3.0、外部EDA/report仍1.0；新输出不兼容旧Reviewer字段，不改写历史运行。详见[Reviewer改造](reviewer-contract-20261029.md)。

短原题边界：已接纳Reviewer条目的source_quote可能恰好等于整道短题，StageContext允许该必需引用进入Repairer；其他delta字段仍禁止复制整题，私有字段禁令不变。该例外有聚焦回归，不扩大到任意上下文。


## 搜索、证据与上下文更新（2026-10-29）

当前普通候选最多 A/B，第三候选名额用于一次失败重建；调用/验证预算不增加。未知画像有通用第二策略。诊断直达、Reviewer 隔离分析建议、重建证据直传、阶段输入裁剪与可选精确 token 预检，见 [当前行为与验收](search-evidence-context-20261029.md)。8912/300 秒与自然收尾不变，baseline 不变，无新增 Agent/目录。


当前三批修复见 [三批链路修复](three-batch-hardening-20261029.md)。第一批统一必要证据、候选反馈绑定、前端路径诊断和 Reviewer 单份源码视图。


三批修复现已覆盖：analysis.mode、B意见隔离、动作选择、反馈身份、必要错误保留、Reviewer单份源码、准确的重放状态，以及speculation.time_reserve和speculation_timings。当前默认after_failure；8912/300秒、自然收尾与baseline生成语义不变。


当前词法、候选推导及运行链路更新见 [三批实施说明](semantic-hardening-20261029.md)。共同词法位于model/rtl_lex.py，B修复继承意见隔离策略。


当前模型事实展示使用source.numbered_text（稳定R编号；原文不含展示前缀），原始FACTS合同和来源核验不变。模型profile为角色投影视图，不作为canonical PROFILE回读。候选来源字段、独立证据能力、词法重复标记和必要错误分区见 [当前三批修复](semantic-hardening-20261029.md)。report-collect已删除；模型/EDA worker类型保留。


2026-10-30 当前边界修复与顺序验收见 [边界、证据与调度修复](boundary-evidence-hardening-20261030.md)。未知接口/预处理/前端能力限制交给权威验证；worker 异常统一确认后端状态。


2026-10-30 当前运行规则：默认 analysis.mode=after_failure；speculation.timing_mode=observed，耗时样本不足等待 A 反馈；远端 SiliconMind 配置启用身份核验后的准确 token 预检。动作预算记录放弃的调用机会，策略版本 resource_time_admission_v3。详见 [边界、证据与调度修复](boundary-evidence-hardening-20261030.md)。8912/300 秒与后端自然结束规则不变。


## 2026-10-30 增量合同

唯一字段定义仍在 agent/contracts/schemas.py。EVIDENCE 新增可选 execution_trace、replay、public_diagnostics；原有 candidate_binding 与 validation_id 在真实候选交接处仍必须匹配。

- execution_trace 仅接受验证器安全投影主动提供的内容，原始 result、日志和波形中的同名数据不自动获得权限。初始化包含 status、inputs、reset_cycles；事件包含 cycle、clock_signal、edge、inputs 及可选 expected/actual；sampling_point 明确 before_update/after_update/unknown。
- 所有结构化信号值为不含前缀的十六进制字符串，允许 x/z。信号名使用原有 ID 合同，不接受路径。轨迹缺字段、初始化不明、输入集合不全、事件未排序或采样未知时 replay 为 insufficient；ready 也不表示已执行重放或证明根因。
- public_diagnostics 由 Controller 自己执行的公开样例填充，不能从权威结果中的任意同名字段采信。status 为 executed/not_executed/not_applicable，最多8条样例，携带来源编号、输入、期望、实际和匹配结果。只用于功能仿真失败后的辅助定位；编译错误、环境失败、通过及超时不追加该诊断。
- 辅助探针不读取私有资产，不改权威结果，实际耗时计入累计 EDA 时间。缺工具、编译失败、输出不完整不能报告执行成功。
- attempted_methods 的 behavior_summary 可保存已执行公开样例的简短观察；relationship_summary 继续是未验证意图。观察比较不证明全局等价，也不触发语义硬去重。

worker 异常响应统一通过 BackendLease 收尾；字符串形式的 baseline 错误记录仍可供共享汇总函数读取。无法确认后端或本地进程清理时 next_task_allowed=false，下一题受持久化屏障约束。


2026-10-30 当前词法、诊断完整性和运行身份规则见 [三批精确修复](precision-hardening-20261030.md)。转义标识符不当成结构关键字；diagnostic_coverage 明确说明安全 warning 省略/缩短；runtime_identity.json 绑定源码和脱敏有效配置，普通 worker 派发前核验。单 Controller、8912 token、300秒及自然收尾保持不变。
