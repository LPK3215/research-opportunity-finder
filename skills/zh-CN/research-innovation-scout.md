# Research Innovation Scout - 中文总入口

Research Innovation Scout 是一个学科通用的科研创新方向发现流程，用来把模糊研究兴趣转化为有文献锚点的候选研究方向。

核心规则：每个判断都必须有可验证的场景证据或文献证据。证据缺失时要明确说明并暂停或终止。不得编造论文、会议、benchmark、数据集、结果或作者局限。

如果无法联网检索或无法获取论文来源，先向用户索要来源，或在继续前明确说明限制。

## 文件结构

| 文件 | 步骤 | 作用 |
|------|------|------|
| `step-0-input-classifier.md` | Step 0 | 输入分类，并形成可执行 research question |
| `step-1-scene-validator.md` | Step 1 | 验证是否存在真实活跃科研场景 |
| `step-2-literature-miner.md` | Step 2 | 构建筛选后的文献池 |
| `step-3-paper-analyzer.md` | Step 3 | 对关键论文做四维拆解 |
| `step-4-cross-synthesizer.md` | Step 4 | 综合开放问题和候选创新方向 |
| `step-5-report-generator.md` | Step 5 | 生成最终决策支持报告 |
| `step-orchestrator.md` | Orchestrator | 管理状态、暂停和数据流转 |

## 执行顺序

严格按以下顺序执行：

1. Step 0：输入分类
2. Step 1：场景校验
3. Step 2：文献检索
4. Step 3：论文拆解
5. Step 4：综合分析
6. Step 5：报告生成

默认一次只输出当前步骤。只有用户明确要求完整运行时，才连续执行。触发暂停规则时必须等待用户选择。

每一步都保留以下 handoff 结构：

```json
{
  "step": 0,
  "status": "proceed|pause|terminate",
  "data": {},
  "warnings": [],
  "next_step": "step-1-scene-validator|user_choice|stop"
}
```

## Step 0：输入分类

读取 `step-0-input-classifier.md`。

- Type A：具体研究问题，提取 research question 后进入 Step 1。
- Type B：只给方法或技术名，生成 2-3 个候选应用场景并暂停。
- Type C：宽泛领域，拆解 3-5 个子方向并暂停。

输出标准化 research question、领域提示、假设和下一步动作。

## Step 1：场景校验

读取 `step-1-scene-validator.md`。

检索以下证据：

- 近年 survey/review
- benchmark、dataset、task 或 leaderboard
- workshop、challenge、顶会/顶刊论文
- 相关开源项目或活跃社区

证据评级为 strong、medium、weak、none。所有候选场景均无证据时终止。

## Step 2：文献检索

读取 `step-2-literature-miner.md`。

构建文献池：

1. 定位种子文献
2. 前后向引用扩展
3. 按时间、来源质量、引用信号和相关度过滤
4. 初检结果超过 50 条时记录原始数量并收窄

若最终少于 5 篇相关论文，暂停并询问是否拓宽场景。

## Step 3：论文拆解

读取 `step-3-paper-analyzer.md`。

对 4-6 篇关键论文做四维分析：

- Problem
- Methodology
- Contribution
- Unresolved issues

严格区分作者明示局限和读者推断 gap。推断 gap 必须有推理链。

## Step 4：综合分析

读取 `step-4-cross-synthesizer.md`。

产出：

- Open problem pool
- Methodology map
- Method-problem matrix
- 四类创新方向：深化优化、方法迁移、空白探索、问题嫁接

每个方向都必须回链到具体论文观察。

## Step 5：报告生成

读取 `step-5-report-generator.md`。

生成 Markdown 报告，包含：

1. 执行摘要
2. 场景证据卡
3. 文献全景
4. 创新方向建议
5. 综合评估
6. 附录

报告写入新的 `.md` 文件，例如 `report-{scene}-{date}.md`。如果当前环境无法写文件，输出完整 Markdown，并说明建议文件名。

## 全局约束

- 不编造参考文献、benchmark、数据集、会议或指标
- 明确标注不确定推断
- 区分证据和解释
- 每步保持简洁，除非用户要求展开
- 保持步骤间数据自洽
- 检索过宽时先记录原始数量，再过滤
