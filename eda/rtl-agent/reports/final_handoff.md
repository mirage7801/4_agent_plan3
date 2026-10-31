# RTL 验证工具链与 Demo 题库交接

## 1. 完成状态

**完成。** 工具、十题、自检 testbench、四个故障实测及计数器四阶段实测已完成；十份 `reference.v` 的最新结果在真实 Vivado 2026.1 上均通过编译、详细描述、testbench 仿真及目标器件综合，且每题均有非空网表和无 `ERROR` 的综合日志。首轮批量曾因一次跨数小时的异常超时记下 counter 失败；历史记录保留，随后以同一 CLI 在 batch 目录补跑成功，并从十份权威 `result.json` 重建最终 `all_passed=true` 汇总。Icarus 结果仅为额外交叉检查。

## 2. 实际环境

项目根 `E:\fpga\赛题研究\rtl-agent`。Windows 11 家庭中文版 64 位（10.0.26200），Python 3.12.10 (`C:\Users\46611\AppData\Local\Programs\Python\Python312\python.exe`)。Vivado 2026.1 build 6511674，实际入口 `D:\AMDDesignTools\2026.1\Vivado\bin\vivado.bat`，同目录的 `xvlog.bat`、`xelab.bat`、`xsim.bat` 均可调用。目标 `xczu3eg-sbva484-1-e` 经 `get_parts` 匹配 1 项，BASIC 许可证有效至 2027-09-20；计数器综合实际取得 `Vivado_Synthesis`/器件许可。E 盘初始可用 89,870,794,752 字节，写权限可用。详见 `reports/environment_report.md`/`.json`。该 Windows 版 `vivado -version` 打印正确版本但返回 1；实际 batch 返回 0。

## 3. 输出与位置

- Agent 规则：`AGENTS.md`（下次接手的简短入口；使用方法仍以 `README.md` 和本报告为准）。
- 工具：`tools/{validate_rtl.py,validator_api.py,run_all_tasks.py,log_parser.py,result_schema.py}`。
- Vivado Tcl：`tools/vivado/{synth.tcl,run_xsim.tcl,check_environment.tcl}`。
- 契约：`interfaces/{task.schema.json,result.schema.json,validation_contract.md}`。
- 题库：`demo_tasks/{counter,enable_counter,shift_register,edge_detector,sequence_detector,priority_encoder,parity,parameterized_adder,arbiter,synchronous_fifo}/`。各有 `task.txt`、`task.json`、`reference.v`、`tb_<name>.sv`、README；带时钟者有 XDC。
- 四故障：`demo_tasks/counter/faults/{missing_semicolon,wrong_port_width,wrong_reset,multiple_driver}.v`。
- 测试：`tests/test_validator.py`；Icarus 临时产物 `outputs/icarus_quick/`。
- 原始日志：`logs/manual_counter/`（来自首次成功真实四阶段调用的逐阶段完整副本，非另一次综合）；各次独立运行 `outputs/counter_reference*`、`outputs/faults/*`、`outputs/batch/*`。
- 单题成功：`outputs/counter_reference_run_20260921_155829_3ff8d0b8/result.json` 和 `synth_netlist.v`；四故障各目录的 `result.json`。批量：`reports/validation_summary.json`/`.md`。
- 交接：本文件与 `reports/artifact_manifest.json`。

## 4. 主要文件含义

| 路径 | 文件作用 | 输入 | 输出 | 主要使用者 |
|---|---|---|---|---|
| `AGENTS.md` | 下次 Agent 的最小边界、命令与当前状态 | 项目现役事实 | 项目规则入口 | 后续 Agent |
| `tools/validate_rtl.py` | 稳定 CLI、退出码 | 源码、bench、top、器件、时钟、目录 | stdout JSON、result.json | 队友三 |
| `tools/validator_api.py` | 独立阶段/超时/工作区/工具调用 | 同上，Python 参数 | dict、逐阶段日志、网表 | 队友三、CLI |
| `tools/run_all_tasks.py` | 逐题通过 CLI 跑 reference | tasks-dir/task.json | 批量汇总 | 验证工程师 |
| `tools/rebuild_summary.py` | 从真实单题结果重建汇总，不重跑工具 | `outputs/batch/*/*/result.json` | 汇总 JSON/Markdown | 验证工程师 |
| `tools/log_parser.py` | 基于日志分类与警告摘录 | 工具文本、阶段 | error_type、摘要 | 验证器 |
| `tools/result_schema.py` | 1.0 结果构造及 schema 检查 | task/result dict | 校验或错误 | 验证器、测试 |
| `tools/vivado/synth.tcl` | 指定 part 执行 synth_design 并写网表 | RTL、top、part、XDC、网表路径 | post-synth Verilog/标记 | Vivado batch |
| `tools/vivado/run_xsim.tcl` | 运行仿真至 testbench 结束 | xelab 快照 | 仿真输出 | xsim |
| `interfaces/task.schema.json` | 公开任务元数据结构 | task.json | 校验规则 | 队友二、三 |
| `interfaces/result.schema.json` | 固定 JSON 字段/枚举 | result.json | 校验规则 | 队友二、三 |
| `interfaces/validation_contract.md` | 职责、路径、保密与版本语义 | — | 接口约定 | 三方 |
| `demo_tasks/*/task.json` | 唯一任务元数据来源 | 公开规格、文件名、超时 | 模型公开任务字段/调度参数 | 队友二、三 |
| `reports/validation_summary.json` | 十题真实汇总 | 逐题 result.json | 机器可读状态 | 三方 |

## 5. 统一接口

在项目根执行的真实命令：

```powershell
python tools/validate_rtl.py --source demo_tasks/counter/reference.v --testbench demo_tasks/counter/tb_counter.sv --top counter --part xczu3eg-sbva484-1-e --clock-period 5.0 --output-dir outputs/counter_reference
```

Python 等价入口：

```python
from tools.validator_api import validate_rtl
result = validate_rtl(source="outputs/task_001/attempt_01/solution.sv",
    testbench="demo_tasks/counter/tb_counter.sv", top="counter",
    part="xczu3eg-sbva484-1-e", clock_period_ns=5.0,
    output_dir="outputs/task_001/attempt_01/validation")
```

成功的真实完整示例：`outputs/counter_reference_run_20260921_155829_3ff8d0b8/result.json`，关键字段：`{"schema_version":"1.0","passed":true,"stage":"complete","error_type":"none","vivado_version":"2026.1"}`。失败的真实完整示例：`outputs/faults/wrong_reset/result.json`，关键字段：`{"passed":false,"stage":"simulation","error_type":"reset_behavior_error","summary":"Fatal: TEST_FAIL cycle=1 inputs rst=1 enable=0 expected=00 actual=ff reset behavior"}`。两份完整文件包含真实 argv、路径、耗时与日志；这里的片段只用于阅读，不替代文件。退出码 0=四阶段均过，1=待测 RTL/结构质量失败，2=环境、参数、文件或工具错误。stdout 只有 JSON，`result.json` 与 stdout 内容相同。重复目录自动加唯一后缀，除非显式 `--overwrite`。

## 6. 与队友二对接

队友二提供遵循公开 `task.txt` 或 `task.json` 描述的 RTL 代码，由队友三存入独立 attempt；队友二只读取队友三转发的 `stage`、`error_type`、`summary`、必要 `warnings` 和候选源码相关片段以编写修复提示。不得给生成模型 `reference.v`、完整 `tb_*.sv`、XDC、`faults/` 或原始 Vivado 日志，也不要把整个任务目录作为模型上下文。私有文件的绝对内容不进入提示词。

## 7. 与队友三对接

每轮创建 `outputs/<task_id>/<run_id>/attempt_01/solution.sv` 与独立 `validation/`，调用 CLI 并读取退出码及实际 `output_dir/result.json`；超时返回 `timeout` 或 `simulation_timeout`，保留原始日志；按照首次失败的 stage/error_type/summary 决定下一轮，`attempt_02` 不覆盖前轮。队友三自行管理重试次数与最终候选选择，不能改 bench/reference；基线与智能体候选都使用该验证器。绝对路径和含空格/中文路径可传入，Vivado 输入在临时 ASCII 工作区逐字节暂存，原始源码未改。

## 8. 实际执行过的命令及日志

| 命令/操作 | 结果 | 日志/证据 |
|---|---|---|
| `vivado.bat -version` | 打印 2026.1；Windows 返回 1 | `reports/environment_report.*`、各 `environment.log` |
| `vivado.bat -mode batch -source tools/vivado/check_environment.tcl -tclargs xczu3eg-sbva484-1-e` | part 匹配 1，BASIC license 有效 | `reports/environment_report.*` |
| `xvlog`、`xelab`、`xsim`、`vivado -mode batch -source synth.tcl`（绝对路径，由单题入口逐阶段执行） | counter 四阶段通过，网表非空 | `logs/manual_counter/`，上述 counter 成功 run |
| `python tools/validate_rtl.py ... faults/<name>.v ...` | 见下一节，每项保留独立 run | `outputs/faults/*/result.json` |
| `iverilog -g2012 -s tb_<name> ...` 与 `vvp`（十题） | 10/10 通过，仅额外交叉检查 | `outputs/icarus_quick/`、执行记录 |
| `python -m compileall -q tools tests`、`python -m unittest discover -s tests -v` | 编译成功，5/5 测试通过 | 测试命令输出 |
| `python tools/run_all_tasks.py --tasks-dir demo_tasks --implementation reference` | 首轮 9/10 通过；counter 在长时间中断后被记为 synthesis timeout | `outputs/batch/*/*/result.json`；首轮汇总已被最终重建 |
| `python tools/validate_rtl.py --source demo_tasks/counter/reference.v ... --output-dir outputs/batch/counter_001/20260921_213105` | 补跑通过，网表生成 | `outputs/batch/counter_001/20260921_213105/` |
| `python tools/rebuild_summary.py` | 从十题最新真实结果重建，退出 0，`all_passed=true` | `reports/validation_summary.json`、`.md` |

原始计数器第一次 Unicode 路径综合在 RTL elaboration 后异常退出 `0xC0000374`，记录于更早的 `outputs/counter_reference_run_20260921_155416_a54a6259/`；ASCII 私有临时工作区复跑成功。`logs/manual_counter/README.md` 准确说明成功日志的副本来源。

## 9. 测试结果

- counter reference：Vivado 编译、详细描述、testbench `TEST_PASS` 和目标器件综合均通过；`synth_design` 汇总为 0 errors，post-synth 网表已保存。
- `missing_semicolon`：compile / syntax_error；`wrong_reset`：simulation / reset_behavior_error；`wrong_port_width`：Vivado 仅警告端口 8/7 位差，仿真高位 `Z`，simulation / width_mismatch，warning 保留；`multiple_driver`：Vivado `synth_design` 返回 0 并产生网表，但 critical multi-driven warning 说明驱动被忽略，验证器以 synthesis / multiple_driver 拒绝，绝非伪造工具错误。
- Icarus 补充检查：十题 10/10 自检通过。Vivado 最终十题 10/10 通过，`reports/validation_summary.json` 的 `all_passed=true`；逐题非空网表大小 2,346–12,560 字节（counter 5,445 字节），所有对应仿真日志含 `TEST_PASS`，综合日志未检出 `ERROR`。首轮 counter 超时历史仍保存在 `outputs/batch/counter_001/20260921_161346/`，未伪装成成功。
- 纯 Python：6 个 unittest 覆盖 schema、分类、超时、缺工具、中文/空格路径、重复不覆盖、摘要上限、CLI/API 字段及综合相对路径参数，均通过。`python -m compileall -q tools tests` 通过。

## 10. 未解决问题和风险

- 首轮 counter 批量综合跨越约五小时后被记为 timeout，疑似机器休眠/恢复或进程环境中断；独立补跑 116 秒通过。该历史失败未删除。当前机器还有一个开工前已存在的 Vivado 进程；综合内存/时长可能波动，单阶段默认 300 秒。未终止或改动该进程。
- 中文 cwd/source 会令本机 Vivado 综合异常退出，已用临时 ASCII 逐字节暂存绕开，仍需其他机器复核。多文件 include/IP、timing closure、形式等价、最终赛题评测版本均不在本工具覆盖内。
- 日志 regex 分类有盲区；未识别的具体原因需读原始日志。关键结构 critical warning 已作为质量门槛；普通 warning 不自动伪装成失败。

## 11. 队友拿到后的下一步

队友三首条可复制命令（从项目根，先用已知 reference 联调接口）：

```powershell
python tools/validate_rtl.py --source demo_tasks/counter/reference.v --testbench demo_tasks/counter/tb_counter.sv --top counter --part xczu3eg-sbva484-1-e --clock-period 5.0 --output-dir outputs/team3_smoke
```

队友二首条可复制命令（只读取公开元数据，不接触私有实现）：

```powershell
python -c "import json; x=json.load(open('demo_tasks/counter/task.json',encoding='utf-8')); print(x['description']); print(x['top_module'])"
```

首次联调顺序：公开 task.json 确定接口 → 队友三保存候选并运行同一 CLI → 核对退出码和 result.json → 队友二仅用摘要与候选片段修复 → 队友三另建 attempt 并选择最终版本。

## 12. 2026-09-22 综合路径故障复核

- 2026-09-21 的 `parameterized_adder_001/20260921_215022` 和 `priority_encoder_001/20260921_215222` 历史日志均显示 `SYNTH_DESIGN_SUCCESS` 后出现 `ERROR: [Common 17-354] Could not open 'C' for writing`。这是 Vivado 处理带盘符 Tcl 路径参数时的工具调用问题证据，不是两题 RTL 的功能或可综合性报错；原结果与日志保留不改。
- 排查时当前 `validator_api.py`、`synth.tcl` 已采用私有 ASCII 工作区和相对 Tcl 参数（含 `NO_CONSTRAINTS` 占位），并已有相应 Python 回归测试；本次未覆盖这些现存修改。
- 使用当前代码分别真实复测两题，结果在 `outputs/diagnostics/20260922_parameterized_adder/`、`outputs/diagnostics/20260922_priority_encoder/`，均四阶段通过。随后从 `E:\fpga` 使用 Python 3.12 完整执行 `tools/run_all_tasks.py --tasks-dir ... --implementation reference`，退出码 0；`reports/validation_summary.json` 为十题 10/10、`all_passed=true`。十份最新 `result.json` 均为 `stage=complete`，各有非空网表，综合日志均无 `ERROR:`。`python -m unittest discover -s tests -v` 为 6/6 通过。

## 13. 2026-09-22 Phase 2: feedback quality and integration readiness

- Scope: only validator feedback, parser tests, three representative private testbenches, fixtures and reports changed. No model/agent-side files changed, and no historical output/log/result.json/netlist was deleted or overwritten.
- `tools/log_parser.py` now gives structured `TB_FAIL kind/case/cycle` priority. The simulation order is structured kind, timeout, X/Z, explicit latency evidence, explicit reset evidence, then `functional_mismatch`. Legacy `reset behavior` wording alone no longer overrides a normal `rst=0` mismatch.
- Vivado paths in diagnostics are mapped from staged `source.v/source.sv` to the original candidate. Candidate summaries include the real source line plus up to two surrounding lines; testbench locations are labeled validation-environment/testbench. Unknown locations explicitly say `位置未知`. Summaries remain at the schema 1.0 limit of 1000 characters.
- The counter, shift-register and sequence-detector benches retain machine-readable `TB_FAIL` fields for kind, case, cycle, inputs, expected and actual; drives occur on negedge and checks after the following posedge/NBA update. `TEST_PASS` and watchdog nonzero failure behavior remain unchanged.
- Python regression: `python -m unittest discover -s tests -v` is 12/12 on 2026-09-22. Fixtures under `tests/fixtures/vivado/` are copies of real 2026-09-21 runs, named by source run; originals remain untouched.
- Fresh Vivado 2026.1 evidence: syntax error correctly summarizes the original candidate `missing_semicolon.v:4` and code context at `outputs/phase2_vivado_20260922/counter_syntax_retry_run_20260922_221708_44f963f8/`; a missing top is `elaborate/module_not_found` at `outputs/phase2_vivado_20260922/counter_top_module_not_found_final_run_20260922_223106_06dda91f/`; width warning remains in `warnings` without being converted into a compile failure.
- Fresh reference, reset, width, shift-register and sequence-detector simulation attempts are blocked on this machine by xsim digital-signature verification error `-2146762486`. The validator records this as `simulation/unknown_error`, summary says `no candidate RTL evidence`, and CLI exits 2 so team three does not route it to team two as a repair task. These runs are preserved under `outputs/phase2_vivado_20260922/`.
- The latest completed full reference batch before that machine environment regression remains the 2026-09-22 10/10 `reports/validation_summary.json`. A new complete batch run was not claimed because required phase-2 simulation checks could not complete in the current xsim environment.
- Team two examples: `reports/feedback_examples.md`. Team three interface is unchanged: `tools/validate_rtl.py`, exit code, and schema-1.0 `result.json`.
- Remaining limits: without structured TB_FAIL or a reliable diagnostic location, root cause is intentionally not over-classified; latency cannot be inferred from one numerical mismatch. Revalidate all phase-2 cases and the full ten-reference batch in official Vivado/Vitis 2025.2 after restoring the simulator certificate/environment.
