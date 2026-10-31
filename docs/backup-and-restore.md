# 临时 AMD 云机备份与恢复

代码、Skill、公开配置和恢复脚本保存 GitHub；私有实验结果只放 E 盘。模型权重不备份，重新下载。

## 新服务器一键恢复

使用提供 HIP PyTorch 的 AMD 镜像，在服务器终端运行（默认使用 `/opt/venv/bin/python`）：

```bash
git clone https://github.com/3125004494/fpga-rtl-agent.git /workspace/amd-rtl-agent-restored
cd /workspace/amd-rtl-agent-restored
bash scripts/restore_amd_rocm.sh
```

脚本先检查 GPU，再创建复用系统 PyTorch 的项目虚拟环境、安装服务依赖、下载 Qwen2.5-Coder-7B-Instruct、启动仅本机访问的 FastAPI，等待就绪并真实生成 Verilog。服务已健康时复用；设置 `HF_MODEL_REVISION` 时，只有 revision 相同的现有服务才会复用，否则会停止并要求人工检查，端口冲突也会报错，不终止未知进程。首次下载将解析指定提交（未指定时为 `main`）；原先 `sha256-*` 标签不是 Hugging Face 提交，不能用作下载版本。

可通过 `BASE_PYTHON`、`MODEL_DIR`、`HF_MODEL_REVISION` 环境变量定制。日志及 smoke 证据在 `runtime/`；实际服务版本写入 `config/amd-rocm.local.json`，其中 EDA Python 路径沿用 `BASE_PYTHON`。恢复不会自动安装 Vivado，也不会恢复私有 testbench/参考实现。EDA 路径、许可和题目需要单独配置。

## 本机备份分类

本机备份目录下的 `2026-10-05/`：`experiments/` 实验，`config/` 本机配置，`service/` 原始服务，`environment/` 依赖清单，`source/` 源码归档，`recovery/` 恢复说明和脚本，`SHA256SUMS.json` 文件校验。

复制实验回新服务器可用 scp -r -P 新端口 本地目录 root@新地址:/workspace/runs/。配置中的旧路径须重新检查；不要覆盖新脚本生成的模型版本。

## 验证边界

本次检查脚本 Bash/Python 语法、当前云机真实生成和本机备份文件逐个 SHA-256。全新 AMD 镜像的完整下载/安装/启动尚未执行，因此恢复验收待下次开机；平台镜像 PyTorch/ROCm 版本变化可能需要适配。队友本地 10 组 Vivado 结果尚未提供目录，不包含在本次备份。重要结果建议另存第二份。
