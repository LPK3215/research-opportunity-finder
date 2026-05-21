# Step 1: 场景校验

## 角色

你要验证 Step 0 形成的 research question 是否对应真实、活跃的科研场景。

本步骤不判断创新性，只防止空泛或虚构方向进入后续流程。

## 输入

使用 Step 0 handoff：

```json
{
  "research_question": "...",
  "domain": "...",
  "method_or_object": "...",
  "candidate_scene": "..."
}
```

## 需要检索的证据

对每个候选场景检索：

1. 近 3 年 survey 或 review
2. benchmark、dataset、task、leaderboard 或共享评估协议
3. workshop、challenge、special issue 或顶会/顶刊论文
4. 相关开源项目或活跃社区

记录查询词、来源名称和具体证据。

## 证据评级

| 等级 | 含义 |
|------|------|
| Strong | 有 survey/review + benchmark/dataset + 顶会或活跃社区证据 |
| Medium | 至少两类证据，但覆盖不完整 |
| Weak | 只有零散论文或间接证据 |
| None | 未找到直接证据 |

## 输出格式

```markdown
## Step 1 Output: Scene Validation

### Candidate Scene: [name]

| Evidence type | Findings | Source / query |
|---------------|----------|----------------|
| Survey/review | ... | ... |
| Benchmark/data | ... | ... |
| Venue/community | ... | ... |

**Evidence rating**: Strong / Medium / Weak / None
**Decision**: Proceed / Ask user / Terminate
```

Handoff block:

```json
{
  "step": 1,
  "status": "proceed|pause|terminate",
  "data": {
    "scene": "...",
    "research_question": "...",
    "evidence_rating": "strong|medium|weak|none",
    "evidence_items": [],
    "failed_searches": []
  },
  "warnings": [],
  "next_step": "step-2-literature-miner|user_choice|stop"
}
```

## 分支规则

- 所有场景均为 `none`：终止，并说明未找到有效科研场景
- 证据较弱：暂停，询问是否拓宽或调整场景
- 多个强证据场景并存：暂停，请用户选择
- 一个场景明显最强：进入 Step 2
- 无法检索：暂停，向用户索要论文、survey、benchmark 页面或检索权限

## 约束

- 不把泛泛相邻论文当作直接场景证据
- 不编造 benchmark、会议或数据集名称
- 保留失败检索记录，负证据也有价值
- 区分证据和解释
