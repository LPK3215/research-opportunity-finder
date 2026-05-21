---
name: research-innovation-scout-zh-cn
description: 中文科研创新方向发现工作流。Use when an AI assistant needs to help Chinese users turn a vague research interest, method name, domain, paper title, or DOI into literature-backed innovation directions through scene validation, literature mining, paper analysis, cross-synthesis, and report generation.
---

# Research Innovation Scout 中文版

使用本 Skill，帮助研究者从模糊研究兴趣出发，得到有文献支撑、可比较、可追溯的科研创新方向。

## 快速开始

当用户要求寻找创新方向、研究选题、文献支撑的 gap，或生成决策报告时：

1. 先读取 [Step 0](references/step-0-input-classifier.md)，判断输入类型。
2. 只有当前步骤输出 `status: "proceed"` 时，才进入下一步。
3. 遇到需要用户选择的分支时必须暂停。
4. 只有 Step 0-4 的数据自洽后，才生成最终报告。

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

示例用户请求：

```text
帮我找一下对比学习在分子性质预测中的科研创新方向。
```

## 核心承诺

每个方向都必须来自可验证的场景证据或文献证据。找不到证据就明确说明。不得编造论文、benchmark、数据集、会议、指标、作者局限或实验结论。

如果无法联网检索或无法获取论文来源，先向用户索要来源，或在继续前明确说明限制。

## 工作流

| 步骤 | 读取 | 作用 | 暂停 / 终止条件 |
|------|------|------|----------------|
| Step 0 | [输入分类](references/step-0-input-classifier.md) | 判断 Type A/B/C，并形成可执行 research question | Type B/C 需要用户选择 |
| Step 1 | [场景校验](references/step-1-scene-validator.md) | 验证是否存在真实活跃科研场景 | 无证据终止；多个强场景暂停 |
| Step 2 | [文献检索](references/step-2-literature-miner.md) | 构建筛选后的文献池 | 少于 5 篇文献时暂停 |
| Step 3 | [论文拆解](references/step-3-paper-analyzer.md) | 对 4-6 篇关键论文做四维分析 | 无法获取全文时说明限制 |
| Step 4 | [综合分析](references/step-4-cross-synthesizer.md) | 形成开放问题池、方法图谱和创新方向 | 无支撑的方向类型不强行生成 |
| Step 5 | [报告生成](references/step-5-report-generator.md) | 写出最终 Markdown 决策报告 | 先完成数据自洽检查 |

多轮状态管理可参考 [流程编排器](references/step-orchestrator.md)。

## 执行规则

- 默认只读取当前步骤需要的 reference 文件。
- 默认一次只输出一个步骤。
- 每步输出要足够简洁，让用户能判断下一步。
- 步骤之间保留上述结构化 handoff 数据。
- 严格区分作者明示局限和读者推断 gap。
- 如果检索结果超过 50 条，先记录原始数量，再过滤。
- 证据弱就标注弱，不要写成强证据。

## 最终报告要求

最终报告必须包含：

1. 执行摘要
2. 场景证据卡
3. 文献全景
4. 创新方向建议
5. 综合评估
6. 附录

报告写入新的 Markdown 文件，例如 `report-{scene}-{date}.md`。

## 合格标准

一个研究者读完结果后，应该能清楚看到：

- 校验了哪个科研场景
- 纳入了哪些论文，为什么纳入
- 哪些 gap 是作者明示，哪些是推断
- 每个方向为什么值得考虑
- 还存在哪些风险和可行性限制
