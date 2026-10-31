"""Atomic single-generation slot and bounded, queryable request history."""
from collections import OrderedDict
from threading import Lock


class RequestRegistry:
    def __init__(self, history_limit=1024):
        self._lock=Lock();self._active=None;self._records=OrderedDict();self._limit=history_limit

    def begin(self, request_id):
        with self._lock:
            if request_id in self._records:return 'duplicate'
            if self._active is not None:
                self._records[request_id]='rejected';self._trim();return 'busy'
            self._active=request_id;self._records[request_id]='running';self._trim();return 'started'

    def finish(self, request_id, state):
        if state not in {'completed','failed','unknown'}:raise ValueError('invalid terminal state')
        with self._lock:
            if self._active!=request_id:raise ValueError('request does not own generation slot')
            self._records[request_id]=state
            # Unknown GPU state must keep admission closed.
            if state!='unknown':self._active=None

    def _trim(self):
        for key in list(self._records):
            if len(self._records)<=self._limit:break
            if key!=self._active:del self._records[key]

    def status(self, request_id):
        with self._lock:
            return {'request_id':request_id,'state':self._records.get(request_id,'unknown'),'busy':self._active is not None}

    def busy(self):
        with self._lock:return self._active is not None
