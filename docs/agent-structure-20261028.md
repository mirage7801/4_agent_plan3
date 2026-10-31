# Agent结构精简与链路核验（2026-10-28）

工程 `D:/AMD/4_agent_plan3`。本次以实际导入和生产调用为依据，不按“Agent数量”保留无调用的类或深目录。agent下Python源文件由39个减为29个；移除14个旧文件，新增4个实际运行模块。

| 原结构 | 调整及理由 |
|---|---|
| contracts/common/contracts.py | 删除五个未被运行时消费的数据类；实际worker合同由schemas.py/messages.py校验 |
| contracts/common/versioning.py | 删除未被Controller使用的VersionRegistry；当前不可变Revision/候选哈希已管理版本 |
| contracts/common/messages.py | 移到contracts/messages.py，保留全部身份、事实绑定和响应核验 |
| runtime/scheduler/agent.py::SchedulerAgent | 改为runtime/run.py::run_task；它实际只做生命周期清单和报告收尾，不是第二个调度器 |
| runtime/scheduler/worker_boundary.py | 移到runtime/worker_boundary.py；工程根目录改从实际agent包位置计算，避免固定parents层级指错工程 |
| roles/reporting/report_agent/agent.py | 改为runtime/reporting.py::collect_evidence普通函数，保留证据清单与worker/resume调用 |
| roles/validation/vivado_agent/agent.py | 删除只转发适配器并加rtl_version的包装；Controller直接调既有EDA适配器并统一绑定版本 |
| roles与common/scheduler空包、旧缓存 | 删除已移走的包层级和旧编译缓存，不提供别名或旧执行路径 |

当前结构和调用图以[agent/README](../agent/README.md)和[candidate-search-architecture](candidate-search-architecture.md)为准。入口模块agent.cli、agent.worker_cli、agent.resume不变；scripts/preflight.py和报告说明生成器同步新入口/路径。

## 运行边界

唯一Controller仍是CandidateSearchRunner；pipeline_version=bounded_pipeline_resource_v2、policy_version=resource_admission_v1。run_task既不选择候选也不拥有额外队列。模型角色由Controller与StageContext装配，workers只执行相同execute_call。格式/引用/重试与120秒后端屏障保持上一轮修复。

scheduler/task_manifest.json、scheduler/messages、candidate_search/final.json及报告合同保留：它们是运行产物命名空间，不是旧源码路径。历史runs/logs/reports、既有日期验收证据、报告对历史versions/current.json的只读识别保持原样。接口中删除的Python类没有生产消费者；不对外部未知脚本保留空兼容壳，外部脚本如导入旧路径须迁移到上表。

## 验收方法

全量：python -B -m unittest discover -s tests -v。重点：test_pipeline、test_policy_http_chain、test_protocol_alignment、test_output_protocol、test_backend_drain、test_internal_contracts、test_candidate_search、test_worker_contract。

实际CLI分别运行in_process和workers，检查HTTP请求中的分析/生成/审查/修复/重建输入及8912预算；使用独立假验证器建立双向等待证明模型与验证重叠，旧串行循环不能通过。检查成功先锁定后自然收尾、协议失败阻断、worker消息绑定和失败报告。resume测试确认无需重新调用模型也能从不可变验证证据重建报告。PROTOCOL_EVIDENCE_ROOT保存HTTP替身/CLI证据。

安装按文件哈希确认没有覆盖并行修改、备份原文件后写入；删除限于列出的旧源文件及agent下编译缓存，旧包目录仅在空时移除。随后从D盘原工程运行全量测试，并记录实际模块导入和worker启动根目录。受控HTTP/Mock EDA/独立假验证器不代表远端大模型/GPU或真实Vivado已经测评通过。
