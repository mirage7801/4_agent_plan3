# 词法、候选推导与运行链路修复（2026-10-29）

按三批顺序实施，前批目标目录验证完成后才进入后批。保留唯一CandidateSearchRunner、StageContext、输出协议和闭合合同；不增加Agent或调度框架，不改私有题目资产。

## 第一批：共同词法和候选上下文继承

- model/rtl_lex.py是共同词法位置：mask_noncode保留偏移、换行和分隔；module_declarations统一识别普通/automatic/static声明；module_header处理受支持的ANSI/参数化头部。model/extraction.py、static_checks.py、task_facts.py共同消费，删除重复识别函数。
- 严格最终输出区域和单顶层合同保持不变，不从think正文补救代码。识别器不是HDL编译器，最终语法/功能仍由现有前端和EDA检查。
- Revision持久化root_strategy_id、parent_revision_id、analyst_advice_visible、context_policy_reason。普通B隐藏意见，修复继承父候选设置；Reviewer始终隐藏意见，重建显式选择新策略并记录原因。
- generation.json/repair.json保存provenance；实际模型视图保留.view.json和audit/sent_prompt.txt，可核对意见是否真正进入请求。完整派生信息仍落盘。
- baseline使用同一词法基础设施，因此合法代码识别同步修复；baseline提示词AST、调用次数与生成配置不变。

## 验收边界

第一批聚焦48/48通过。逐批保存目标目录全量回归和真实CLI/本地HTTP、独立验证替身证据；这些不代表真实云端GPU/Vivado正确率或提速。8912输出、单次300秒及后端自然收尾不变。

## 第二批：证据能力、词法去重与解题提示

- feedback.evidence_capabilities分开记录定位工具错误、IO观测、可重放序列、审查假设与纯汇总失败；当前没有完整序列合同，replayable_trace不虚报为真。IO线索允许直接修复，时序/未知范围修复失败后仍可优先重建；不是强制每个观测都购买Reviewer。
- 同一运行内使用保守词法指纹跳过只改注释/排版的重复验证，记录duplicate_of与fingerprint_kind。源码SHA仍用于身份与反馈绑定。宏、转义标识符及未知字符退回原始SHA，不宣称语义等价，不跨运行复用验证。
- attempted_methods保留根方法、父修订与意见可见性；relationship_summary复用已接收的Analyst关系、Reviewer修复意图或重建改动意图，显式标记unverified；缺少现有依据时为unknown，不伪造实际RTL行为，不为摘要增加调用，也不据此跳过功能验证。
- Analyst允许没有区别性结论时返回空，不强迫制造错误解释；Reviewer优先区别性触发条件；Repairer检查修改没有引入无规格支持的状态、延迟、复位或优先级变化。不新增输出报告和角色。

## 第三批：模型视图、追加事件和完整运行收尾

- StageContext模型视图只展示source.numbered_text一份规格正文；每个非空行沿用R编号，空行使用L编号（不可作为requirement_refs）。编号前缀不是原文，引用必须去掉前缀。task_facts.json保持完整原文、SHA与闭合合同，引用仍以原始文本核验。
- 画像按角色投影，保留范围/冲突、时钟、复位、功能类型和来源；生成/分析另带请求组件。未知feature省略并明确omitted_feature_status=unknown，绝不解释成false。完整画像与handoff继续落盘。
- 错误提升到required_warning_lines后从普通warnings中删除。两部分合计最多8条/4000字符，重复投影不重复计数；压缩保留必要错误、原题和候选。精确token计数仍是可选尽力预检，远端未开启时不宣称有精确保护。
- pipeline_events.jsonl是运行期间的权威追加事件，关键完成/停止边界fsync；search_state.json只保留当前槽位、事件数量和日志引用，不重写历史。正常或受控停止时导出一次pipeline_events.json兼容历史报告。storage.read_events优先JSONL，只容忍末尾未完成行；中间损坏报错。resume读取同一事件源。
- 删除report-collect命令、消息字段、worker处理函数及派发分支。两种模式都直接调用runtime.reporting.collect_evidence；模型/EDA仍通过原worker边界，没有新Controller或兼容空壳。
- lifecycle_timing.json单独记录Runner、任务清单、报告收集、run_task和CLI main耗时。cli_main_seconds包含配置/客户端构建、答题、收尾、输出和退出决策；不包含解释器启动/销毁及最后一次计时文件写入。final.wall_clock_seconds仍为Runner范围，不能冒充完整CLI。模型任务/验证任务与自然收尾分段计时保留。
- agent.worker_watchdog默认allowance_seconds=30、termination_grace_seconds=10，均为有限正数。模型外层限时=启动余量+15秒token预检+请求超时+两段后端等待（默认585秒）；验证外层限时=启动余量+阶段限时合计+验证器120秒余量（默认690秒）。它不是把单次HTTP300秒改为585秒，也不缩短后端自然等待。
- worker和CLI验证器共用core.eda_adapter.run_owned_process：Windows只终止本次启动的PID及子树，使用只读进程快照逐项确认退出后回收管道；不单凭taskkill退出码判断成功，POSIX使用独立进程组；不停止远端GPU服务。修复验证器自己的外层超时时同样使用该路径，避免早于worker超时遗留进程。普通返回行为保持原合同。
- 模型worker超时后丢弃晚到结果；先确认本地清理，再进入既有BackendLease恢复持久化request_id，只等结束、不发新生成。未知后端状态保留pending并退出3。本地清理无法确认则在backend_drain.state_root/worker-barriers保存屏障；两种模式初始化及worker派发都检查，禁止下一题。验证器外层超时也传递清理确定性，无法确认则相同阻断。不得因清掉屏障文件而假装资源已释放；人工确认后才能处理屏障。

## 当前实际链路和结构

agent.cli → runtime.run.run_task → 唯一CandidateSearchRunner → StageContext → execute_call → HttpModelClient/BackendLease → HTTP。workers仅在模型/验证操作外增加worker_boundary/worker_cli，报告直接收集。model/rtl_lex.py是新增的唯一词法基础设施；agent目录不增加模块/目录，删除被替代的局部模块匹配、_concrete/_aggregate_failure和report worker链路。

8912输出上限、300秒HTTP超时、资源投机规则、逐题预算与自然后端收尾保留。baseline提示词、调用策略及配置未修改；共享RTL词法和验证器进程收尾修复同步受益。未执行真实云端GPU/Vivado、难题通过率对比或消融实验。


## 三批最终验收

| 顺序 | 目标目录完整回归 | 结果 |
|---|---:|---|
| batch1 | 222项 / 261.505秒 | 全部通过 |
| batch2 | 225项 / 259.42秒 | 全部通过 |
| batch3 | 238项 / 250.657秒 | 全部通过 |

每批目标目录验证完成后才开始下一批。额外覆盖：实际本地进程树结束、晚到结果丢弃、未知本地清理持久化、两种CLI退出3、UTF-8截断事件尾部恢复；实际HTTP断言核对编号规格、B修复意见隔离、绑定反馈、修复/重建、单份源码、事件一致性、直接报告与CLI计时。

导入位置、源码哈希核对、当前配置与脱敏HTTP验收摘要见 [验证记录](semantic-hardening-verification-20261029.json)。完整原始日志、安装回执与备份保存在本机工作区semantic_*和plan3_semantic_backup_*，不覆盖历史runs。
