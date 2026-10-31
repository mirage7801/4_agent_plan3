"""Endpoint lease and durable recovery of timed-out remote generation.

The OS lock is released on process exit; the pending request survives it.
No response generated after a timeout is recovered as an answer.
"""
import hashlib
import json
import os
from pathlib import Path
import tempfile
import time
import urllib.error
import urllib.request
import urllib.parse

from model.contracts import ModelClientError


DEFAULT_DRAIN = {"max_wait_seconds":120.0, "poll_interval_seconds":2.0,
                 "status_timeout_seconds":5.0,
                 "state_root":str(Path(tempfile.gettempdir())/"rtl-agent-backend-state")}


def observation(request_id=None, state="not_observed", seconds=0.0, reason="response_received", server_state=None):
    return {"request_id":request_id,"backend_state":state,"backend_drain_seconds":round(seconds,6),
            "next_task_allowed":state!="unknown","reason":reason,"server_state":server_state,"request_elapsed_seconds":0.0,"previous_request_id":None}


class BackendStateError(ModelClientError):
    code="BACKEND_STATE_UNKNOWN"
    def __init__(self, message, backend):
        super().__init__(message)
        self.backend=backend


class BackendLease:
    def __init__(self, url, options=None):
        self.options={**DEFAULT_DRAIN,**(options or {})}
        root=Path(self.options["state_root"]);root.mkdir(parents=True,exist_ok=True)
        key=hashlib.sha256(url.encode()).hexdigest()
        self.path=root/(key+".json");self.lock_path=root/(key+".lock")
        parts=urllib.parse.urlsplit(url)
        self.status_base=urllib.parse.urlunsplit((parts.scheme,parts.netloc,parts.path.rsplit('/',1)[0]+"/requests/","",""))
        self.backend=observation();self.handle=None

    def __enter__(self):
        self.handle=self.lock_path.open('a+b')
        self.handle.seek(0,2)
        if self.handle.tell()==0:self.handle.write(b'0');self.handle.flush()
        started=time.monotonic();deadline=started+self.options['max_wait_seconds']
        while True:
            try:
                self.handle.seek(0)
                if os.name=='nt':
                    import msvcrt
                    msvcrt.locking(self.handle.fileno(),msvcrt.LK_NBLCK,1)
                else:
                    import fcntl
                    fcntl.flock(self.handle.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
                break
            except OSError:
                if time.monotonic()>=deadline:
                    self.handle.close();self.handle=None
                    raise BackendStateError('another client still owns this model endpoint',observation(state='unknown',seconds=time.monotonic()-started,reason='endpoint_lease_timeout'))
                time.sleep(min(self.options['poll_interval_seconds'],max(0,deadline-time.monotonic())))
        try:
            if self.path.exists():
                try:
                    value=json.loads(self.path.read_text(encoding='utf-8'));rid=value['request_id']
                    if not isinstance(rid,str) or not rid:raise ValueError('invalid request identifier')
                except (OSError,ValueError,KeyError,TypeError):
                    raise BackendStateError('pending backend record is unreadable; no request dispatched',observation(state='unknown',reason='invalid_pending_record'))
                self.wait(rid,deadline=deadline)
                if not self.backend['next_task_allowed']:
                    raise BackendStateError('previous backend request has not been confirmed finished; no request dispatched',self.backend)
            self.backend['backend_drain_seconds']=round(time.monotonic()-started,6) if self.backend['backend_state']=='idle_confirmed' else 0.0
            return self
        except BaseException:
            self.__exit__(None,None,None);raise

    def __exit__(self,*args):
        if self.handle is not None:
            self.handle.seek(0)
            if os.name=='nt':
                import msvcrt
                msvcrt.locking(self.handle.fileno(),msvcrt.LK_UNLCK,1)
            else:
                import fcntl
                fcntl.flock(self.handle.fileno(),fcntl.LOCK_UN)
            self.handle.close();self.handle=None

    def begin(self, request_id):
        # Replace atomically; a killed process leaves an explicit unresolved ID.
        temp=self.path.with_suffix('.tmp')
        temp.write_text(json.dumps({'request_id':request_id}),encoding='utf-8')
        temp.replace(self.path)

    def clear(self):
        self.path.unlink(missing_ok=True)

    def wait(self, request_id, *, deadline=None):
        started=time.monotonic()
        deadline=deadline if deadline is not None else started+self.options['max_wait_seconds']
        reason='status_unavailable';server_state=None
        while time.monotonic()<deadline:
            remaining=deadline-time.monotonic()
            try:
                req=urllib.request.Request(self.status_base+urllib.parse.quote(request_id,safe=''),headers={'Accept':'application/json'})
                with urllib.request.urlopen(req,timeout=min(self.options['status_timeout_seconds'],remaining)) as response:
                    value=json.loads(response.read().decode('utf-8'))
                if not isinstance(value,dict) or value.get('request_id')!=request_id:
                    reason='status_identity_mismatch'
                else:
                    server_state=value.get('state') if value.get('state') in {'running','completed','failed','rejected','unknown'} else None
                    reason='task_not_finished_or_service_busy'
                    if server_state in {'completed','failed','rejected'} and value.get('busy') is False:
                        self.backend=observation(request_id,'idle_confirmed',time.monotonic()-started,'task_finished_and_slot_released',server_state)
                        self.clear();return self.backend
            except urllib.error.HTTPError as exc:
                if exc.code in {404,405}:
                    reason="status_endpoint_unsupported"
                    break
                reason="status_unavailable"
            except (OSError,ValueError,TypeError):
                reason='status_unavailable'
            time.sleep(min(self.options['poll_interval_seconds'],max(0,deadline-time.monotonic())))
        self.backend=observation(request_id,'unknown',time.monotonic()-started,reason,server_state)
        return self.backend


def backend_summary(calls):
    values=[c['backend'] for c in calls if c.get('backend')]
    missing_timeout=any(c.get('generation',{}).get('finish_reason')=='timeout' and not c.get('backend') for c in calls)
    missing_worker=any(str((c['error'] if isinstance(c.get('error'),dict) else {}).get('code','')).startswith('WORKER_') and not c.get('backend') for c in calls)
    unknown=missing_timeout or missing_worker or any(not v['next_task_allowed'] for v in values)
    return {'backend_state':'unknown' if unknown else 'idle_confirmed' if any(v['backend_state']=='idle_confirmed' for v in values) else 'not_observed',
            'backend_drain_seconds':round(sum(v['backend_drain_seconds'] for v in values),6),
            'next_task_allowed':not unknown,
            'model_request_seconds':round(sum(c.get('backend',{}).get('request_elapsed_seconds',c.get('elapsed_seconds',0.0)) for c in calls),6)}
