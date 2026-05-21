# Step 4: 跨文献综合

## 角色

你要把 Step 3 的论文分析综合成开放问题、方法图谱和候选创新方向。

不得凭直觉生成方向。每个方向都必须连接到论文级观察。

## 输入

使用 Step 3 handoff：

```json
{
  "paper_cards": [],
  "author_stated_issues": [],
  "inferred_gaps": []
}
```

## 任务 1：Open Problem Pool

合并多篇论文中的 unresolved issues。

每个问题簇记录：

- Problem name
- Source papers
- 证据性质：author-stated、inferred 或 mixed
- Consensus level
- Why it matters

共识等级：

| 等级 | 含义 |
|------|------|
| High | 多篇论文或 survey 中出现 |
| Medium | 2 篇论文或 1 篇强论文中出现 |
| Low | 仅 1 篇论文出现，或主要来自推断 |

## 任务 2：Methodology Map

把方法分组为范式。

每个范式记录：

- Representative papers
- Core mechanism
- Covered problems
- Strengths
- Weaknesses

然后生成 method-problem matrix。空白或覆盖薄弱的单元格可作为 gap exploration 候选。

## 任务 3：Innovation Directions

生成四类方向。

### 1. Deepen and Optimize

在已有范式内部改进。

触发条件：

- 已知方法弱点
- ablation 暴露的问题
- scalability 问题
- robustness 或 generalization 问题

### 2. Method Transfer

从其他领域或相邻子领域迁移方法。

触发条件：

- 问题结构相似
- 当前领域缺少某种范式
- 其他领域已有成熟技术

只有当源方法或相邻领域证据本身可验证时，才能提出迁移方向。必须同时引用当前场景论文锚点和源方法锚点。

### 3. Gap Exploration

填补 method-problem matrix 中的空白或弱覆盖单元格。

触发条件：

- matrix 单元格为空
- 多篇论文暗示同一未覆盖设定
- benchmark 存在，但方法不足

### 4. Problem Grafting

把当前场景连接到跨领域关切。

例子：

- Fairness
- Interpretability
- Efficiency
- Safety
- Security
- Uncertainty

## 方向模板

```markdown
#### [ID]: [Direction name]

- **Type**: Deepen / Transfer / Gap / Graft
- **Core idea**: ...
- **Literature anchors**: ...
- **Novelty**: High / Medium / Low + reason
- **Feasibility**: High / Medium / Low + prerequisites
- **Risks**: ...
- **Suggested first experiment**: ...
```

## 输出格式

```markdown
## Step 4 Output: Cross-Paper Synthesis

### I. Open Problem Pool

...

### II. Methodology Map

...

### III. Innovation Direction Suggestions

#### Deepen and Optimize
...

#### Method Transfer
...

#### Gap Exploration
...

#### Problem Grafting
...

### IV. Direction Ranking

...
```

Handoff block:

```json
{
  "step": 4,
  "status": "proceed|pause",
  "data": {
    "open_problem_pool": [],
    "methodology_map": [],
    "directions": [],
    "ranking": []
  },
  "warnings": [],
  "next_step": "step-5-report-generator|user_choice"
}
```

## 约束

- 每个方向必须引用具体论文或问题簇
- 不生成文献池无法支撑的方向
- 弱证据方向必须明确标注
- 优先输出 4-8 个高质量方向，不输出松散长列表
- 四类方向中某类没有支撑时，省略该类并说明原因
