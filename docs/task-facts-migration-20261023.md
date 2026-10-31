# plan3 任务事实改造记录

日期：2026-10-23。目标目录：`D:/AMD/4_agent_plan3`。

## 已落实

- 新增 task_facts.py：原题全文、源哈希、接口、明确范围和源行/表格引用组成任务事实；禁止同路径覆写。无法确定的内容不自动编造。
- 新增 stage_context.py：每次模型调用实际读取并校验事实文件，统一装配角色职责、事实、派生规格和允许增量。
- 修复器重新获得原题；Reviewer的缺来源建议和明确组合范围下增加clock/reset的建议不会被转交。
- 每个候选绑定独立派生版本，重建只新增derived_spec.v2，不改旧候选和task_facts。
- handoffs只保存增量/引用，shared_context只索引产物；worker请求/响应携带并核对context_binding。
- 移除Planner/Plan Reviewer空转、旧重复规格产物、旧修复提示词和按task_id规定语义的规则。
- 模型请求失败也计预算；提取失败或未变修复不重复验证旧代码。历史记忆默认关闭，max_tokens不会被误脱敏。
- 结构计数忽略注释与字符串，首错证据保留数值0，恢复指向实际通过的修复源码。

## 清理与路径

删除agent/core/spec_review.py和static_precheck.py两份不再使用的实现；删除两份旧架构说明，统一为docs/candidate-search-architecture.md。未新增外部依赖，保留原有worker和外部验证器接口。

当前配置和当前文档中的plan2执行路径改为plan3。历史runs、logs、failure_memory、reports、题目及验证器文件未修改，也不复制本次工作区的历史资产回目标目录。旧备份配置只作为历史文件保留。

## 验证

本次在隔离工作副本执行现有和新增的标准库测试，覆盖in-process和真实Python子进程worker的Mock链路。新增test_task_facts_context.py覆盖事实冻结与篡改、源表格保留、接口/组合范围、假verified、审查过滤、角色权限、增量去重、worker版本、修复原题可见、预算和分支隔离。

另对156份现有公开task.txt做事实提取检查：156份均能提取到端口，没有把“All input and output...”说明中的and误识别为端口。该检查没有读取私有测试内容，也不意味着所有参数化声明或语义已被证明。

最终检查：68项标准库测试全部通过，Python编译检查通过，preflight返回ready；Mock CLI两轮验证后passed=true、stop_reason=success。未启动真实模型或Vivado，因此不声称功能正确率、墙钟或真实硬件效果提升。

## 第一阶段当时的已知限制（当前以架构文档为准）

- 归一化接口使用保守的公开文本/ANSI声明解析，不是完整SystemVerilog parser；完整原题保底，unsupported内容留给EDA。
- verified派生规格目前只有exact_source_match；其他推导保持假设，未接形式化证明。
- Reviewer来源检查不证明其语义一定正确；已接受的问题仍是建议。
- 模型输入每阶段仍包含原题；交接去重减少失真和无关历史，不保证总token下降。
- 仍先生成候选再验证；本次不宣称baseline-first、全局墙钟deadline、workers缓存或自动续跑已经实现。


## 第二阶段：任务特征与条件策略

新增一个核心模块task_profile.py，在现有derived_spec中存储来源支持的任务特征；repair_strategy改为条件检查表。Controller的初始生成、审查、修复和重建均实际调用筛选，保存决策证据；max_candidates改为兼容策略上限。规则不预设复位、优先级、输出延迟、非法状态和碰撞策略。

删除无人调用的RTL角色封装及orchestration.roles声明，禁止HTTP扩展覆盖核心字段。未改变模型身份/生成参数/服务地址，未清理历史运行或私有资产。

验证包含标准库回归、编译、配置和Mock CLI检查；新增真实CLI→可选worker→HTTP请求测试，两模式分别覆盖9次模型请求、5次Mock验证。本阶段89项测试通过，其中包括两种执行模式下的实际HTTP请求断言；编译及Mock CLI检查通过。156份公开题面均可生成特征；当前80题范围unknown、15题combinational、61题sequential。这是保守分类覆盖率，不是功能正确率。没有运行真实大模型或Vivado，不宣称正确率或墙钟提升。特征提取仍是保守的英文模式匹配，未知时不强行分类。


## 第三阶段：可靠输出协议

代码统一8192，分析默认2048；严格RTL_CODE/answer边界，删除旧JSON和RTL回退。contracts/schemas.py覆盖所有模型/事实/派生/交接嵌套类型；提示词输出schema与实际校验同源。core/output_protocol.py统一进程内和worker处理，LLM消息升级2.0；原始响应和消耗在提取前落盘，失败保留信封和已知消耗，worker崩溃可恢复已落盘指标。think复用本地audit文件，不进入下游。协议重试最多一次且计入预算。

配置、Qwen参考服务、baseline预算及文档同步；旧运行快照不改写。当前工作副本108项测试通过，含两种模式各9请求完整链和各3请求失败重试链；最终安装结果以交付核验记录为准。独立HDL工具缺失时记not_executed，现有真实EDA编译负责解析；当前没有运行真实模型或Vivado，也不推断正确率提高。

完整规范见[接口](interfaces.md)，执行关系见[架构](candidate-search-architecture.md)。


## 第四阶段：有界流水线与自然收尾

本阶段直接替换candidate_search.py主循环：模型槽1、验证槽1、待验证缓冲1；反馈按不可变版本排队。风险真正控制提前生成。分析失败保留事实并回退，首份代码有预算保底；Reviewer按需执行，不再对所有候选前置调用/排序。重建放在全部已有机会之后，预留两次调用及验证位置，并受根候选总上限约束。

通过时保存solution_ready并停止派发，已有生成自然结束；不增加取消接口，不杀模型服务。客户端超时记录后端未知并停止该运行的新请求。独立记录成功就绪时间和含收尾墙钟。

清理：删除不完整的跨运行validation_cache.py，保留运行内哈希去重；删除四个无执行效果的配置字段，旧显式字段报迁移错误；worker消息编号并发安全，事实绑定由每个任务携带。未增加生产框架/依赖，未修改外部验证器或题目资产。

tests/test_pipeline.py以真实CLI/HTTP/独立验证子进程证明确有重叠、反馈在生成期间排队、修复父版本准确、成功先锁定后收尾、停止后不重试。详细命令、结果和限制见pipeline-verification-20261023.md。以前各阶段的测试数量及串行限制只描述当时实现，不是本阶段状态。
