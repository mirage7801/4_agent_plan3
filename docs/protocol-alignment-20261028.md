# 全局格式对齐与无效重试修复（2026-10-28）

工程 `D:/AMD/4_agent_plan3`。沿用唯一 Controller、StageContext、output_protocol、model/framing.py；未新增 Agent 或调度器。输出预算8912、生成请求超时300秒保持不变。

## 唯一格式来源

`model/framing.py` 维护标签、output_contract、frame_final、final_region；prompts和协议纠错从output_contract取得格式规则，Controller从frame_final输出规范最终区域。Agent in_process、workers经execute_call；baseline经extract_rtl；全部消费同一final_region。JSON字段和worker信封仍由agent/contracts/schemas.py约束，EDA/report外部合同1.0不变。

| 内容 | 生成要求与读取能力 |
|---|---|
| RTL | 首选独占行 `<RTL_CODE>`、完整唯一顶层模块、独占行 `</RTL_CODE>` |
| RTL兼容包装 | 上述整个区域可套一层完整独占行 `<answer>` / `</answer>` |
| Analyst / Reviewer / 重建分析 | 独占行 `<answer>`、唯一合法JSON对象、独占行 `</answer>` |
| 前导思考 | 允许完整前导think；正文不按嵌套XML解析，必须与完整最终区域联合确认边界；只留原始审计 |

不接受Markdown、最终区域外文字、多个最终区域、重复/未闭合包装。不从未闭合think或普通正文提取代码，不恢复module搜索和宽松JSON兜底。读取合法外层包装后，内部统一输出直接RTL_CODE区域，不把包装和思考传给下游候选。

## 六项修改与痛点

1. task_facts.source_quote_matches仅归一化空白，匹配范围为引用行的连续区间并集；不跨未引用行拼接，原始文本和refs保留。parse_json_answer及build_derived共用该函数，非空白字符不模糊匹配。已核验派生的check_method区分exact_source_match和source_match_whitespace_normalized；推理性claim仍为unverified，引用匹配不证明claim正确。解决排版差异导致的误拒。
2. 严格兼容一层answer包装，解决代码完整却重复调用模型删除标签的问题。
3. 代码/Reviewer最多一次协议重试，保留具体错误代码与消息，并注入同一输出合同。连续两次代码调用出现相同retryable错误代码（包括关闭协议重试后跨候选重复），关闭本题新模型派发，保留已有候选验证；无通过结果时最终model_protocol_error。错误代码不同则不判相同错误；模型/后端错误仍按原逻辑。解决跨候选重复撞格式错误及candidate_search_exhausted隐藏根因。
4. Analyst与重建分析都不重试协议；已有冻结事实和独立来源派生，失败直接回退后生成。输入事实校验失败仍报初始化错误；超时/后端未知仍停止派发，不借回退绕过。解决第一份代码前花多次调用修辅助JSON。
5. 移除Synthesizer和Repairer通用文本中的组合逻辑限制；保留task_profile/applicable_checks已有来源条件注入，不适用时不强加。解决顺序电路收到无关组合限制。
6. 独立收尾默认120秒，所有当前配置同步。状态接口404/405立即停止等待，reason=status_endpoint_unsupported、next_task_allowed=false、CLI退出3，pending不删；其他异常有界查询。解决接口不存在时白等半小时；不声称GPU已停，也不允许下一题偷跑。

## 真实失败响应重放

本地runs/repair/prob031四份代码均可解析；第二份分析仅空白差异，可通过引用核验。第一份分析还含错误refs和跨不连续内容拼接，必须继续拒绝，不能为让历史样本通过而放宽证据。之前将两份分析都概括为空白问题不准确；本次按原始响应纠正。历史runs不改、不补写成功结果；解析成功不等于Vivado功能通过。

## 验收与实际链路

`python -B -m unittest tests.test_protocol_alignment tests.test_policy_http_chain tests.test_output_protocol tests.test_think_framing tests.test_backend_drain tests.test_pipeline -v`，全量 `python -B -m unittest discover -s tests -v`。PROTOCOL_EVIDENCE_ROOT指定证据输出目录。

test_protocol_alignment通过实际CLI/HTTP验证两种Agent模式和baseline的包装兼容、分析只调用一次回退、具体纠错、相同错误停止及8912请求上限；另测合法候选继续验证、错误证据拒绝、404快速失败及pending保留、六份历史响应。现有test_policy_http_chain继续核对多角色/修复/重建执行链。测试使用本地HTTP和Mock EDA，不宣称远端GPU/真实模型/Vivado验证完成。

远端服务仍须部署任务状态接口；404快速退出只减少无意义等待，不能替代服务端任务生命周期证据。旧pending不自动删除。修改不会结束正在运行的客户端；新配置在新启动的CLI生效。

2026-10-29后续变更：Reviewer改为issues/limitations，单次审查不做协议重试；下文/上文2026-10-28测试与规则是当时记录，不代表当前Reviewer输出合同。当前实现见[Reviewer合同](reviewer-contract-20261029.md)，RTL/answer边界仍共用model/framing.py。
