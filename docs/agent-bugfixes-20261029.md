# Agent 诊断与结构检查修复（2026-10-29）

## 范围与行为

本次修复四项确定性问题，不改变 baseline、模型参数、资源准入、候选策略或后端自然收尾。未接入新的 summary 分类字段。

| 问题 | 当前实现 | 验收 |
| --- | --- | --- |
| unsupported 中的 port 被当成端口错误 | diagnostics.py 仅匹配明确的端口诊断短语；兼容 port_error 等下划线错误名，展开阶段及结构化多驱动诊断保持优先 | unsupported/transport/report 不因子串进入接口修复，真实端口错误仍进入接口修复 |
| x state 被通用 state 规则覆盖 | 明确的未初始化/latch 特征先于通用状态转移关键词 | x state、x_state 和未初始化状态进入 latch 指导；真实状态转移仍进入 FSM 指导 |
| 字符串中的 posedge 被当成真实时序逻辑 | static_checks.mask_noncode 为静态结构与接口范围检查提供共同文本视图，遮蔽字符串、注释并保留行与分隔 | 字符串和注释不误拒绝；真实时序、latch 和端口漂移继续拦截 |
| Repairer 把适用检查当成排他范围 | prompts.py 明确检查列表仅作提醒，允许修复原题与反馈支持的其他缺陷 | 两种执行模式的实际 HTTP 修复请求均断言收到新指令 |

mask_noncode 仅用于结构关键词检查，不是 HDL 解析器，不改变模型原始响应、候选源码、哈希或 Reviewer 精确代码引用。合法代码仍交给原有语法前端及 EDA；字符串错误等语法问题不能由该函数证明不存在。

## 文件与链路

不新增生产模块、不搬移文件、不保留第二套文本处理逻辑。task_facts.py 复用 static_checks.py 的普通函数；无反向依赖。baseline 的 build_initial_prompt 和 baseline 目录保持不变。

实际链路仍为：

`agent.cli → runtime.run.run_task → CandidateSearchRunner → StageContext → _generate_stage → output_protocol.execute_call → HttpModelClient → HTTP`。

workers 在同一处理入口外增加 worker_boundary/worker_cli；不是另一套旧 Controller。错误标签从 diagnostics → repair_strategy → Repairer 输入；预检使用共享文本视图。

## 验收命令与边界

从 `D:/AMD/4_agent_plan3` 运行：

```powershell
python -B -m unittest tests.test_agent_bugfixes tests.test_policy_http_chain tests.test_output_protocol -v
python -B -m unittest discover -s tests -v
```

新增回归验证分类结果及实际修复策略、字符串/注释遮蔽、真实存储与接口变化拦截。test_policy_http_chain 从实际 CLI 发起本地 HTTP 请求，两种模式均检查新 Repairer 指令、事实/候选绑定、角色序列与输出合同。

本地 HTTP 模型替身和 Mock EDA 用于验证路由、传递和执行链，不能证明真实模型会理解指令或真实 Vivado 难题正确率提升。真实模型语义验收还需对已知缺陷进行独立运行。本次不访问远端模型/GPU，不改历史 runs/reports。
