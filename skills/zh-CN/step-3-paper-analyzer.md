# Step 3: 论文拆解

## 角色

你要从 Step 2 的文献池中选择最重要的论文，并按四个维度拆解：

1. Problem
2. Methodology
3. Contribution
4. Unresolved issues

本步骤为 Step 4 的跨文献综合提供证据基础。

## 输入

使用 Step 2 handoff：

```json
{
  "scene": "...",
  "paper_pool": []
}
```

选择 4-6 篇论文做详细分析。优先选择 Q1 论文、强种子论文、benchmark 论文，以及代表不同范式的论文。

## 维度 1：Problem

回答：

- 论文处理什么任务或研究问题？
- 任务设定包含哪些假设？
- 作者声称前人工作的 gap 是什么？
- 使用了哪些 benchmark、dataset 或实验设定？

必填字段：

- Task
- Prior-work gap
- Scene relevance
- Evidence location if available

## 维度 2：Methodology

回答：

- 论文使用什么方法家族或范式？
- 核心机制是什么？
- 方法假设什么输入/输出形式？
- 和前人方法的主要区别是什么？

必填字段：

- Paradigm
- Core mechanism
- Required data / resources
- Relation to prior methods

## 维度 3：Contribution

回答：

- 作者明确声称了哪些贡献？
- 哪些实验结果支撑这些声明？
- 哪些声明支撑充分，哪些较弱？

必填字段：

- Author-claimed contributions
- Experimental support
- Scope of validity

## 维度 4：Unresolved Issues

这是最重要的维度。

必须区分：

### Author-stated limitations

只包含作者在 limitations、discussion、future work、conclusion 或 error analysis 中明确写出的局限。

必填字段：

- Limitation
- Evidence location
- Exact meaning

### Inferred gaps

只有存在完整推理链时，才写读者推断 gap。

必填字段：

- Inferred gap
- Reasoning chain
- Supporting observations
- Uncertainty level

不得混淆作者明示局限和推断 gap。

## 输出格式

```markdown
## Step 3 Output: Paper Analysis

### [Paper title]

| Field | Analysis |
|-------|----------|
| Problem | ... |
| Methodology | ... |
| Contribution | ... |

#### Unresolved Issues

**Author-stated**

| Issue | Evidence location | Notes |
|-------|-------------------|-------|
| ... | ... | ... |

**Inferred**

| Gap | Reasoning chain | Confidence |
|-----|-----------------|------------|
| ... | ... | Low/Medium/High |
```

Handoff block:

```json
{
  "step": 3,
  "status": "proceed|pause",
  "data": {
    "paper_cards": [],
    "author_stated_issues": [],
    "inferred_gaps": [],
    "access_limits": []
  },
  "warnings": [],
  "next_step": "step-4-cross-synthesizer|user_choice"
}
```

## 分支规则

- 如果少于 4 篇论文能被充分分析，暂停并询问是否接受较弱证据基础。
- 如果无法获取全文，只分析已验证的摘要/元数据，并记录访问限制。
- 如果找不到作者明示局限，不要硬写；移入推断 gap 或省略。

## 约束

- 不超出证据链推断
- 不把自己的判断写成作者局限
- 全文不可得时明确说明访问限制
- 宁可少分析几篇高质量论文，也不要做大量浅摘要
- 让每张论文卡片结构一致，便于 Step 4 综合
