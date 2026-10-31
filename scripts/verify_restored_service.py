"""等待模型就绪、验证真实生成，并写出与实际服务一致的配置。"""
import json
import os
import time
import urllib.request
from pathlib import Path

url = "http://127.0.0.1:8000"
for attempt in range(120):
    try:
        with urllib.request.urlopen(url + "/health", timeout=5) as response:
            health = json.load(response)
        assert health["status"] == "ready"
        assert health["model"] == "Qwen/Qwen2.5-Coder-7B-Instruct"
        break
    except Exception:
        if attempt == 119:
            raise RuntimeError("Service not ready; inspect runtime/model-service.log")
        time.sleep(5)
request = urllib.request.Request(url + "/generate", data=json.dumps({
    "prompt": "Write a Verilog module named passthrough with input wire a and output wire y. Assign y=a. Return code only.",
    "max_tokens": 128, "temperature": 0.0,
    "model": health["model"], "revision": health["revision"]
}).encode(), headers={"Content-Type": "application/json"})
with urllib.request.urlopen(request, timeout=180) as response:
    result = json.load(response)
assert result.get("text", "").strip(), "Empty generation"
assert "module" in result["text"] and "endmodule" in result["text"], "Missing Verilog module"
Path("runtime").mkdir(exist_ok=True)
Path("runtime/recovery-smoke.json").write_text(json.dumps({"health": health, "generation": result}, indent=2), encoding="utf-8")
config = json.loads(Path("config/amd-rocm.local.json").read_text(encoding="utf-8")) if Path("config/amd-rocm.local.json").exists() else json.loads(Path("config/qwen25_coder7b_rocm.json").read_text(encoding="utf-8"))
config["model"].update(service_type="http", url=url + "/generate", id=health["model"], revision=health["revision"])
config["eda"]["python_executable"] = os.environ.get("BASE_PYTHON", "/opt/venv/bin/python")
Path("config/amd-rocm.local.json").write_text(json.dumps(config, indent=2), encoding="utf-8")
print("Health + real generation passed; config/amd-rocm.local.json updated. EDA assets/Vivado require separate setup.")
