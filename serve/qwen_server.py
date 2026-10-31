"""ROCm-backed JSON model service for the local RTL agent's HTTP contract."""

from __future__ import annotations

import gc
import os
import time
from contextlib import asynccontextmanager
from pathlib import Path
import re
import uuid

from serve.request_state import RequestRegistry

import torch
from fastapi import FastAPI, HTTPException, Header
from pydantic import BaseModel, Field
from transformers import AutoModelForCausalLM, AutoTokenizer


MODEL_ID = "Qwen/Qwen2.5-Coder-7B-Instruct"
MODEL_DIR = Path(os.environ.get("MODEL_DIR", "/workspace/rtl-model/models/Qwen2.5-Coder-7B-Instruct"))
REVISION = os.environ.get("MODEL_REVISION", "local-unpinned")
CONTEXT_LENGTH = int(os.environ.get("MODEL_CONTEXT_LENGTH", "32768"))
_state: dict[str, object] = {}
_requests = RequestRegistry()


@asynccontextmanager
async def lifespan(_app: FastAPI):
    if not torch.version.hip or not torch.cuda.is_available():
        raise RuntimeError("ROCm PyTorch and an available GPU are required")
    if not MODEL_DIR.is_dir():
        raise RuntimeError(f"Model directory is missing: {MODEL_DIR}")
    print(f"Loading {MODEL_ID} from {MODEL_DIR}", flush=True)
    tokenizer = AutoTokenizer.from_pretrained(MODEL_DIR, local_files_only=True)
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_DIR,
        local_files_only=True,
        torch_dtype=torch.bfloat16,
        device_map={"": 0},
        attn_implementation="sdpa",
    ).eval()
    if CONTEXT_LENGTH > model.config.max_position_embeddings:
        raise RuntimeError("MODEL_CONTEXT_LENGTH exceeds loaded model position limit")
    _state.update(tokenizer=tokenizer, model=model)
    print(f"Model ready on {torch.cuda.get_device_name(0)}", flush=True)
    try:
        yield
    finally:
        _state.clear()


app = FastAPI(lifespan=lifespan)


class GenerateRequest(BaseModel):
    prompt: str = Field(min_length=1)
    max_tokens: int = Field(default=8912, ge=1, le=8912)
    temperature: float = Field(default=0.0, ge=0, allow_inf_nan=False)
    model: str | None = None
    revision: str | None = None


@app.get("/health")
def health():
    return {
        "status": "ready",
        "model": MODEL_ID,
        "revision": REVISION,
        "gpu": torch.cuda.get_device_name(0),
        "rocm": torch.version.hip,
        "torch": torch.__version__,
        "dtype": "bfloat16",
        "context_length": CONTEXT_LENGTH,
        "max_tokens_limit": 8912,
        "busy": _requests.busy(),
        "request_status_protocol": "rtl-request-v1",
        "token_count_protocol": "rtl-tokenize-v1",
    }


@app.get("/requests/{request_id}")
def request_status(request_id: str):
    return _requests.status(request_id)


def prompt_inputs(prompt):
    tokenizer = _state["tokenizer"]
    formatted = tokenizer.apply_chat_template(
        [{"role":"user","content":prompt}], tokenize=False, add_generation_prompt=True)
    return tokenizer(formatted, return_tensors="pt", add_special_tokens=False)


class TokenCountRequest(BaseModel):
    prompt: str = Field(min_length=1)
    model: str | None = None
    revision: str | None = None


@app.post("/tokenize")
def tokenize(req: TokenCountRequest):
    if req.model != MODEL_ID or req.revision != REVISION:
        raise HTTPException(400, "Tokenizer model/revision mismatch")
    inputs = prompt_inputs(req.prompt)
    return {"exact":True,"input_tokens":inputs["input_ids"].shape[1],
            "context_length":CONTEXT_LENGTH,"model":MODEL_ID,"revision":REVISION}


@app.post("/generate")
def generate(req: GenerateRequest, x_request_id: str | None = Header(default=None)):
    if req.model and req.model != MODEL_ID:
        raise HTTPException(400, "Model ID does not match the loaded model")
    if req.revision and req.revision != REVISION:
        raise HTTPException(400, "Revision does not match the loaded model")
    request_id=x_request_id or uuid.uuid4().hex
    if not re.fullmatch(r"[A-Za-z0-9_.-]{1,128}",request_id):
        raise HTTPException(400,"Invalid request identifier")
    admission=_requests.begin(request_id)
    if admission=="duplicate":raise HTTPException(409,"Request identifier already exists")
    if admission=="busy":raise HTTPException(429,"Model is busy")
    outcome="failed"
    started = time.perf_counter()
    try:
        tokenizer = _state["tokenizer"]
        model = _state["model"]
        inputs = prompt_inputs(req.prompt)
        input_tokens = inputs["input_ids"].shape[1]
        if input_tokens + req.max_tokens > CONTEXT_LENGTH:
            raise HTTPException(400, "Prompt plus max_tokens exceeds context_length")
        inputs = inputs.to("cuda:0")
        options = {
            "max_new_tokens": req.max_tokens,
            "do_sample": req.temperature > 0,
            "pad_token_id": tokenizer.eos_token_id,
        }
        if req.temperature > 0:
            options["temperature"] = req.temperature
        torch.cuda.reset_peak_memory_stats()
        with torch.inference_mode():
            output = model.generate(**inputs, **options)
        tokens = output[0, input_tokens:]
        text = tokenizer.decode(tokens, skip_special_tokens=True)
        torch.cuda.synchronize()
        eos_ids=model.generation_config.eos_token_id
        eos_ids=eos_ids if isinstance(eos_ids,list) else [eos_ids]
        ended_eos=bool(tokens.numel() and int(tokens[-1]) in eos_ids)
        finish_reason="eos" if ended_eos else "length" if tokens.numel() >= req.max_tokens else "unknown"
        outcome="completed"
        return {
            "request_id":request_id,
            "finish_reason": finish_reason,
            "requested_max_tokens": req.max_tokens,
            "text": text,
            "model": MODEL_ID,
            "revision": REVISION,
            "input_tokens": input_tokens,
            "output_tokens": tokens.numel(),
            "elapsed_seconds": round(time.perf_counter() - started, 3),
            "peak_vram_gib": round(torch.cuda.max_memory_allocated() / 1024**3, 3),
        }
    except torch.OutOfMemoryError as exc:
        gc.collect()
        torch.cuda.empty_cache()
        raise HTTPException(503, "GPU out of memory") from exc
    finally:
        try:
            torch.cuda.synchronize()
        except Exception as exc:
            _requests.finish(request_id,"unknown")
            raise HTTPException(503,"GPU completion could not be confirmed") from exc
        else:
            _requests.finish(request_id,outcome)
