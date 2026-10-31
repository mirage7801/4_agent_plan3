# Analyst 实施建议合同与验收（2026-10-29）

工程：`D:/AMD/4_agent_plan3`。本次只调整分析职责、合同、来源接纳及实际消费；不新增Agent、风险路由、调度器或模型调用。首次分析条件仍为max_model_calls>1，分析及重分析均不做协议重试。单次输出8912、请求超时300秒、独立后端收尾120秒保持一致。

## 交付目标

Analyst负责发现会改变RTL实现的周期/状态关系、竞争条件优先级、边界和有区分价值的短例子；不复述全题、不替代冻结接口、不按难度评分。没有发现时返回空数组，避免凑分析。

初始输出：

```text
<answer>
{
  "implementation_notes": [
    {
      "statement": "复位与使能同时有效时，复位优先。",
      "requirement_refs": ["R0012"],
      "source_quote": "Reset takes priority over enable.",
      "basis": "explicit",
      "example": {"given": "reset=1, enable=1", "expected": "下一状态为0"}
    }
  ],
  "ambiguities": []
}
</answer>
```

这是结构示例，实际引用编号、内容、预期值必须来自当前题目。basis允许explicit或inferred；example可省略，包含时given/expected都必填。最多16条建议、8条歧义。歧义每项必含question、implementation_impact、requirement_refs、source_quote，只记录影响实现且来源未解决的问题。歧义不会触发用户问答或自动阻塞生成，也不授权补需求。

重分析输出同样两个数组，另外必含reassessment：prior_interpretation、feedback_observation、evidence_sufficient（布尔）、interpretation_change、next_attempt_change。证据不足时明确false和不确定性，不能从累计mismatch猜根因。新策略名称不能替代解释变化。JSON严格闭合，禁止额外字段；标签边界仍统一使用model/framing.py。

## 来源与语义边界

1. schemas.py先验证整个结构；缺必需字段、错误类型、重复键或非法最终区域拒绝整份响应，使用已有冻结事实继续。不会自动重新调用Analyst。
2. task_facts.build_derived逐项检查编号与连续来源引文，仅允许空白差异。未知编号或不匹配引文只拒绝该条；其他合法条目保留。原始文本不修改。
3. 引文匹配只标source_check=exact_source_match/source_match_whitespace_normalized；statement、basis声明、推理及example均保持semantic_status=unverified。真实引用不证明其语义推论。没有新增“模型审核模型”的认证调用。
4. rejection保存collection/index/reason，原始内容留在answer.json和call审计；StageContext不将拒绝内容或拒绝元数据传给后续模型。
5. Synthesizer/Repairer使用相关建议；Reviewer只能结合原题和候选提出缺陷，不能因候选与Analyst例子不符就判错。例子不转为强制测试。

已知限制：程序不能通用证明自然语言蕴含关系，因此一条引用真实、结论错误的建议仍可能进入模型。unverified及原题优先规则降低误用，不能保证避免误导；收益必须通过对照实验验证。

## 合同与路径

- Analyst模型输出移除risk、derivations、unresolved_questions、task_profile；不保留旧字段转换或生产兼容别名。
- derived_spec内部schema_version从2.0升为3.0，包含facts_ref、derived_version、implementation_notes、ambiguities、reassessment（首次为null）、rejected及程序独立计算的task_profile。
- 删除旧verified/hypotheses/profile_proposal_audit/profile_proposals_status/risk等派生字段及task_profile.audit_profile_proposals；程序profile、applicable_checks和资源准入仍使用原来独立路径。
- task_facts仍2.0（其接口解析unresolved_questions是程序字段，保留），LLM信封/handoff仍2.0，外部EDA/report仍1.0。同日Reviewer改造已删除其risk，当前审查合同见[Reviewer改造](reviewer-contract-20261029.md)。
- 仍保存derived_spec.v1.json、derived_spec.v2.json、context/analyst_response、context/contract_rebuild/analyst_response；文件名中的vN是任务内派生版本，不是schema版本。
- 原始模型答案answer.json结构合法不等于条目来源或语义已通过。消费端只读取经过build_derived的派生结果；不扫描audit目录。
- config/mock.e2e.json与测试生产者同步新格式。历史runs/reports/logs和旧证据不改写；历史旧合同不能直接作为本版新模型输出。

## 实际执行链

```text
run.ps1 / run.sh / run_closed_loop.ps1
  → agent.cli
  → agent.runtime.run.run_task
  → CandidateSearchRunner [唯一Controller]
  → StageContext.render(analyst) + stage_instruction(analyst)
  → _generate_stage → execute_call → HttpModelClient → HTTP
  → parse_json_answer [Analyst结构合同]
  → build_derived [逐项来源接纳]
  → derived_spec.v1.json
  → StageContext.render(synthesizer / reviewer / repairer)
```

workers模式只增加runtime.worker_boundary→worker_cli，仍执行同一个execute_call，不回退到旧角色目录。

最后重建时，Controller从不可变失败Revision提取previous_attempt（revision_id、source_hash、candidate），连同安全反馈和该候选绑定的旧分析装配输入；StageContext核对源码哈希。execute_call从Controller装配的STAGE_DELTA选择严格Rebuild合同，缺reassessment整体失败并回退。成功则产生新derived_spec.v2，下一次生成会收到解释变化和证据限制；其他候选仍绑定自己的v1。

## 验证与复现

```powershell
Set-Location D:/AMD/4_agent_plan3
$env:PYTHONDONTWRITEBYTECODE='1'
python -B -m unittest tests.test_analyst tests.test_policy_http_chain tests.test_pipeline tests.test_output_protocol -v
python -B -m unittest discover -s tests -v
```

test_analyst验证严格结构、逐项来源拒绝、真实引文不证明结论、空分析、歧义、例子及下游可见性、重分析候选哈希和实际execute_call合同选择。

test_policy_http_chain从真实CLI启动in_process与workers，通过本地HTTP捕获9次实际请求：Analyst1、Synthesizer3、Reviewer2、Repairer2、Rebuild1。服务返回非空建议/例子/歧义及坏引文，断言所有下游收到合法内容，拒绝内容不泄漏；重分析输入的源码哈希正确，新生成收到reassessment。此验证检查实际请求内容，不只版本字符串。test_pipeline继续验证实际CLI/HTTP/独立假验证进程的重叠、预算、绑定和自然收尾。

这些验收使用本地HTTP替身、Mock EDA或独立假验证器，不是远端GPU大模型/Vivado实测；不能据此宣称难题正确率或墙钟提高。首次分析是否划算需在相同模型/预算/验证条件下，对比跳过Analyst与启用本版Analyst，记录正确率、总墙钟和首次有效RTL时间，有随机性时重复试验。当前不新增未经验证的自动路由。

隔离副本全量回归：175/175通过；当前mock.e2e.json实际CLI完成分析→代码→修复三次请求并成功，derived_spec为3.0。安装后的原目录导入、实际HTTP角色链及配置校验另存本机plan3_analyst_evidence_20261029/target，不能用暂存路径冒充正式入口。

未来做Analyst消融时必须保持相同总预算和后续策略，不能用max_model_calls=1跳过分析后宣称公平对比。
