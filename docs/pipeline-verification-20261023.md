# 有界流水线验收（2026-10-23）

目标工程：`D:/AMD/4_agent_plan3`。版本：`bounded_pipeline_v1`。此记录描述实际调用链测试，不是大模型/真实Vivado性能报告。

## 已完成检查

- 工作副本全量标准库回归：127项通过。
- Python语法检查及8份当前JSON配置加载通过。
- 离线preflight ready；Mock CLI两次验证后passed=true，输出pipeline_version及drain_status=completed。
- 两种execution_mode的实际CLI→HTTP→独立假验证子进程测试共6种组合通过。

## 如何排除空壳套旧链路

1. 假验证器验证A时，等待模型B的实际HTTP请求到达；旧“先生成所有代码再验证”流程不能满足这种双向等待。
2. B请求等待Controller写solution_ready后才返回，证明成功在模型仍运行时已经锁定，CLI确实等待自然结束。
3. 失败场景中，A失败反馈必须在B请求仍运行时进入队列；B完成后模型收到的修复代码必须是A，不是B。
4. B验证通过后A1自然返回，A1不再验证；并发计数确认模型/验证各最多一个。
5. 成功期间返回非法格式时，没有协议重试；失败调用仍进入消耗统计。
6. CLI/manifest/final有版本标记，模型和验证任务保留各自事实绑定及source_hash，worker请求/响应编号不冲突。

结果JSON保留事件时序及Controller/worker/test源码SHA-256：[pipeline-verification-20261023.json](pipeline-verification-20261023.json)。这是行为证明加源码指纹，不只验证配置字符串。

## 调度回归

7次模型调用预算用于Analyst、A、B、按需审查A/修复A、按需审查B/修复B，第4次验证B1通过；没有单独花掉最后一次调用的规格重建。

重建在只剩1次模型调用时不启动；候选总上限包含重建。低风险不提前生成B；验证只剩1个位置时不提前生成B；满缓冲不派发新模型工作；max_model_calls=1跳过分析直接代码；分析格式失败不吃掉预留代码调用。

后端超时不发送下一请求并标记backend_state_unknown；环境失败不修RTL；软deadline停止派发；修复不变/重复源码不重复验证。Windows下队列观测与原子替换的短暂文件占用已做有界重试。

## 命令

```powershell
Set-Location D:/AMD/4_agent_plan3
python -m unittest discover -s tests -v
python -m unittest tests.test_pipeline tests.test_policy_http_chain tests.test_output_protocol -v
python scripts/preflight.py --problem tests/fixtures/mock_counter --config config/mock.e2e.json --output runs --json
python -m agent.cli run --problem tests/fixtures/mock_counter --config config/mock.e2e.json --output runs --run-id pipeline-smoke
```

可设置PROTOCOL_EVIDENCE_ROOT输出合成证据。正式服务需先核对health身份、上下文和输出上限，再使用当前配置运行公开题目。没有更改服务地址/模型身份/温度，没有启动真实模型或Vivado，也不宣称正确率和墙钟提升。

## 清理和安装边界

删除agent/core/validation_cache.py和不执行的配置字段；直接替换原Controller，没有新增生产调度框架。文档统一指向plan3与现有入口。历史runs/reports/logs、题目、验证器和服务源码不改写。

写回目标目录前核对原文件SHA-256并备份，只复制变更清单。安装后从目标目录再运行完整回归、preflight和Mock CLI；安装后复验结果追加在下方。

## 目标目录安装后复验

已从D:/AMD/4_agent_plan3执行完整127项回归，全部通过；preflight返回ready且验证器解析路径在目标工程内。目标CLI Mock烟测passed=true、pipeline_version=bounded_pipeline_v1、drain_status=completed。同组HTTP/独立验证进程验收包含在目标目录完整回归中。
