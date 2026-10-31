# 词法、诊断与运行身份修复（2026-10-30）

三批按顺序实施；每批在目标 D:/AMD/4_agent_plan3 完整回归通过后才进入下一批。复用现有模块，不新增 Agent、调度器或 HDL 解析框架。

## 第一批：转义标识符

model/rtl_lex.py 统一识别以反斜杠开始、由空白结束的 Verilog 转义标识符。结构视图屏蔽其内容，保留长度、换行和分隔；声明识别使用保留标识符的视图，从真实 module 关键字定位。正常标识符等价的转义顶层名（如 `\top `）可识别；不支持的接口返回 unknown 并交给 EDA。源码落盘、哈希和 EDA 输入保持原文。词法指纹对转义源码保留原来的保守原文哈希回退，不扩张去重资格。

严格答案标签、禁止从思考正文提取 RTL 的规则保持不变。真正的模块不配对、结构错误和时序范围限制仍然生效。

## 验证范围

本地测试和 CLI/HTTP 替身可验证实际派发与合同，不代表真实 GPU/Vivado 正确率或性能提升。保留单次输出 8912 token、请求超时 300 秒和自然收尾规则。

## 第二批：必要诊断与完整性

现有 feedback.py 的 diagnostic_warning_view 为唯一 warning 模型视图整理规则，StageContext 初次展示及 token 压缩共同调用。只合并空白归一化后完全相同的安全消息，不推断共同根因；不同代码位置、错误编号、消息保持独立。长消息保留头尾并标记 shortened，不能称为完整证据。

required_warning_lines 保留短诊断文本，diagnostic_coverage 保留对应身份、类型、可解析行号/编号、保留数、遗漏身份及原因；不再重复展示长 warning。范围明确为“当前可用安全 warning 投影”，不保证覆盖私有原始日志。最多八条、4000字符；缩短或遗漏均为 partial。显式指定的核心消息不缩短，无法全部放入时以 CONTEXT_EVIDENCE_INCOMPLETE/context_evidence_incomplete 停止该路径，不派发盲修请求。二次压缩保留核心诊断及完整性记录；可选 warning 被移除时更新元数据。完整日志继续保留。


## 第三批：运行身份

每次普通 Agent 运行创建 runtime_identity.json：枚举 agent、model、serve、config 下运行 Python 文件（包含内嵌提示词），以相对路径排序，记录文件内容 SHA-256 和代码总哈希；有效配置使用脱敏展开结果独立哈希，已知非敏感布尔 token_count_preflight 正常计入。Git 提交/dirty 独立保留；没有 Git 也有稳定内容身份。时间戳、Markdown、tests、runs、缓存、凭据值不计入代码哈希。配置文件本身不公开散列密钥；配置身份不区分被脱敏秘密值的变化，也不是外部模型/工具身份或已加载字节码证明。

run_manifest.json、最终结果、报告清单、模型调用元数据和普通运行的 worker 请求/响应引用同一三哈希绑定。Controller 每次模型/验证派发前核验当前源码和内存有效配置；worker 独立加载配置并核验后才允许调用 HTTP 或 EDA。Mock 响应切片只影响执行替身，不改变已冻结配置身份。父/子身份不符停止新工作，记录 RUNTIME_IDENTITY_MISMATCH。已有自然收尾屏障不变。哈希检查不是文件锁，不宣称可消除检查后文件被外部立即修改的竞态；运行期间应避免修改项目源码。

可选绑定用于兼容低层协议测试与历史直接调用，普通 Agent CLI 路径自动生成并强制传递绑定。baseline 生成提示与执行路径不变。只增加现有 storage.py 的公共身份函数，无新增生产模块。


## 最终顺序验收

| 批次 | 全量测试 | 结果 | 秒 |
|---|---:|---|---:|
| 1 | 262 | OK | 273.306 |
| 2 | 267 | OK | 338.7 |
| 3 | 271 | OK | 340.498 |

第一批全部通过后开始第二批，第二批全部通过后开始第三批。每批测试在目标目录执行。验收记录：[测试与源码身份](precision-verification-20261030.json)、[最终目标核对](precision-runtime-audit-20261030.json)、[进程内请求](precision-chain-in_process-20261030.json)、[worker请求](precision-chain-workers-20261030.json)。

两种模式实际CLI发出 A→B→Reviewer→Repairer→重分析→重建 的六次请求（特定失败场景），四次证据消费均收到五条长ERROR对应的短诊断和partial标记。六次准确token预检、8912输出token及300秒请求超时保持。身份绑定贯穿manifest、最终结果、报告、调用元数据及普通worker请求/响应。当前生产Agent仍29个Python文件、一个Controller，无新增生产模块；baseline生成源码与生成提示未修改。未执行消融、真实云GPU或Vivado性能实验。
