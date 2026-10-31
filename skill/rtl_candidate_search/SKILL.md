# RTL Candidate Search Skill

这是项目内部的候选搜索知识包，不是独立 agent，也不依赖外部路由器。

## 用途

将 Vivado 的结构化反馈分类为细粒度错误类别，并把分类转换为修复约束。运行时代码位于
`agent/core/diagnostics.py` 和 `agent/core/repair_strategy.py`；本目录保存可迁移的知识描述，
后续可以直接整理为训练 Skill。

## 硬约束

- 不读取或保存 testbench、reference RTL、XDC 内容。
- 只使用 `project_safe_feedback()` 投影后的证据。
- 修复必须返回完整顶层模块，保持接口清单不变。
- 先诊断证据，再修改 RTL；不能用删除功能来规避错误。
- 同一候选的修复次数受搜索预算约束，失败后优先切换候选或假设。

## 分类

- `PARSE_ERROR`：编译语法和模块结构。
- `ELABORATION_ERROR`：顶层模块、端口和接口连接。
- `WIDTH_OR_SIGN_ERROR`：位宽、扩展、截断和 signedness。
- `RESET_TIMING_ERROR`：复位极性、边沿和释放周期。
- `OUTPUT_LATENCY_ERROR`：输出延迟和采样周期。
- `PRIORITY_ERROR`：enable、同时条件和读写冲突。
- `STATE_TRANSITION_ERROR`：FSM、序列和状态转移。
- `UNINITIALIZED_OR_LATCH`：未初始化状态和不完整组合赋值。
- `SIMULATION_ERROR`：剩余的功能仿真不一致。
- `synthesis`：多驱动、latch、不可综合写法。
- `timeout`：无界循环、等待和过高验证复杂度。
- `general`：无法进一步归类的候选级错误。

## 修复顺序

1. 读取结构化反馈和规格合同。
2. 选择分类对应的检查清单。
3. 做最小修改并重新提取完整 RTL。
4. 先检查接口和代码结构，再交给 Vivado。
5. 失败后记录脱敏经验，避免跨题重复同一错误。

## 2026-10-30 证据与工具边界

- 前端不支持、预处理未执行、接口解析未知均不能证明 RTL 错误；交给权威 EDA。
- 时序单点样例不等于可重放轨迹；核对初始化、时钟事件、有序输入和采样位置。
- 公开表格辅助诊断必须实际执行，缺工具明确未执行；结果只支持局部诊断，不能覆盖权威验证。
- relationship_summary 是未验证意图；behavior_summary 与 observed_behavior_comparison 只描述已执行公开样例。
- 当前文件是知识说明；实际规则来自 core/failure_evidence.py、core/feedback.py、core/static_checks.py 和 core/eda_adapter.py。不依赖自动读取 Markdown 生效。
