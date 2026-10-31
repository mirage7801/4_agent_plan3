# 三批链路修复（2026-10-29）

> 历史版本说明：2026-10-30 已将默认分析改为 after_failure，并更新投机耗时准入；当前配置和验收以 [边界、证据与调度修复](boundary-evidence-hardening-20261030.md) 为准。本页保留当日实现记录。

按批次顺序实施，每批完整回归通过并安装、核验后才开始下一批。复用唯一 Controller、StageContext、合同和解析器；不增加生产模块，不改 baseline 或私有验证资产。

## 第一批：证据和上下文

- `stage_context.model_delta` 将有限条关键 warning 原文保留为 `required_warning_lines`，普通 warning 可在二级压缩删除。原题、唯一代码视图、结构化诊断及必要错误不删除；仍超限则明确报错。
- 诊断根据真实前端工作目录解析相对路径，核验完整候选路径；Windows 使用系统路径大小写规则，不按 basename 猜测。分别标记 syntax_error、elaboration_error、unsupported_frontend、frontend_error。
- Controller 给安全反馈附加 candidate_binding（revision_id/source_hash）及 validation_id。Reviewer、Repairer、重分析和重建生成在 StageContext 检查一致性；缺失或错配拒绝派发。外部 EDA 合同保持不变。
- Reviewer 的审计交接保留原始源码，模型只看完整 candidate_numbered。摘录仍由原始源码验证；压缩不得删唯一代码视图。
- failure_evidence.json 移除乐观的 reproducible，改用 has_io_example、replay_status=insufficient、missing_replay_fields。当前未提供完整重放合同，不宣称反例可复现。
- tokenizer 预检仍默认关闭，计数未知仍如实记录 unknown；本次不部署远端服务。

## 验证边界

本地单元测试、真实 CLI/HTTP 替身和独立验证进程能证明派发与合同生效，不能证明真实 GPU/Vivado 的功能正确率或墙钟收益。全局输出上限8912、单次300秒及后端自然收尾不变。

## 第二批：分析、独立候选和动作选择

- `analysis.mode=before_generation|after_failure|disabled`，默认 before_generation，并在当前示例/远端配置显式保留默认。after_failure 先生成，失败后依证据直接修复或在需要重建时调用重分析，不为每次失败强制新增分析。disabled 不调用首次分析/重分析，重建仅需一次代码调用。
- 普通第二候选 B 的模型视图隐藏 Analyst notes、ambiguities、reassessment。原始派生信息完整保留；A 和重建继续读取适用建议。各阶段 `.view.json` 记录意见可见性和实际展示字段，最终发送内容以 audit/sent_prompt.txt 为准。
- 具体可操作反馈优先直接修复；非具体反馈的首次修复在资源允许时做 Reviewer+Repairer，同一候选后续修复不重复审查。
- 普通策略已用完、同一候选已修复仍仅有非具体反馈、验证槽空闲并有完整预算时，重建优先于另一候选的模糊审查。仍保留直接修复及最后重建路径，不永久冻结两次调用。
- `action_decisions.json` 和 action_selected 事件记录动作、原因、调用/验证成本、放弃的替代动作及派发前余额。调用总预算和验证总预算不增加。
- 验证包含两种模式的实际 CLI/HTTP：首轮成功不调用后置 Analyst；B 确实不接收推断意见；七次预算内可从汇总失败转入重建；disabled 重建没有隐藏分析调用。

第二批还会在已有修复正在验证、其结果将决定是否重建时，暂缓另一候选的模糊审查，并记录 action_deferred；具体错误修复不因此被挡住。第一批目标目录全量回归：211/211，186.227 秒。


第二批目标目录全量回归：214/214，244.776 秒；动作记录纳入报告后的补充合同/实际 HTTP 回归15/15，47.659秒。完成上述验证后才开始第三批。

## 第三批：时间准入和观测

`policy_version=resource_admission_v2`。保留调用、验证名额、单模型槽、后端状态和反馈优先级；增加固定时间预留：

```json
"speculation": {
  "enabled": true,
  "failure_reserve_calls": 2,
  "time_reserve": {
    "generation_seconds": 300.0,
    "validation_seconds": 540.0,
    "drain_seconds": 120.0
  }
}
```

启动B要求剩余墙钟至少为三项之和（默认960秒），剩余EDA预算至少覆盖validation_seconds。540秒来自当前四阶段默认超时总和；这些值是可配置准入余量，既不是测量模型，也不承诺所有后续修复都能在截止前完成。既有时间/调用资源不足检查仍生效。没有跨题训练、难度关键词、题序依赖或新增调度器。

拒绝原因明确为 insufficient_wall_time_reserve / insufficient_eda_time_reserve；决策记录 required_wall_seconds、required_eda_seconds 和 fixed_configured_allowances。completion_estimate仍为unknown。

`speculation_timings.json` 和 final.speculation_timings 提供：

- b_a_validation_overlap_seconds：投机B模型任务与A验证任务的区间交集。
- failure_model_slot_wait_seconds：失败结果已知后，当前模型任务释放槽位前的等待。
- post_success_model_drain_seconds：首次通过后，已有模型任务自然完成前的观察区间。
- complete：任务区间是否闭合。未闭合时耗时为null，不能冒充0。

measurement_scope=controller_observed_job_intervals。这些值包含Controller观察边界及worker/协议开销，不代表GPU占用、因果上的节省时间或反事实修复收益。完整墙钟与solution_ready_seconds/drain_seconds继续保留。自然收尾、300秒请求、8912输出、后端未知退出3和跨题屏障不变。

报告收集动作决策和耗时产物。生产Agent模块数量不增加；没有目录迁移或旧路径兼容壳。baseline代码和初始提示词不变。远端服务无需为本次客户端修改重新部署；可选tokenize预检依然关闭，不声称远端已更新。


## 最终验收

- 第一批 D:/AMD/4_agent_plan3 全量211/211通过（186.227秒）。
- 第二批目标目录全量214/214通过（244.776秒），报告补充15/15通过（47.659秒）。
- 第三批聚焦33/33通过；目标目录最终全量218/218通过（259.613秒）。
- 测试执行顺序和安装记录核验通过：前批验证结束后才进入后批。
- in_process/workers 各六种模式/预算场景抓取实际HTTP请求；另有双向等待的独立假验证器验证生成与验证重叠、时间门槛拒绝派发及后端屏障。实际导入全部来自D盘工程。
- 32个累计变更文件哈希匹配，Agent仍29个Python模块，没有新增生产框架。baseline源码及初始提示词AST一致；远端模型生成配置保持原值。
- 不运行真实云端GPU/Vivado，不进行消融，不将替身通过宣称为正确率或墙钟收益。
