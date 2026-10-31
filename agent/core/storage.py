"""Immutable run directory allocation and atomic evidence writes."""

from __future__ import annotations

import json
import os
import subprocess
import tempfile
import time
import uuid
from pathlib import Path
from typing import Any


class StorageError(RuntimeError):
    """Run evidence cannot be safely stored."""


def utc_timestamp() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


def atomic_write_text(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    handle, temporary_name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    temporary = Path(temporary_name)
    try:
        with os.fdopen(handle, "w", encoding="utf-8", newline="") as stream:
            stream.write(value)
            stream.flush()
            os.fsync(stream.fileno())
        # Windows readers/antivirus can briefly hold a destination without
        # delete sharing. Keep the old complete file until replacement succeeds.
        for retry in range(8):
            try:
                os.replace(temporary, path)
                break
            except PermissionError:
                if os.name != "nt" or retry == 7:
                    raise
                time.sleep(0.005 * (retry + 1))
    finally:
        if temporary.exists():
            temporary.unlink()


def atomic_write_json(path: Path, value: Any) -> None:
    atomic_write_text(path, json.dumps(value, ensure_ascii=False, indent=2) + "\n")


class RuntimeIdentityError(StorageError):
    """Runtime source or effective public configuration changed after freezing."""
    code = "RUNTIME_IDENTITY_MISMATCH"


def _identity_hash(value):
    import hashlib
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()).hexdigest()


def source_identity(repository_root):
    """Explicit Python runtime roots; no runs, docs, caches, tests or secrets."""
    import hashlib
    root=Path(repository_root).resolve()
    files=[]
    for directory in ('agent','model','serve','config'):
        for path in sorted((root/directory).rglob('*.py')):
            if '__pycache__' in path.parts:continue
            if path.is_symlink() or not path.resolve().is_relative_to(root):
                raise RuntimeIdentityError('runtime source escapes project root')
            files.append({'path':path.relative_to(root).as_posix(),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    files.sort(key=lambda item:item['path'])
    if not files:raise RuntimeIdentityError('runtime source identity is empty')
    return {'scope':'agent,model,serve,config Python sources; embedded prompts included','files':files,'sha256':_identity_hash(files)}


def runtime_identity(config, repository_root=None):
    from config.loader import redacted_snapshot
    root=Path(repository_root) if repository_root is not None else Path(__file__).resolve().parents[2]
    source=source_identity(root)
    public_config=redacted_snapshot(config)
    # This boolean is an execution setting, not a credential despite its name.
    public_config['model']['token_count_preflight']=config['model']['token_count_preflight']
    return {'schema_version':'1.0','code':source,'config':{'sha256':_identity_hash(public_config),'scope':'expanded redacted effective configuration; secrets and internal keys excluded'},
            'git':code_version(root),'identity_id':_identity_hash({'code':source['sha256'],'config':_identity_hash(public_config)})}


def identity_binding(identity):
    return {'identity_id':identity['identity_id'],'code_hash':identity['code']['sha256'],'config_hash':identity['config']['sha256']}


def assert_runtime_identity(expected, config, repository_root=None):
    """Checked before dispatch, not a claim to lock files or loaded bytecode."""
    from config.loader import redacted_snapshot
    root=Path(repository_root) if repository_root is not None else Path(__file__).resolve().parents[2]
    public_config=redacted_snapshot(config)
    public_config['model']['token_count_preflight']=config['model']['token_count_preflight']
    code=source_identity(root)['sha256'];configuration=_identity_hash(public_config)
    actual={'identity_id':_identity_hash({'code':code,'config':configuration}),'code_hash':code,'config_hash':configuration}
    if actual!=expected:raise RuntimeIdentityError('runtime code/config identity differs from the frozen run; no new work dispatched')
    return actual


def code_version(repository_root: Path) -> str:
    try:
        completed = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=repository_root,
            capture_output=True,
            text=True,
            check=True,
            timeout=10,
        )
        revision = completed.stdout.strip()
        status = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=repository_root,
            capture_output=True,
            text=True,
            check=True,
            timeout=10,
        )
        return revision + ("+dirty" if status.stdout.strip() else "")
    except (OSError, subprocess.SubprocessError):
        return "unknown"


def reserve_run_directory(output_root: str | Path, requested_id: str | None = None) -> Path:
    root = Path(output_root).expanduser().resolve()
    if root.exists() and not root.is_dir():
        raise StorageError(f"output root is not a directory: {root}")
    try:
        root.mkdir(parents=True, exist_ok=True)
    except OSError as exc:
        raise StorageError(f"cannot create output root {root}: {exc}") from exc
    stem = requested_id or time.strftime("run_%Y%m%d_%H%M%S") + "_" + uuid.uuid4().hex[:8]
    for suffix in range(0, 1000):
        name = stem if suffix == 0 else f"{stem}_{suffix:02d}"
        candidate = root / name
        try:
            candidate.mkdir()
            return candidate
        except FileExistsError:
            continue
        except OSError as exc:
            raise StorageError(f"cannot create run directory {candidate}: {exc}") from exc
    raise StorageError(f"unable to reserve a unique run directory under {root}")


class RunStore:
    def __init__(self, run_dir: Path, mode: str):
        self.run_dir = run_dir
        self.mode = mode
        self.mode_dir = run_dir / mode
        self.mode_dir.mkdir()

    def initialize(
        self,
        config_snapshot: dict[str, Any],
        public_problem: dict[str, Any],
        manifest: dict[str, Any],
    ) -> None:
        atomic_write_json(self.run_dir / "config.snapshot.json", config_snapshot)
        atomic_write_json(self.run_dir / "public_problem.snapshot.json", public_problem)
        atomic_write_json(self.run_dir / "run_manifest.json", manifest)

    def attempt_directory(self, number: int) -> Path:
        path = self.mode_dir / f"attempt_{number:02d}"
        try:
            path.mkdir()
        except FileExistsError as exc:
            raise StorageError(f"attempt directory already exists: {path}") from exc
        return path

    def finish(self, final: dict[str, Any]) -> None:
        atomic_write_json(self.mode_dir / "final.json", final)
        summary = {
            "schema_version": "1.0",
            "mock": bool(final.get("mock")),
            "agent": final if self.mode in {"agent", "candidate_search"} else None,
            "candidate_search": final if self.mode == "candidate_search" else None,
            "baseline": final if self.mode == "baseline" else None,
        }
        atomic_write_json(self.run_dir / "summary.json", summary)
        manifest_path = self.run_dir / "run_manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        manifest.update(
            ended_at=final["ended_at"],
            wall_clock_seconds=final["wall_clock_seconds"],
            stop_reason=final["stop_reason"],
            passed=final["passed"],
        )
        atomic_write_json(manifest_path, manifest)


def append_event(path: Path, event: dict, *, durable=False):
    """Single Controller writer. Critical boundaries sync; ordinary appends flush."""
    path.parent.mkdir(parents=True,exist_ok=True)
    with path.open('a',encoding='utf-8',newline='') as stream:
        stream.write(json.dumps(event,ensure_ascii=False,separators=(',',':'))+'\n')
        stream.flush()
        if durable: os.fsync(stream.fileno())


def read_events(run_dir: Path):
    """Prefer live JSONL; tolerate only an incomplete final line, never midstream corruption."""
    path=Path(run_dir)/'pipeline_events.jsonl'
    if not path.exists():
        old=Path(run_dir)/'pipeline_events.json'
        return json.loads(old.read_text(encoding='utf-8')) if old.exists() else []
    lines=path.read_bytes().splitlines(keepends=True)
    events=[]
    for i,line in enumerate(lines):
        try: value=json.loads(line)
        except ValueError:
            if i==len(lines)-1 and not line.endswith(b'\n'): break
            raise StorageError('corrupt pipeline event record')
        if not isinstance(value,dict): raise StorageError('event must be an object')
        events.append(value)
    return events
