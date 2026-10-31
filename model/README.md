# model

负责人：郑泽韩
职责：保存模型声明、权重挂载约定和离线校验信息，不保存实际权重。

- 输入：选定模型的官方来源、许可证、版本、量化与校验和。
- 必做：维护与根目录 `MODEL.md` 一致的部署说明和兼容性记录。
- 产出：可审计的模型来源、离线挂载方案和显存测试证据。
- 验收：陌生环境能确认所需权重及版本，且仓库不含权重文件。
- 禁止：提交模型权重、访问令牌、私有下载链接或虚构显存数据。

本目录同时包含编排层所需的 `ModelClient`/`ModelResponse` 抽象和纯 RTL 提取器；实际模型身份仍以根目录 `MODEL.md` 为准，仓库不包含权重。


当前提取器只接受独占行的RTL_CODE标签；旧Markdown/正文module回退已删除。framing.py剥离前导think并定位最终区域，不是HDL parser。ModelResponse新增标准/原始结束原因、输入/输出/思考token和请求上限，未知值保留null。真实语法检查由agent预检调用已安装前端或由EDA编译完成。

## 思考边界修复（2026-10-25）

framing.py将前导think正文视为不透明文本，不解析嵌套。逐个检查候选结束标签，只有其后恰好是完整、唯一的RTL_CODE或answer区域才接受；同行think标签仍兼容。缺少结束标签报UNCLOSED_THINK，存在结束标签但最终区域非法报相应最终边界错误，歧义报AMBIGUOUS_THINK_BOUNDARY。代码内标签文本不删除；不从未闭合思考中搜索代码。

## 超时后端自然收尾（2026-10-25）

ModelResponse追加可选backend观测，不改变generate调用签名或RTL解析。backend包含request_id/previous_request_id、后端状态、收尾耗时、HTTP请求耗时和next_task_allowed；字段由同一合同源定义，外部EDA合同保持1.0。详见 [后端收尾](../docs/backend-drain-20261025.md)。

## 全局格式对齐（2026-10-28）

格式指令与内部输出统一由model/framing.py维护，RTL支持唯一一层完整answer外包装；JSON仍用answer。来源引用仅归一化空白，禁止跨未引用行拼接。分析失败不做协议重试，使用冻结事实派生；重复同类代码协议错误停止新生成，已有合法候选继续验证。组合限制按适用条件注入。收尾默认120秒，状态接口404/405立即退出3且保留pending。说明与验收见 [格式对齐](../docs/protocol-alignment-20261028.md)。
