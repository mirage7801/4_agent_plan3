# Integration And Offline Use

## 接入队友二模型服务

在 `config/experiment.example.json` 填写：

- 本地服务 URL；
- 模型 ID 和固定 revision；
- 响应文本字段；
- 上下文长度、最大输出 token、temperature 和超时；
- 如服务需要额外非敏感字段，填写 `extra_request_fields`。

正式交付仍需队友二提供：受版本管理的服务启动/停止和健康检查命令、准确请求/响应示例、模型来源与上游 revision、许可证、上下文限制、ROCm 版本和启动方式、显存记录、建议超时以及断网权重挂载约定。2026-10-04 的仓库外 Qwen 试运行覆盖了部分字段，但不替代正式交付。任何令牌不得写入配置或仓库。

## 接入队友一验证器

设置 `eda.validator_root` 和 `eda.validator_entry`，保持现有 schema 1.0 和 CLI 不变。题目路径应指向包含公开 `task.txt/task.json` 与私有验证资产的队友一任务目录。编排器读取并原样记录验证器返回的 `vivado_version`。

当前 `config/experiment.example.json` 从 `config/` 解析到本项目的 `../eda/rtl-agent` 验证器，入口为 `tools/validate_rtl.py`；反馈策略由同一验证器目录下的 `tools/feedback_policy.py` 提供。stdout JSON、实际 `output_dir/result.json`、退出码和 `vivado_version` 均由适配器核对和记录。

联调报告位于 `reports/team1_validator_integration_20260927.md` 和 `.json`。本次模型仍是确定性 Mock，因此它证明验证器接线、反馈循环、Baseline 边界和记录结构，不代表真实模型质量。

## 2026-10-04 云模型 + 本机公开题 + Vivado 单题试运行

本机 Agent 通过通用 `HttpModelClient` 调用 AMD ROCm 云实例上的 Qwen2.5-Coder-7B-Instruct（BF16）。云服务仅监听实例 loopback；平台禁用 SSH TCP 转发，因此当前工作站的仓库外桥接通过 SSH 命令调用云端 `/generate`，没有开放公网模型端口。试运行使用现有、带口令的 SSH 私钥；本机临时密钥及云端对应公钥已移除。

公开 `counter_001` 的一次非 Mock Agent 运行首轮通过：模型生成 RTL，本机父目录权威 Vivado 2026.1 完成编译、详细描述、XSim 仿真和目标器件综合。题目私有 testbench、XDC 和参考实现未进入本次保存的模型提示词。报告见 `reports/cloud_qwen_counter_20261004.md`；本机原始证据在 Git 忽略的 `runs/cloud-qwen-counter-20261004/`。模型身份、文件指纹与运行参数见 `MODEL.md`。

本机 `config/cloud-qwen.local.json` 被 Git 忽略；桥接和历史云实例的服务源文件尚未纳入版本化交付。仓库现有的 `serve/qwen_server.py` 尚未与历史实例源码核对字节一致性。重跑前先验证当前云实例、模型 `/health`、本机桥接和现有私钥会话，不能假设旧实例地址或 `/workspace` 内容永久有效。

## 2026-10-04 历史十题配对实验

在同一模型配置和公开题集上执行了 Agent/Baseline 配对：Agent 首轮 4/10、有限修复后 5/10，Baseline 4/10；仅 `shift_register` 经修复通过，模型/环境失败均为 0。全部十对首轮提示词、模型配置段和提取 RTL 已逐对核对一致。原始摘要及逐例诊断留在本机，不随公开仓库发布。2026-10-05 只对 `sequence_detector` 做了新 Agent/Baseline 配对：多驱动 Skill 路由已生效，但模型仍返回与旧版相同的失败 RTL，两侧均未通过；新旧原始运行均保留，其余四题未复测。

## 2026-10-07 十题云复测

这次结果由两段真实运行组成，而不是一次十题单批次：模型为 `Qwen/Qwen2.5-Coder-7B-Instruct`，文件指纹为 `sha256-865a90daf5b81ddfcd6d940d990ce194368d08cffad0d9c8dfba679f25a7efc1`（它不是上游 commit/revision）；首批 `qwen-final` 批次通过 9/10，`priority_encoder` 的失败目录保留；随后独立提示词修复重试通过 `priority_encoder`。因此逐题累计最新证据为 10/10。十题最新 `final.json` 均记录 `mock=false`、`passed=true`、`stop_reason=success`，每个验证结果为 Vivado 2026.1 的编译、详细描述、仿真和综合完成。

仓库审阅入口为 `reports/qwen_repair_final_20261007.md` 和机器可读的 `reports/qwen_final_evidence_20261007.json`。完整原始日志、网表与命令记录保留在本机 Git 忽略的 `runs/` 中，旧 `qwen-repair*` 运行目录没有被覆盖。

## 2026-10-08 Gitee 公开示例题联调

`integrations/gitee_tasks/` 将三道公开题导入现有 TaskSpec，并使用原版 `tb.sv`、`ref.sv` 调用 Vivado 2026.1。模型提示只包含公开题面，参考实现和 testbench 留在验证 harness 中。`config/gitee.example.json` 的模型 temperature 为 0.0；`config/gitee.qwen.temperature02.json` 为第二题的复测配置，temperature 为 0.2。

三题各自最新的非 Mock Agent 运行均通过：`ex01_popcount8` 为 0/257 mismatch，`ex02_detect_1101` 的严格同步复位版本为 0/226，`ex03_lfsr8` 为 0/229，并完成 Vivado 综合。第二题经过四次模型调用；最初 temperature 0.0 的失败运行和一次不符合严格复位语义的通过运行保留为历史记录。报告见 `reports/gitee_qwen_cloud_20261008.md`；原始运行保留在本机 Git 忽略的 `runs/`。适配器参考实现链路及故意错误候选的自检见 `reports/gitee_tasks_validation_20261007.md`。当前服务报告 `revision=local-unpinned`，这些结果不能证明固定模型版本的重复性。

## Docker

当前 `Dockerfile` 是 Python/Mock 开发镜像，不包含 Vivado、ROCm 或模型权重，也不声明官方比赛镜像兼容性。

```bash
docker build -t fpga-rtl-agent-mock .
docker run --rm fpga-rtl-agent-mock
docker run --rm -v "$PWD/out:/out" fpga-rtl-agent-mock \
  python -m agent.cli run \
  --problem tests/fixtures/mock_counter \
  --config config/mock.e2e.json \
  --output /out
```

构建完全依赖本机已有/可获取的 `BASE_IMAGE`；断网运行不安装 Python 包。官方基础镜像发布后可用 `--build-arg BASE_IMAGE=...` 覆盖。

## 尚未证明

- 已记录 2026-10-04 一批十题配对，以及 2026-10-07 首批 9/10 加独立 `priority_encoder` 重试的 ROCm/BF16 真实模型结果；仍未证明通过率和 Agent 增益的重复性、修复策略普适性或稳定吞吐；
- 2026-10-08 Gitee 三题是不同温度配置下各自选定的成功运行，未验证固定上游模型 revision 或重复性；
- 未证明 32 GiB 显卡、官方比赛镜像或跨实例离线复现；
- Docker 若本机无引擎，只能记录“已编写、未实机验证”；
- Mock EDA 结果不代表 Vivado；2026-09-27 集成报告的生成侧仍为 Mock，2026-10-04 单题试运行的生成侧与 EDA 均为真实调用。
