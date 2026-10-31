# serve

负责人：队友三
职责：提供本地模型服务和统一客户端，实现 `generate(prompt, max_tokens, temperature)`。

- 输入：本地权重挂载、推理配置和请求。
- 必做：启动、健康检查、超时、错误返回、显存与版本记录；支持 ROCm 和离线运行。
- 产出：稳定模型服务、客户端接口和启动/停止说明。
- 验收：相同配置可被 Agent 与 baseline 共用，服务失败能明确返回。
- 禁止：运行时下载权重、隐藏修改采样参数、将凭据写进代码。

当前仓库实现：`MockModelClient` 支持受控文本、空响应、错误和超时；`HttpModelClient` 只访问配置的本地 JSON URL，失败显式上报且不回退在线模型。`qwen_server.py` 是可版本化部署的 ROCm Qwen 服务，恢复步骤见 `docs/backup-and-restore.md`。2026-10-04 和 2026-10-08 的云端试运行使用当时实例上的服务；其源码与本仓库版本尚未核对字节一致性，10-08 健康检查报告 `revision=local-unpinned`。正式服务配置仍待负责人确认。

2026-10-23：HttpModelClient在构造时拒绝extra_request_fields覆盖prompt/model/revision/max_tokens/temperature；config.loader也做相同检查，防止阶段输入被覆盖。


Qwen参考服务现在允许8912输出，MODEL_CONTEXT_LENGTH默认32768并核对模型配置，精确计数聊天模板输入，超限拒绝。响应新增finish_reason/requested_max_tokens。HttpModelClient归一服务已提供的消耗和结束原因，缺失记unknown/null；不通过文本长度猜截断。本次没有重启或验证任何远端GPU服务。

## 超时后端自然收尾（2026-10-25）

`request_state.py` 提供原子单槽准入和GET /requests/{request_id}；`backend_lifecycle.py` 提供跨进程端点锁、POST前持久化及超时后的独立状态轮询。客户端X-Request-ID贯穿任务生命周期；GPU同步成功后才发布终态/释放槽，同步失败保留unknown并返回503。必须部署两份服务端文件并保持uvicorn单worker。正常响应无固定等待，超时不取消、不取迟到答案。详见 [协议与部署边界](../docs/backend-drain-20261025.md)。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](../docs/protocol-alignment-20261028.md)。


## 搜索、证据与上下文更新（2026-10-29）

当前普通候选最多 A/B，第三候选名额用于一次失败重建；调用/验证预算不增加。未知画像有通用第二策略。诊断直达、Reviewer 隔离分析建议、重建证据直传、阶段输入裁剪与可选精确 token 预检，见 [当前行为与验收](../docs/search-evidence-context-20261029.md)。8912/300 秒与自然收尾不变，baseline 不变，无新增 Agent/目录。
