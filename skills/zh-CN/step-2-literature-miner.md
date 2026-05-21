# Step 2: 文献检索与筛选

## 角色

你要为 Step 1 验证过的场景构建高质量文献池。

输出应服务于后续论文拆解，而不是松散书目列表。

## 输入

使用 Step 1 handoff：

```json
{
  "scene": "...",
  "research_question": "...",
  "evidence_rating": "strong|medium|weak",
  "evidence_items": []
}
```

## 检索策略

### Phase 0：溢出处理

如果首次宽泛检索超过 50 条：

1. 记录原始数量和宽泛查询词
2. 加入场景限定词
3. 按 survey、benchmark、顶级来源、引用信号和时间过滤
4. 明确报告收窄过程

### Phase 1：种子文献

找到 2-3 篇种子文献：

- 近期 survey/review
- 高被引基础论文
- benchmark 或 dataset 论文
- 与场景直接匹配的近期顶级来源论文

### Phase 2：引用扩展

扩展来源：

- 后向引用：种子论文的重要参考文献
- 前向引用：引用种子的关键后续工作
- 使用相同 benchmark 或 dataset 的论文
- 该场景活跃团队的相关论文

### Phase 3：硬过滤

| 标准 | 规则 |
|------|------|
| 相关性 | 直接处理已验证场景 |
| 时间 | 优先近 5 年，基础论文可例外 |
| 来源质量 | 优先顶会、Q1 期刊或可信预印本 |
| 引用信号 | 对论文年龄而言有影响力 |
| 多样性 | 覆盖多个范式，而不是同一方法族 |

## 质量标签

| 标签 | 含义 |
|------|------|
| Q1 | 顶级来源或权威工作，且高度相关 |
| Q2 | 相关且可信，但权威性较弱或较新 |
| Q3 | 仅作背景参考，不能过度加权 |

## 输出格式

```markdown
## Step 2 Output: Literature Mining

### Search Overview

| Query / source | Raw result | Filtered result | Notes |
|----------------|------------|-----------------|-------|
| ... | ... | ... | ... |

### Seed Papers

| Paper | Year | Source | Why seed |
|-------|------|--------|----------|
| ... | ... | ... | ... |

### Filtered Paper Pool

| # | Paper | Year | Venue/source | Paradigm | Quality | Reason included |
|---|-------|------|--------------|----------|---------|-----------------|
| 1 | ... | ... | ... | ... | Q1/Q2/Q3 | ... |
```

Handoff block:

```json
{
  "step": 2,
  "status": "proceed|pause",
  "data": {
    "scene": "...",
    "research_question": "...",
    "paper_pool": [],
    "seed_papers": [],
    "search_record": []
  },
  "warnings": [],
  "next_step": "step-3-paper-analyzer|user_choice"
}
```

## 分支规则

- 强证据场景目标：10-25 篇
- 中等证据场景目标：5-15 篇
- 少于 5 篇：暂停，询问是否拓宽场景
- 文献池过大：收紧过滤，并记录过程

## 约束

- 不编造标题、作者、会议、年份或引用数
- 不纳入只共享泛关键词的论文
- 区分种子文献和扩展文献
- 保留足够元数据供 Step 3 和 Step 4 使用
- 精确元数据无法验证时，标为 unverified，不要猜
