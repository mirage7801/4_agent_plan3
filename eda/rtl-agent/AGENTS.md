# rtl-agent project instructions

- 定位：本项目只负责 AMD RTL 的编译、详细描述、仿真、综合与结果判定；不调用模型、不改候选 RTL、不管理重试。
- 运行：从本目录执行 `python -m unittest discover -s tests -v`；单题命令见 `README.md`；全题参考实现用 `python tools/run_all_tasks.py --tasks-dir demo_tasks --implementation reference`（会实际运行较长时间的 Vivado 综合）。
- 技术栈：Python 3.12、Vivado 2026.1、目标器件 `xczu3eg-sbva484-1-e`；Icarus 仅作补充检查，不代替 Vivado 判定。本机 Vivado 可执行文件不在 PATH，验证器会定位安装路径。
- 目录与契约：`tools/` 是入口和 Tcl；`interfaces/` 是 schema 1.0 合同；`demo_tasks/` 中 `task.txt`/`task.json` 是公开题目，`reference.v`、`tb_*.sv`、XDC 和 `faults/` 不得发送给生成模型；`outputs/`、`logs/` 保存逐次历史，禁止把旧失败改写为成功或默认覆盖运行；`reports/` 保存真实汇总和交接。保持 CLI/result.json 字段语义一致。
- 当前状态与下一步：十题最新真实 Vivado 结果为 10/10，通过记录在 `reports/validation_summary.json`；详见 `reports/final_handoff.md`。首轮 counter 超时和中文路径综合异常是保留的历史记录，本机通过独立 ASCII 临时工作区解决。下一步与队友二、三按 `interfaces/validation_contract.md` 联调；不要宣称已证明时序收敛或形式等价。
- 边界：只改本项目获授权的文件；不得修改上级目录的 PDF、附件、队友文件或开工前已有的 Vivado 进程。未经用户在收尾汇报后明确确认，不清除旧运行、日志、网表或调试残留。





 - 定位：本项目负责 AMD RTL 的编译、详细描述、仿真、综合、结果判定及错误反馈质量；不调用模型、不自动修复候选 RTL、不管理智能体重试。
  - 运行：从本目录执行 python -m unittest discover -s tests -v；单题命令见 README.md；全题参考实现使用 python tools/run_all_tasks.py --tasks-dir
    demo_tasks --implementation reference。该命令会实际运行 Vivado 综合，耗时较长。

  - 技术栈：Python 3.12、Vivado 2026.1、目标器件 xczu3eg-sbva484-1-e；Icarus 仅作补充检查，不代替 Vivado 判定。本机 Vivado 不在 PATH，验证器会自动定
    位安装目录。

  - 目录与契约：tools/ 是 CLI、Python API、日志解析器和 Vivado Tcl；interfaces/ 是 schema 1.0 合同；demo_tasks/ 包含十道示例题目。task.txt/task.json
    是公开题面；reference.v、tb_*.sv、XDC、faults/ 属于验证环境，不得发送给生成模型。

  - 历史与输出：outputs/、logs/ 保存逐次运行、失败结果、原始日志和网表；禁止删除历史记录、覆盖旧 result.json，或把失败结果改写为成功。重复运行必须使
    用新的输出目录。

  - 阶段二解析改进：tools/log_parser.py 优先读取结构化 TB_FAIL kind=... case=... cycle=...；普通数值差异归为 functional_mismatch；只有明确复位证据才
    归为 reset_behavior_error；只有结构化或充分时序证据才归为 latency_mismatch；X/Z 为 unknown_value；看门狗或外部仿真超时为 simulation_timeout。

  - 错误定位：Vivado 的临时 source.v/source.sv 路径会映射回原始候选 RTL；摘要可包含真实文件名、行号、列号和候选代码前后各两行。testbench 错误会标记
    为验证环境问题；无法可靠定位时写 位置未知，不编造行号。

  - 结果接口：保持 schema_version=1.0、现有顶层字段和字段语义不变；summary 仍限制在 1000 字符以内；原始完整日志继续保存在 log_files 指向的文件中。
  - CLI 退出码：0 表示验证全部通过；1 表示候选 RTL 或结构质量失败；2 表示环境、参数、工具链或没有候选 RTL 证据的模拟器进程失败。队友三继续使用
    tools/validate_rtl.py 和 result.json，接口没有新增不兼容 CLI。

  - Testbench 改进：counter、shift_register、sequence_detector 使用明确的 case、cycle、输入、expected、actual 字段；在时钟下降沿驱动输入，在后续上升
    沿并等待 NBA 更新后检查，保留 TEST_PASS 和非零失败退出行为。

  - 阶段二测试：tests/test_validator.py 已扩展为 12 项，覆盖结构化分类、复位误分类、延迟误判、X/Z、仿真超时、Vivado 文件定位、临时路径映射、
    testbench 错误、warning 保留、连锁错误优先、摘要长度和 schema 校验。

  - 阶段二测试结果：截至 2026-09-23，纯 Python 测试为 12/12 通过，python -m compileall -q tools tests 通过，阶段二新增 result.json 均通过 schema 1.0
    校验。

  - Vivado 状态：此前完成的十题参考实现最新完整批量结果仍为 10/10，记录在 reports/validation_summary.json。阶段二新增语法错误和顶层模块错误案例已真
    实使用 Vivado 2026.1 验证；语法错误可定位候选 RTL 行号，顶层错误分类为 module_not_found。

  - 当前环境限制：阶段二新运行中的 reference、reset、width、shift_register、sequence_detector 仿真被本机 xsim 数字签名错误 -2146762486 阻断。验证器
    将其记录为 simulation/unknown_error，摘要标记 no candidate RTL evidence，CLI 返回 2；不得把该问题转交给队友二作为 RTL 修复任务。

  - 报告与交接：基线记录在 reports/feedback_improvement_before.md；队友二和队友三的真实示例在 reports/feedback_examples.md；完整交接在 reports/
    final_handoff.md；接口说明在 interfaces/validation_contract.md。

  - 联调边界：队友二只能使用 stage、error_type、summary、必要 warnings 和候选 RTL 片段；不得接触 reference.v、完整 tb_*.sv、XDC、faults/ 或原始完整
    Vivado 日志。队友三负责 attempt 历史、退出码、result.json、重试策略和最终候选选择。

  - 当前待办：恢复或更换可用的 xsim 2026.1 仿真环境后，重新完成阶段二要求的 counter、shift_register、sequence_detector 及故障案例复测，再运行一次十
    题参考实现完整批量回归。

  - 版本注意：开发验证结果来自 Vivado 2026.1；不得把这些结果声称为官方赛题 Vivado/Vitis 2025.2 正式评测结果。官方 2025.2 环境仍需单独复核。
  - 边界：只修改本项目授权文件；不得修改上级目录 PDF、附件、队友其他目录或开工前已有的 Vivado 进程。未经收尾确认，不清理旧运行、日志、网表或调试残
    留。
