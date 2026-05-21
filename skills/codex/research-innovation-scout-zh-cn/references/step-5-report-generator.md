# Step 5: 报告生成

## 角色

你要基于 Steps 0-4 生成最终科研方向决策支持报告。

报告帮助研究者判断下一步可选方向。它不是综述论文，也不是实验计划书。

## 输入

使用所有前序 handoff：

```json
{
  "step_0": {},
  "step_1": {},
  "step_2": {},
  "step_3": {},
  "step_4": {}
}
```

Required handoff shape:

```json
{
  "step": 5,
  "status": "proceed|pause",
  "data": {
    "report_file": "...",
    "report_summary": "...",
    "consistency_check": []
  },
  "warnings": [],
  "next_step": "done|user_choice"
}
```

## 报告结构

```markdown
# Research Innovation Scout - 科研方向决策支持报告

> Generated: [date]  
> Input: [original input]  
> Focused scene: [scene]  
> Framework: Research Innovation Scout v1.0

## 1. Executive Summary

### 1.1 Input Understanding

### 1.2 Scene Confirmation

### 1.3 Literature Overview

### 1.4 Direction Overview

## 2. Scene Evidence Card

## 3. Literature Panorama

### 3.1 Key Papers

### 3.2 Methodology Map

### 3.3 Open Problem Pool

## 4. Innovation Direction Suggestions

### 4.1 Deepen and Optimize

### 4.2 Method Transfer

### 4.3 Gap Exploration

### 4.4 Problem Grafting

## 5. Comprehensive Assessment

### 5.1 Direction Comparison Matrix

### 5.2 Recommended Paths

### 5.3 Limitations

## 6. Appendix

### Appendix A: Full Paper List

### Appendix B: Glossary

### Appendix C: Generation Trace
```

## 每个方向必须包含

- Direction name
- Type
- Core idea
- Literature anchors
- Why it is novel
- Feasibility assessment
- Main risks
- Suggested first validation step

## 数据自洽检查

写报告前检查：

- 论文数量与 Step 2 一致
- 方向数量与 Step 4 一致
- 证据评级与 Step 1 一致
- 所有引用论文都出现在文献清单中
- 作者明示问题和推断问题没有混淆
- 执行摘要中没有无支撑断言

发现不一致时，先修正；无法修正时，在报告中明确说明限制。

## 文件输出

报告写入新的 Markdown 文件：

```text
report-{short-scene-slug}-{YYYY-MM-DD}.md
```

如果同名文件已存在，追加短后缀，例如 `-v2`。

如果当前环境无法写文件，输出完整 Markdown，并说明建议文件名。

## 约束

- 不隐藏弱证据
- 不夸大新颖性
- 不编造参考文献
- 建议要可执行，但必须受证据约束
- 保留局限性和不确定性
