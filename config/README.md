# 配置

当前根目录：`D:/AMD/4_agent_plan3`。配置由 `config.loader` 合并默认值、校验并按配置文件目录解析相对路径。模型 ID/revision/URL/temperature 和8912代码预算不因流水线迁移而更换。

## 有界流水线

- `agent.architecture=candidate_search`：唯一 Controller，版本 `bounded_pipeline_resource_v2`，不保留旧串行开关。
- `agent.execution_mode=in_process|workers`：同一流水线的执行边界；workers 不改变角色语义。
- `orchestration.max_model_calls`：实际请求尝试总上限，失败/协议重试/最终丢弃输出均计数。
- `search.max_candidates`：独立根候选总上限，包含规格重建产生的新候选；修复版本不另计根候选。
- `search.strategies=["auto"]`：来源支持的兼容策略，不强制凑满候选数量。
- `search.max_repairs_per_candidate`：每个根候选修复上限。
- `search.max_vivado_calls`：实际 EDA 调用上限；派发模型任务前预留验证位置，计入在验/待验版本。
- `search.max_eda_seconds`：累计 EDA 时间的派发门限，包含执行公开辅助诊断的时间；在验耗时也用于保守判断能否提前生成。
- `search.max_wall_clock_seconds=3600`：总墙钟停止派发门限，包含分析、生成、预检和验证；进行中的调用自然结束，最终墙钟可能越过该门限。
- `search.failure_memory_root`、`memory_limit=0`：失败记录位置和历史注入数量；默认关闭注入。
- `agent.analysis_max_tokens=8912`、`protocol_retries=1`：分析/审查输出上限；分析/重建分析/Reviewer不做协议重试，代码至多一次协议纠错重试，baseline不重试；各角色统一8912。

模型槽1、验证槽1、待验证缓冲位1为固定不变量。关键词风险路由已删除。

- `speculation.enabled=true`：启用资源允许时的提前生成；false只禁止投机，失败后仍可生成其他候选。
- `speculation.failure_reserve_calls=2`：只允许整数1或2（不接受bool），默认2。B本身之外保留一次直接修复或两次审查+修复调用。
- B准入需要至少`1+failure_reserve_calls`次剩余模型调用，以及两个空闲验证名额（B、后续修复），不含已用、在验和待验名额。协议重试不得吃掉预留。
- 该配置对象为闭合字段，未知键报错；Analyst/Reviewer均不再输出risk，调度按资源、证据和明确的时间策略决定，不读取模型风险。
- speculation.timing_mode=observed时，耗时样本不足会等待反馈；fixed_window显式使用固定窗口；feedback_first禁止提前生成。估计标记heuristic_not_guaranteed，不虚构按时完成保证。

预算单题独立；没有题库难度学习或跨题预算共享。

重建需要至少两次模型调用及一次可用验证位置，只在其他候选/修复工作耗尽后启动。多调用任务的前半段协议重试不能侵占最后一次代码生成调用。

## 已移除的无效设置

`agent.max_feedback_characters`、`agent.model_timeout_retries`、`experiment.random_seed`、`orchestration.require_evidence_manifest` 原先没有执行效果，已从当前配置删除。旧配置显式包含时会报迁移错误，不能以快照字段冒充功能。反馈继续受现有安全投影/合同约束；超时后不自动重试；seed 未实现；报告证据始终收集。

`search.deep_spec_review`、`orchestration.roles` 仍被拒绝。旧 `validation_cache_root` 也不再支持，跨运行缓存已删除；当前仅源码哈希运行内去重。

## 运行与模型服务

```powershell
Set-Location D:/AMD/4_agent_plan3
python scripts/preflight.py --problem <task> --config <config.json> --output runs --json
python -m agent.cli run --problem <task> --config <config.json> --output runs
```

`experiment.example.json` 和 `qwen25_coder7b_rocm.json` 为真实HTTP+CLI模板，默认workers；固定历史revision必须与当前服务health核对。`*.local.json` 是本机配置，不提交凭据；本次只迁移调度配置，不重启服务。

`mock.e2e.json` 用于离线Agent分析→生成→修复，不能直接用于baseline。Gitee配置仍走原版bench适配器；不修改公开题目或私有验证资产。

后端暂不支持取消。通过后等待当前请求自然返回；客户端超时停止本运行新请求并等待任务终态与生成槽释放；仅无法确认时记录backend_state_unknown、退出3并阻止下一题。不能把断开HTTP当成GPU已经空闲。

恢复命令仅恢复已有证据：`python -m agent.cli resume --run-dir <run>`，不启动模型/EDA续跑。

2026-10-25 输出预算更新：所有阶段（Analyst、Synthesizer、Reviewer、Repairer、Rebuild）及 baseline 统一单次上限8912 token；`agent.analysis_max_tokens`保留兼容字段但必须与`model.max_tokens=8912`一致，不再允许独立降低。全部当前JSON配置的`model.request_timeout_seconds=300`；HTTP客户端和worker加载同一配置。测试专用超时可以缩短。上下文总长仍为32768，输入与输出合计不能超过后端容量。

## 超时后端自然收尾（2026-10-25）

新增 `model.backend_drain`：max_wait_seconds=120、poll_interval_seconds=2、status_timeout_seconds=5；state_root默认系统临时目录/rtl-agent-backend-state，可改持久化目录，相对配置文件解析。同一端点的所有配置共用状态目录。生成timeout仍300，输出仍8912。详见 [后端收尾](../docs/backend-drain-20261025.md)。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](../docs/protocol-alignment-20261028.md)。


## 搜索、证据与上下文更新（2026-10-29）

当前普通候选最多 A/B，第三候选名额用于一次失败重建；调用/验证预算不增加。未知画像有通用第二策略。诊断直达、Reviewer 隔离分析建议、重建证据直传、阶段输入裁剪与可选精确 token 预检，见 [当前行为与验收](../docs/search-evidence-context-20261029.md)。8912/300 秒与自然收尾不变，baseline 不变，无新增 Agent/目录。


`analysis.mode` 支持 before_generation、after_failure（当前默认）、disabled。disabled 同时关闭重分析。旧版本行为见 [三批修复](../docs/three-batch-hardening-20261029.md)，当前行为见 [边界、证据与调度修复](../docs/boundary-evidence-hardening-20261030.md)。B 首次生成及后续修复均隐藏 Analyst 意见；动作选择依据实际反馈和完整预算，记录 action_decisions.json。


三批修复现已覆盖：analysis.mode、B意见隔离、动作选择、反馈身份、必要错误保留、Reviewer单份源码、准确的重放状态，以及speculation.time_reserve和speculation_timings。当前默认after_failure；8912/300秒、自然收尾与baseline生成语义不变。

`speculation.time_reserve` 默认 generation_seconds=300、validation_seconds=540、drain_seconds=120；低于960秒剩余墙钟或540秒剩余EDA预算不启动投机B。全部字段必须为有限正数。固定余量不等于完成预测，详见三批修复文档。


`agent.worker_watchdog` 默认 allowance_seconds=30、termination_grace_seconds=10，有限正数闭合配置。外层时间包含HTTP300秒与两段自然收尾等待；不改变单次请求限时。未知本地清理或后端状态阻止下一题并退出3。模型视图、事件JSONL、直接报告和CLI计时详见 [当前三批修复](../docs/semantic-hardening-20261029.md)。无需迁移已有JSON：loader合并默认值。


2026-10-30 当前运行规则：默认 analysis.mode=after_failure；speculation.timing_mode=observed，耗时样本不足等待 A 反馈；远端 SiliconMind 配置启用身份核验后的准确 token 预检。动作预算记录放弃的调用机会，策略版本 resource_time_admission_v3。详见 [边界、证据与调度修复](../docs/boundary-evidence-hardening-20261030.md)。8912/300 秒与后端自然结束规则不变。

数值耗时缓存位于 backend_drain.state_root/timing-history，最多各16条观测，按端点、模型、revision、EDA配置和Controller源码哈希隔离。它不共享生成预算，也不学习题目难度；删除或不可用时回退到等待反馈。非Mock真实配置仍可显式选择before_generation；mock.e2e的固定响应序列保留该模式。


2026-10-30 当前词法、诊断完整性和运行身份规则见 [三批精确修复](../docs/precision-hardening-20261030.md)。转义标识符不当成结构关键字；diagnostic_coverage 明确说明安全 warning 省略/缩短；runtime_identity.json 绑定源码和脱敏有效配置，普通 worker 派发前核验。单 Controller、8912 token、300秒及自然收尾保持不变。
