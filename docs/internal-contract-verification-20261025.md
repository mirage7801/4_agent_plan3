# 内部合同修复与链路验收（2026-10-25）

工程：`D:/AMD/4_agent_plan3`。本次修改处理 Agent 内部生成数据与校验规则不一致的问题；不改变资源准入规则或模型输出合同。

| 问题 | 修复与回归证据 |
|---|---|
| 同一原文同时命中 clocked/sequential 与 edge，引用重复导致冻结失败 | field 统一保序去重；完整事实→派生→交接测试，实际 CLI/HTTP 场景使用重叠原文 |
| scope 冲突后 clocked/component 仍带确定结论 | 冲突处理后计算依赖字段，生产和 StageContext 消费时检查依赖 |
| 超过128条警告令 EVIDENCE 校验失败 | 脱敏、去重、有界投影与独立审计；HTTP 修复请求128条，原验证结果140条 |
| 空 ModelClientError 使失败信封再次报错 | 按唯一 ERROR 合同补足非空消息并限长，原异常单独审计 |
| 初始化期间异常未生成最终记录 | 原 Controller 关闭 manifest、记录失败 final 和真实调用消耗；两种模式实际 CLI 返回2 |
| 端口识别正则与合同不一致 | ASCII 普通标识符与 `$`规则对齐 |

## 执行链路

入口继续为 run.ps1/run.sh/run_closed_loop.ps1 → agent.cli → SchedulerAgent → CandidateSearchRunner → StageContext → execute_call → HTTP。workers 只增加消息/子进程边界。唯一 Controller 和资源准入策略不变，版本仍为 bounded_pipeline_resource_v2 / resource_admission_v1；不恢复 risk.py 或旧串行主循环。

实际 CLI/HTTP 与独立验证子进程测试在两种模式检查：A验证时B生成、低risk可重叠而高risk预算不足仍等待、反馈归属、按需审查/修复、最后重建、通过后自然收尾及禁止新增派发。上述行为不能仅靠版本字符串通过。

## 验收状态

暂存首轮全量137项通过（102.452秒）；随后新增两种模式实际CLI初始化失败测试，聚焦8项通过。目标目录最终全量 **138/138通过**（100.452秒）。8份配置加载和55个Python文件语法检查通过，离线预检ready。20份合成HTTP/验证链路证据及源码哈希见[同名JSON](internal-contract-verification-20261025.json)。

测试使用本地 HTTP 响应替身和 Mock/独立假验证器，证明代码入口、调度与数据合同生效；没有执行远程真实大模型或 Vivado，不能据此宣称正确率或墙钟提升。任务读取失败或无法创建/写入运行目录不在可持久化收尾保证内。

## 文件与路径

复用现有生产文件，没有新增生产框架或第二套校验 schema。新增一个聚焦测试文件和本验收说明/JSON；历史 runs/reports/logs 不覆盖。安装只复制审核清单中的文件，原文件逐项备份。所有运行路径仍以目标工程为根，不引用安装暂存目录。

安装备份：`C:/Users/chenr/Documents/ChatGPT/agent/plan3_contract_backup`。已核对目标文件与安装清单SHA-256一致；Controller和output_protocol实际导入路径均位于目标工程。
