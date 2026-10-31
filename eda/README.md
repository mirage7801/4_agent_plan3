# eda

负责人：同学 B
职责：封装 Vivado 2026.1 编译、仿真、综合、超时控制和日志解析。

- 输入：标准题目描述、生成 RTL、输出目录。
- 必做：实现 `run_eda(problem, source, output_dir)`；目标器件 `xczu3eg-sbva484-1-e`；时钟约束 5 ns。
- 产出：`status.json`、编译日志、仿真日志、综合日志和必要中间证据。
- 验收：相同输入可重复运行，结构化状态与原始日志一致。
- 禁止：吞掉 ERROR、修改 testbench、仅凭文本启发式宣称仿真或综合通过。
