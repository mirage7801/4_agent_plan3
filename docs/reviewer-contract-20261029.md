# Reviewer 针对性诊断合同与验收（2026-10-29）

工程：`D:/AMD/4_agent_plan3`。Reviewer定位原题与已失败候选之间可定位的矛盾，为Repairer提供未证明的缺陷假设。它不能代替验证器，也不能因为模型认为代码有错就判定验证结果。

## 调用与输入

沿用现有唯一CandidateSearchRunner：进入修复时，安全反馈缺少具体反例、且资源允许一次审查加一次修复，才调用Reviewer。明确结构类反馈或有具体反例时继续直接修复；不恢复所有候选的前置审查。Reviewer最多一次模型请求，不做协议重试，失败仍保留修复额度。已有超时/繁忙/未知后端停止屏障优先，不能借回退继续请求不确定的后端。

所有输入经StageContext装配：冻结原题与接口、该候选绑定的Analyst建议、候选完整源码、candidate_binding（revision_id/source_hash）、本次安全验证反馈evidence及辅助applicable_checks。Controller从不可变Revision和对应反馈队列取值；StageContext核对源码SHA-256。Repairer中的review绑定必须与当前candidate_binding完全相同，包括版本号，防止其他候选/修复版本的意见串入。

candidate_binding是候选身份，不等于context_binding的事实/派生版本绑定。模型不负责生成哈希。私有testbench、参考实现、约束内容与原始私有验证日志不进入模型；使用既有安全反馈投影，原始EDA结果保留。

## 模型输出

```text
<answer>
{
  "issues": [
    {
      "id": "I1",
      "requirement_refs": ["R0012"],
      "source_quote": "Reset takes priority over enable.",
      "candidate_location": {"start_line": 12, "end_line": 16},
      "candidate_excerpt": "对应行范围内逐字复制的代码片段",
      "trigger_condition": "reset和enable同时有效",
      "expected_behavior": "执行原题规定的复位行为",
      "predicted_behavior": "候选优先执行enable分支",
      "reasoning": "候选的enable分支先于reset分支"
    }
  ],
  "limitations": []
}
</answer>
```

这是结构示例，真实编号、源码片段和行为必须对应当前输入。issues最多4条，limitations最多3条，均允许空数组。每条issue的所有字段必填；limits用于说明证据不足，不要求凑问题。删除risk、required_checks，observed_behavior替换为predicted_behavior：模型阅读代码所得是推断，不能冒充执行观测。

提示词要求优先调查本次失败，说明原题要求、代码差异和区分条件；累计mismatch不能证明失败输入、周期、信号或根因，不得编造。applicable_checks是辅助提醒，不限制其他来源支持的语义审查；Analyst建议不能直接成为判错依据。不报告风格偏好、可选功能或泛泛潜在风险。

JSON与标签仍由同一model/framing.py和contracts/schemas.py定义，不新增解析器、容错旧格式或生产兼容别名。

## 接纳与使用边界

共享parse_json_answer只检查最终区域和闭合结构，移除不再使用的facts/candidate参数。坏JSON、错误字段类型、缺字段、超过条目上限等拒绝整份审查；不自动重新调用Reviewer。

filter_review逐条检查：

- requirement_refs存在，source_quote在连续引用原文中匹配，复用Analyst的仅空白归一化规则。
- 行号为候选的有效闭区间；candidate_excerpt只统一换行符，必须精确出现在该范围内，不归一化字符串内容、空格或运算符。
- 重复问题ID、空白行为字段和既有组合范围冲突分别记录拒绝原因。组合范围防护仍是保守文本规则，不是通用语义判定。

合法条目附程序字段source_check、candidate_check=exact_candidate_excerpt、semantic_status=unverified。source_check与candidate_check只核验来源和定位，不证明原题蕴含expected_behavior，不证明predicted_behavior，更不证明修复后正确。

已知边界保留为测试：原题y=a，正确候选assign y=a，Reviewer却要求a=1时y=0；即使来源和定位都匹配，该错误诊断仍可能进入候选意见，但必须保持unverified，不能被当成已证明缺陷。Repairer提示词要求结合原题评估，而不是盲从。此防护不能保证消除误导，真实收益需要对照实验。

程序区分：

| status | 含义 |
|---|---|
| findings_available | 有通过来源与定位检查的缺陷假设，尚未证明 |
| no_supported_findings | 审查响应成功，但为空或全部条目被拒绝；不表示代码正确 |
| unavailable | 未执行或调用/格式处理失败，没有可用审查 |

调用过Reviewer时在修复目录保存review.json；失败另存review_failure.json。review.json保留candidate_binding、issues、limitations和rejected_issues（index/id/reason）；拒绝内容留在原始call审计/answer.json，不混入接受条目。Repairer仅收到去除rejected_issues后的投影。意见与限制都是建议，不能修改任务事实。

## 清理与路径

复用现有6处生产模块：contracts/schemas.py，core/prompts.py、task_facts.py、stage_context.py、output_protocol.py，orchestration/candidate_search.py（部分修改跨这些现有职责；不另建角色包装）。未新增Agent、生产目录、调度框架或依赖。

删除required_checks合同/审核/执行路径和execute_review_checks函数；删除验证队列携带Reviewer结果的无用结构及review_checks.json产物。原接口/范围检查、语法前端和EDA执行路径仍保留。适用检查结构更名为APPLICABLE_CHECK，避免把提示清单叫做已执行检查。

实际链路：

```text
run.ps1 / run.sh / run_closed_loop.ps1
  → agent.cli → runtime.run.run_task
  → CandidateSearchRunner [唯一Controller]
  → 失败Revision + 对应安全反馈
  → StageContext(reviewer) → _generate_stage [单次]
  → execute_call → HttpModelClient → HTTP
  → 严格输出结构 → filter_review [逐条来源与定位]
  → StageContext(repairer) [核对同一候选绑定]
  → 生成修复RTL → 原预检 → 原EDA验证
```

workers只增加runtime.worker_boundary→worker_cli，仍调用同一execute_call与Controller。Reviewer结果不再传给验证队列作为检查请求。最终通过状态只来自原有验证链，不来自审查状态。

内部LLM/handoff仍2.0、外部EDA/report仍1.0、task_facts仍2.0、derived_spec仍3.0；Reviewer当前合同为issues/limitations，新运行拒绝旧risk/required_checks等字段。历史runs/reports/logs和日期验收成绩不迁移、不覆盖。全局8912输出、300秒请求超时、120秒后端独立收尾不变。

## 验收

```powershell
Set-Location D:/AMD/4_agent_plan3
$env:PYTHONDONTWRITEBYTECODE='1'
python -B -m unittest tests.test_reviewer tests.test_policy_http_chain tests.test_pipeline tests.test_output_protocol -v
python -B -m unittest discover -s tests -v
```

- test_reviewer：严格结构、4/3条目上限、逐项坏引用/行号/代码片段、代码空格与字符串保留、换行兼容、重复ID、三种状态、源码哈希和跨版本拒绝、真实引文不证明诊断、原接口检查保留。
- 两种模式的真实CLI/本地HTTP各执行五种情况：部分合法、空输出、格式失败、全部拒绝、修复后验证仍失败。每例必须只有一次Reviewer请求，四次模型调用、两次验证；即使配置允许协议重试，也不能重试Reviewer。
- test_policy_http_chain：每模式9次实际请求，非空Reviewer意见进入Repairer；绑定与持久化diagnosis的source_hash及不同失败摘要逐项对应，坏意见不泄漏；Analyst和重分析的新合同继续可用。
- test_pipeline：继续核对唯一控制器、模型/验证重叠、反馈版本、资源预留、停止派发和自然收尾，不能只检查版本字符串。

本地证据保存plan3_reviewer_evidence_20261029/staging与target；target记录必须来自D盘实际入口。以上使用本地模型服务替身和Mock EDA/独立假验证器，不是远端GPU推理或真实Vivado性能实验。未验证正确率或墙钟收益；后续做启用/跳过Reviewer对照时必须保持相同总预算和验证条件，不能靠减少另一组预算制造收益。

本次隔离副本全量回归190/190通过（193.230秒）。安装后还需在D盘原目录执行同套回归并核对实际导入路径及HTTP证据；暂存结果不冒充正式目录验收。

短原题边界：已接纳Reviewer条目的source_quote可能恰好等于整道短题，StageContext允许该必需引用进入Repairer；其他delta字段仍禁止复制整题，私有字段禁令不变。该例外有聚焦回归，不扩大到任意上下文。
