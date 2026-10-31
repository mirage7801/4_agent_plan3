"""Sequential task launcher. Exit 3 is an unresolved backend barrier."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import uuid

ROOT=Path(__file__).resolve().parents[1]


def main():
    p=argparse.ArgumentParser()
    p.add_argument('--problems',nargs='+',required=True)
    p.add_argument('--config',required=True)
    p.add_argument('--output',required=True)
    p.add_argument('--mode',choices=['agent','baseline'],default='agent')
    args=p.parse_args()
    root=Path(args.output).resolve()/('batch_'+uuid.uuid4().hex[:12]);root.mkdir(parents=True)
    results=[];exit_code=0
    for index,problem in enumerate(args.problems,1):
        proc=subprocess.run([sys.executable,'-B','-m',args.mode+'.cli','run','--problem',str(Path(problem).resolve()),'--config',str(Path(args.config).resolve()),'--output',str(root),'--run-id',f'task_{index:04d}'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8',errors='replace')
        try:value=json.loads(proc.stdout)
        except ValueError:value=None
        invalid=not isinstance(value,dict) or 'next_task_allowed' not in value
        if invalid:value={'error':'child did not return a result envelope'}
        results.append({'problem':str(Path(problem).resolve()),'exit_code':proc.returncode,'result':value})
        blocked=proc.returncode==3 or value.get('next_task_allowed') is False
        aborted=invalid or blocked or proc.returncode not in {0,1}
        summary={'tasks':results,'total_requested':len(args.problems),'completed':len(results),'remaining':args.problems[index:],'blocked':blocked,'aborted':aborted}
        (root/'batch_summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
        if aborted:
            exit_code=3 if blocked else 2;break
        if proc.returncode:exit_code=1
    print(json.dumps({'batch_dir':str(root),**summary},ensure_ascii=False))
    return exit_code


if __name__=='__main__':raise SystemExit(main())
