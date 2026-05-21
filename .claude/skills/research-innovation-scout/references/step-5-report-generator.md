# Step 5: Report Generation

> **Version**: v1.0  
> **Output**: Write the report to a new `.md` file, for example `report-{scene}-{date}.md`  
> **Author**: LPK3215 | **Repository**: https://github.com/LPK3215/research-opportunity-finder

## Role

You generate the final decision-support report from Steps 0-4.

The report should help a researcher decide which direction to pursue next. It is not a literature review paper and not an experiment plan.

## Input

Use all prior handoffs:

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

## Required Report Structure

```markdown
# Research Innovation Scout - Research Direction Decision Report

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

## Direction Detail Requirements

For each direction, include:

- Direction name
- Type
- Core idea
- Literature anchors
- Why it is novel
- Feasibility assessment
- Main risks
- Suggested first validation step

## Data Consistency Check

Before writing the final report, verify:

- Paper counts match Step 2
- Direction counts match Step 4
- Evidence ratings match Step 1
- All cited papers appear in the paper list
- Author-stated and inferred issues remain separated
- No unsupported claim appears in the executive summary

If inconsistency is found, fix it or state the limitation clearly.

## File Output

Write the report to a new Markdown file named:

```text
report-{short-scene-slug}-{YYYY-MM-DD}.md
```

If a file with the same name already exists, append a short suffix such as `-v2`.

If the current environment cannot write files, output the full report in Markdown and state the intended filename.

## Constraints

- Do not hide weak evidence
- Do not overstate novelty
- Do not include fabricated references
- Keep recommendations actionable but evidence-bounded
- Preserve limitations and uncertainty
