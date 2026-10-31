# 资源准入改造与链路验收（2026-10-25）

目标工程：`D:/AMD/4_agent_plan3`。pipeline_version=`bounded_pipeline_resource_v2`，policy_version=`resource_admission_v1`。

## 实现范围

删除agent/core/risk.py，原Controller直接调用agent/core/search_policy.py纯准入函数，无第二套执行框架。Analyst/Reviewer的risk只兼容原闭合输出合同，不影响派发、预算或重建。所有当前配置增加speculation.enabled=true、failure_reserve_calls=2，模型URL/ID/revision/temperature不更换。

提前生成B需要：模型空闲、缓冲为空、无反馈待处理、有兼容策略和候选名额、剩余请求不少于1+保留数、扣除已用及在验/待验后的验证名额不少于2。保留数1对应直接修复，2对应审查+修复。B的协议重试不能侵占保留调用。没有可靠耗时预测器，completion_estimate=unknown；总时间仍为软派发门限。

## 实际生产入口

run.ps1/run.sh/run_closed_loop.ps1 → agent.cli → SchedulerAgent → CandidateSearchRunner → speculation_admission → _model_job → StageContext → execute_call → HttpModelClient。

workers仅增加WorkerBoundary/agent.worker_cli执行边界；进程内和worker都调用相同execute_call与唯一Controller。验证仍为不可变Revision→原预检→EDA适配器，不修改验证资产。源码/反馈绑定、输出合同、自然结束和消耗审计保持。

## 如何证明确实换了调度

- test_pipeline.PipelineHttpTests通过实际CLI、HTTP服务、独立验证子进程双向等待：A验证等待B的HTTP请求，B生成等待solution_ready，证明先重叠再锁定并自然收尾。
- 默认Analyst返回low仍能重叠；旧风险路由无法满足预算5、low的场景。
- Analyst返回high但总预算4（A后只剩2）、验证额度2或禁用投机时，不发送B；旧high策略无法满足前两种资源场景。
- reserve=1且总预算4时重新允许B。两种execution_mode均执行这些组合，核对实际HTTP调用数、事件原因及没有risk_assessment.json。
- A失败反馈在B生成期间排队，之后修复提示携带A而非B源码。通过后不派发、不协议重试；模型/EDA各至多1槽。
- test_search_policy覆盖闭合配置、纯准入各边界，以及非法B输出不消耗后续修复预留的真实Controller流程。
- test_policy_http_chain覆盖按需审查、修复、最终重建、派生隔离及实际HTTP请求；test_output_protocol覆盖正式输出协议。

## 验证记录

暂存副本完整回归130项通过（100.221秒）。最终目标目录复验和源码指纹见同目录resource-admission-verification-20261025.json；目标安装后结果在下文追加。

这些测试使用本地HTTP模型替身和独立假验证器，证明实际生产调用链和调度行为，不代表真实模型正确率或Vivado性能。未连接或重启真实模型服务，未声称真实收益。

## 复验命令

```powershell
Set-Location D:/AMD/4_agent_plan3
python -B -m unittest discover -s tests -v
python -B scripts/preflight.py --problem tests/fixtures/mock_counter --config config/mock.e2e.json --output runs --json
python -B -m agent.cli run --problem tests/fixtures/mock_counter --config config/mock.e2e.json --output runs --run-id resource-smoke
```

PROTOCOL_EVIDENCE_ROOT可将合成链路JSON写到指定目录。历史runs/reports/logs和2026-10-23验收文件不改写。

## 目标目录安装后复验

- 从D:/AMD/4_agent_plan3执行完整130项回归，全部通过，耗时81.645秒。
- 目标目录preflight为ready，pipeline_version和policy_version均为新版本，验证器路径解析到目标工程内。
- 目标CLI Mock烟测passed=true，两次验证、三次模型调用，drain_status=completed。最初使用目标默认记忆目录的烟测在首轮失败后被中断；复跑仅将记忆输出目录改为可写工作区，求解配置不变并通过。
- 原目录30项变更与安装清单SHA-256逐一一致；部署前原文件保存在本机备份。Python源码解析和8份JSON配置加载通过。
- [机器可读证据](resource-admission-verification-20261025.json)内含目标目录实际HTTP/验证进程事件、预算组合、并发峰值、调用消耗和源码指纹。两种模式均覆盖准入与拒绝，不只依赖版本标记。
- 没有运行真实模型/Vivado，因此本次只确认当前生产链路与资源调度行为，不报告真实正确率或加速比。
