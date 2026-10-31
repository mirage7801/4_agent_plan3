#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export MODEL_DIR="${MODEL_DIR:-/workspace/rtl-model/models/Qwen2.5-Coder-7B-Instruct}"
BASE_PYTHON="${BASE_PYTHON:-/opt/venv/bin/python}"
export BASE_PYTHON
# AMD 镜像提供 HIP PyTorch；禁止用普通 pip torch 覆盖它。
"$BASE_PYTHON" -c 'import torch; assert torch.version.hip and torch.cuda.is_available(), "Require AMD ROCm PyTorch + GPU"'
if [ ! -x .venv-rocm/bin/python ]; then
  "$BASE_PYTHON" -m venv --system-site-packages .venv-rocm
fi
PYTHON="$PWD/.venv-rocm/bin/python"
"$PYTHON" -m pip install -r requirements-rocm.txt
mkdir -p runtime
# 已有端口先检查身份，避免覆盖或终止他人的服务。
if "$PYTHON" - <<'PY'
import urllib.request, json
try:
    h=json.load(urllib.request.urlopen('http://127.0.0.1:8000/health',timeout=5))
except Exception:
    raise SystemExit(1)
assert h['model']=='Qwen/Qwen2.5-Coder-7B-Instruct' and h['status']=='ready'
PY
then
  if [ -n "${HF_MODEL_REVISION:-}" ]; then
    "$PYTHON" - <<'PY'
import json
import os
import urllib.request

with urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=5) as response:
    revision = json.load(response)['revision']
if revision != os.environ['HF_MODEL_REVISION']:
    raise SystemExit('Existing Qwen service has a different revision; inspect port 8000 manually')
PY
  fi
  echo "Reuse ready Qwen service"
else
  "$PYTHON" - <<'PY'
import socket
s=socket.socket()
try: s.bind(('127.0.0.1',8000))
except OSError: raise SystemExit('Port 8000 occupied; inspect manually')
finally: s.close()
PY
  export MODEL_REVISION="$("$PYTHON" - <<'PY'
import os
from huggingface_hub import HfApi, snapshot_download
revision=HfApi().model_info('Qwen/Qwen2.5-Coder-7B-Instruct',revision=os.environ.get('HF_MODEL_REVISION','main')).sha
snapshot_download('Qwen/Qwen2.5-Coder-7B-Instruct',revision=revision,local_dir=os.environ['MODEL_DIR'])
print(revision)
PY
)"
  nohup "$PYTHON" -m uvicorn serve.qwen_server:app --host 127.0.0.1 --port 8000 --workers 1 > runtime/model-service.log 2>&1 &
  echo $! > runtime/model-service.pid
fi
"$PYTHON" scripts/verify_restored_service.py
