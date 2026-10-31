# 搜索、证据与阶段输入调整（2026-10-29）

本文记录 2026-10-29 的行为；2026-10-30 的默认分析、调度与远端 token 预检配置以 [边界、证据与调度修复](boundary-evidence-hardening-20261030.md) 为准。历史 runs 不改写。本次没有执行消融或真实 GPU/Vivado 性能实验。

## 搜索预算与方法

唯一 Controller 仍是 `agent/orchestration/candidate_search.py`。初始普通候选最多 A/B 两个；画像未知时也提供 direct 和 constraint_derivation。专用策略只在程序画像支持时加入，不能用未知画像假定组合/时序或新增时钟、复位、状态、延迟。策略指令包含推导步骤，最终输出仍是原有 RTL_CODE 合同。

默认及此前两候选的运行配置改为总候选上限 3：A/B 加最多一个重建 C。第三名额不用于普通投机生成。模型调用预算未增加，当前 remote-siliconmind.local.json 保持 7 次；验证预算保持 6 次，每候选修复上限 1。显式配置 max_candidates=1/2 仍生效，不会越界。

重建仅在普通策略及可修复路径用尽、没有在运行/待验证工作、有失败反馈、剩两次模型调用及至少一次验证机会时启动一次；同时检查现有时间/EDA 预算。它不是每题必执行。Reviewer/协议重试消耗同一调用预算。

attempted_methods.json 保存本题已生成版本、源码哈希、策略、验证结果和安全失败摘要；重建接收最多最近 32 项，不含其他候选完整代码。优先选未尝试的兼容方法；没有时使用 evidence_reconstruction，依据失败证据重新推导。策略不同不是语义不同的证明。

保留 stop_reason=candidate_search_exhausted 兼容报告，新增 search_exhaustion.json 及 final 中同名字段：剩余调用/验证数、候选上限、可修复版本、剩余策略、阻断原因。applicable=false 表示本次停止并非搜索耗尽；通过时不能把这些能力边界解释为失败。

## 诊断直达修复

廉价结构/接口检查先执行；明确失败时不启动 HDL 前端。前端失败从本次返回输出提取最多 8 条候选绝对路径匹配的错误：工具名、行号、可用错误编号和简短描述；重复定位/描述去重，其他文件的诊断不转发。完整输出仍在 syntax.log，不让模型依赖读取本地文件。

候选预检诊断通过既有安全反馈增加 diagnostics.candidate_errors。外部 EDA schema 不变，不读取 testbench/reference/XDC 内容。无法提取时明确记录诊断不足，不编造。_concrete 依赖明确预检错误、多驱动诊断、候选行定位或完整功能 mismatch，而不是仅凭阶段名称。

## 四角色与交接

- Analyst 默认优先 0–4 条会改变 RTL 的结论，已有 statement/example 描述误解、正确关系和区分条件；合同仍允许原有上限，不为多一条建议拒绝整份输出。
- Synthesizer 采用具体推导步骤，仅输出完整 RTL，不新增分析输出协议。
- Reviewer 模型视图不含 Analyst implementation_notes、ambiguities、reassessment。原题、程序画像、对应候选/反馈仍在。程序生成 candidate_numbered 展示视图；candidate/source_hash 不变，引用必须匹配不带行号的原代码。
- Repairer 按观测、根因假设、原题要求和必要修改处理，不能把汇总 mismatch 解释成具体周期/信号。
- 重建后的 Synthesizer 直接收到 previous_attempt（源码、版本、哈希）、绑定反馈、尝试记录和重评结论。StageContext 验证哈希与合同，不依赖 Analyst 二次转述。

阶段合法键直接复用 contracts.schemas.ROLE_KEYS，避免重复维护允许字段表。无新增 Agent/调度模块，无路径搬移。删除无消费者 candidate_snippet；行号视图只有 StageContext 一个生产入口。

## 模型视图与 token 额度

完整 facts/derived、handoff、安全反馈及原始验证结果继续落盘。实际模型输入使用紧凑 JSON，减少重复校验元数据；原题和需求行引用保留。

warning 在安全投影上先按错误、候选行定位、critical/latch/width、一般信息排序，再限制审计反馈上限。结构化诊断在展示裁剪前提取。模型视图默认最多 8 条、4000 字符，并记录 warnings_omitted；完整统计见 feedback_projection_audit.json，模型裁剪不改原始结果。

model.token_count_preflight 默认 false，不要求现有远端服务已有新接口。启用时 Agent 客户端向与 generate 同级的 POST /tokenize 发请求；检查 exact、model/revision、input_tokens 和 context_length。参考 qwen_server.py 计数和生成复用 prompt_inputs，使用同一 tokenizer/聊天模板，计数不获取 GPU 生成槽。

精确计数超过 min(配置长度,服务长度)-8912 时，先去掉行号展示/记忆，再去掉辅助分析建议及 warning，保留原题、候选、重评和关键诊断；每步重新计数。仍超限报 CONTEXT_BUDGET_EXCEEDED，不发生成请求。audit/context_budget.json 记录每步；audit/sent_prompt.txt 记录实际 Agent 输入。输出上限不降低。

接口关闭、404、网络失败或身份/计数异常时状态记 unknown，不用字符数估计、不声称精确检查；后端生成自身的上下文限制仍生效。启用计数会增加少量 CPU/网络开销，预检最多 3 次、单次最多 5 秒。baseline 不调用此 Agent 预检，目录与提示词函数保持原样。部署服务端更新需另行操作，本次不重启云服务。

8912 输出、300 秒生成超时、120 秒独立收尾、单模型/验证槽和自然收尾均保持。跨题 FailureMemory 仍默认关闭，本次不把失败日志宣称为在线学习。

## 功能验收

```powershell
python -B -m unittest tests.test_search_evidence tests.test_policy_http_chain tests.test_output_protocol -v
python -B -m unittest discover -s tests -v
```

实际 CLI/本地 HTTP 两种模式检查：Reviewer 看不到 Analyst 标记、行号视图一致、重建失败源码/反馈到达下一生成、七次预算容纳重建、参考 tokenizer 共用模板、超限不发生成、诊断定位安全投影、廉价失败跳过前端、完整反馈未被模型裁剪改写。

本地替身证明执行链与合同，不证明真实模型正确利用了所有信息，也不证明正确率或墙钟收益。
