# 真实模型实验说明

早期固定配置为 `config/qwen25_coder7b_rocm.json`，Agent 与 Baseline 必须传入同一配置文件。该配置记录 Qwen2.5-Coder-7B-Instruct、历史服务文件指纹、`temperature=0`、`max_tokens=4096`、上下文上限 8192 和 180 秒请求超时；它不是 2026-10-07 十题或 2026-10-08 Gitee 运行的配置快照。新恢复的服务 revision 是实际 Hugging Face commit，必须先按 `/health` 返回值更新本机配置，否则 `/generate` 会返回 HTTP 400。

## 启动与校验

模型服务端启动（按服务器实际目录替换工作目录，不把私有路径写入仓库）：

```bash
/opt/venv/bin/python -m uvicorn qwen_server:app --host 127.0.0.1 --port 8000 --workers 1
curl http://127.0.0.1:8000/health
python scripts/check_weights.py /workspace/rtl-model/models/Qwen2.5-Coder-7B-Instruct --output weight-checksums.json
```

`weight-checksums.json` 应作为服务器侧证据保存；只把文件数量、大小和 SHA-256 摘要复制到实验记录，不提交权重。

## 公平对比

```powershell
python -m baseline.cli run --problem eda/rtl-agent/demo_tasks/counter --config config/qwen25_coder7b_rocm.json --output runs --run-id real_baseline_counter
python -m agent.cli run --problem eda/rtl-agent/demo_tasks/counter --config config/qwen25_coder7b_rocm.json --output runs --run-id real_agent_counter
```

每个运行目录保存 `config.snapshot.json`、`run_manifest.json`、每次 `prompt.txt`、`raw_response.txt`、`response.json`、提取后的 RTL 和 EDA 原始输出。比较时以相同题目、配置快照和模型调用参数为准。

## 异常与上下文矩阵

对 `/generate` 逐项记录：健康检查、正常请求、超时（客户端超时）、HTTP 400/500、服务停止后请求、重新启动后的健康检查与请求；上下文至少覆盖 128、2048、8192 输入 token，超过 8192 应得到 HTTP 400 或服务契约规定的明确错误。记录 UTC 时间、HTTP 状态、耗时和脱敏错误摘要，不记录令牌。

服务器当前不可达时，实验状态必须标记 `blocked_by_environment`，不得将 Mock 结果写成真实模型指标。
