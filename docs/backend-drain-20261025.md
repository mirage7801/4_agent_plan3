# 超时后的后端自然收尾（2026-10-25）

工程：`D:/AMD/4_agent_plan3`。本改动保留唯一 `bounded_pipeline_resource_v2` Controller 和 `resource_admission_v1` 资源准入，不增加 Agent、第二套执行器或取消接口。

## 行为

单次输出仍为 8912 token，生成请求超时仍为 300 秒。超时后，本题不再派发生成、协议重试、审查或修复；客户端只等待原请求自然结束。迟到答案不取回、不参与验证，也不改变本题超时结论。已经验证通过的其他候选可以保留，但后端未知时 CLI 仍退出 3，禁止继续投题。

独立收尾等待默认最长 120 秒，每 2 秒查询一次，单次状态查询最多 5 秒，查询时限受剩余收尾时间限制。它与生成时限分开，不延长答题资格。正常 HTTP 成功响应不查询状态、不增加固定等待；上一次请求已经结束时，一次状态确认后即可继续。

## 服务端协议

每次 POST `/generate` 带唯一 `X-Request-ID`。GET `/requests/{request_id}` 返回：

```json
{"request_id":"exact-request-id","state":"completed","busy":false}
```

`running` 表示推理仍在运行；`completed`、`failed` 表示已完成 GPU 同步并释放生成槽；`rejected` 表示请求因繁忙未获准入；`unknown` 表示不可确认。仅请求编号一致、状态为 completed/failed/rejected 且 busy 严格等于 false，才解除客户端屏障。只看到 health.busy=false 不足以确认任务生命周期。

`serve/request_state.py` 原子维护准入、任务状态及最近 1024 条记录。GPU 同步失败则保留 unknown 和繁忙状态，返回 503，不发布成功。服务重启或历史淘汰后无法查询旧请求时保持未知，不能推断为空闲。状态查询与原 HTTP 生成连接独立。429 和不确定的网络/5xx 错误也走状态确认，避免继续消耗候选撞繁忙。

**必须部署更新后的 `serve/qwen_server.py` 及 `serve/request_state.py`，使用单进程 `uvicorn serve.qwen_server:app --workers 1`。** 多 worker 的进程内注册表不能提供此保证。恢复脚本已有单 worker 启动方式。本次仓库修改不代表远端服务已部署或重启；旧服务没有状态接口时，超时后会安全阻止继续投题。

## 客户端与跨进程屏障

`serve/backend_lifecycle.py` 以端点为键持有操作系统文件锁；POST 前原子保存 pending request_id。客户端进程退出时锁自动释放，但 pending 记录保留；下一进程先查询旧任务，确认结束后才允许 POST。Agent 两种执行模式及 baseline 均由 `serve.factory` 构造同一个 HttpModelClient，不能绕过这一入口。

默认状态目录为系统临时目录下 `rtl-agent-backend-state`。长期测评可配置持久化目录；所有访问同一后端的配置必须使用同一 state_root、同一规范 URL。不同用户/机器、不同状态目录、其他 HTTP 客户端不受本地锁约束，因此服务端原子准入仍必须保留。临时目录清理、机器重启、手工删除记录会破坏客户端恢复证据；不要通过删除未知记录来强行继续。

```json
{"model":{"request_timeout_seconds":300,"backend_drain":{
  "max_wait_seconds":120,
  "poll_interval_seconds":2,
  "status_timeout_seconds":5,
  "state_root":"../runtime/backend-state"
}}}
```

省略 state_root 使用系统临时目录；相对路径相对配置文件展开。三个时间参数须为有限正数，未知键、空路径和布尔值被拒绝。

## 串行测评与退出码

CLI 保留 0（成功）、1（答题失败）、2（环境/配置失败）；新增 **3（后端无法确认结束，禁止继续投题）**，其优先级高于已有候选通过。状态接口返回404/405时立即报告status_endpoint_unsupported并停止等待；其他查询失败、错误编号、服务不可达或收尾到期，均不当作空闲。pending 保留；剩余题目保留为未执行。

仓库串行批次入口：

```powershell
Set-Location D:/AMD/4_agent_plan3
python -B scripts/run_batch.py --problems problems/example tests/fixtures/mock_counter --config config/experiment.example.json --output runs --mode agent
```

题目参数应替换为实际题目目录；baseline 使用 `--mode baseline`。批次在 0/1 后继续，在 3 或其他环境失败时停止，写 batch_summary.json 和 remaining 列表。恢复前核实服务与请求状态，再提交 remaining 中的题目。外层自有测评器也应遵守退出 3 和 next_task_allowed=false；即使其忽略退出码，使用相同端点/状态目录的新 CLI 仍会在 POST 前被遗留请求屏障拦住。

真实测评器若已等 GPU 结束，客户端不再增加固定等待。若外层在 300 秒杀掉客户端，客户端无法继续轮询；pending 可供下一次受控 CLI 恢复，但投递隔离最终仍需外层测评器和服务端共同执行。本实现不杀 GPU 进程、不取消推理。

## 记录与时间口径

final 增加 backend_state、backend_drain_seconds、next_task_allowed、model_request_seconds。调用的 backend 记录当前 request_id、previous_request_id、server_state、reason 和 request_elapsed_seconds；异常审计另有 audit/backend_drain.json。

backend_state=not_observed 表示未单独查询后端（如正常成功返回或纯 Mock），不能描述成实测 GPU 空闲。model_request_seconds 是客户端等待生成 HTTP 的时间，不是 GPU 纯计算时间。调用 elapsed_seconds/model_seconds 包括收尾等待；wall_clock_seconds 也包含收尾和验证，backend_drain_seconds 是其中的组成部分，不能再次相加或从完整墙钟中扣除。并行路径的时间分量也不能直接相加当总墙钟。

## 验收

`python -B -m unittest tests.test_backend_drain tests.test_pipeline tests.test_policy_http_chain tests.test_output_protocol -v`；全量为 `python -B -m unittest discover -s tests -v`。

覆盖正常无轮询、超时自然结束且迟到答案丢弃、状态未知/缺失/编号错误、收尾到期停止批次、不同 CLI 进程不可绕过、强制结束客户端后的恢复、两种 Agent 模式与 baseline。参考服务的实际 generate 函数使用硬件替身验证同步前仍繁忙、同步失败不能发布成功。PROTOCOL_EVIDENCE_ROOT 可指定真实 CLI/本地 HTTP 替身证据目录。上述测试不代表远端 GPU、真实大模型或 Vivado 测评已通过。
