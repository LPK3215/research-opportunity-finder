---
name: research-innovation-scout
description: Literature-grounded research direction discovery workflow. Use when an AI assistant needs to turn a vague research interest, method name, domain, paper title, or DOI into evidence-backed innovation directions through scene validation, literature mining, paper analysis, cross-synthesis, and report generation.
---

# Research Innovation Scout

Use this skill to help a researcher move from an unclear research interest to literature-anchored candidate research directions.

## Quick Start

When the user asks for innovation directions, research topics, literature-backed gaps, or a decision report:

1. Start with [Step 0](references/step-0-input-classifier.md) to classify the input.
2. Continue step by step only when the current step says `proceed`.
3. Pause when the workflow requires user choice.
4. Generate the final report only after Steps 0-4 have produced consistent handoff data.

Every step should preserve this handoff shape:

```json
{
  "step": 0,
  "status": "proceed|pause|terminate",
  "data": {},
  "warnings": [],
  "next_step": "step-1-scene-validator|user_choice|stop"
}
```

Example user request:

```text
Find research innovation directions for contrastive learning in molecular property prediction.
```

## Core Promise

Every direction must be grounded in verifiable scene or literature evidence. If evidence is missing, state that clearly. Do not invent papers, benchmarks, venues, datasets, limitations, metrics, or author claims.

If web search or paper access is unavailable, ask the user for sources or clearly state the limitation before continuing.

## Workflow

| Step | Read | Purpose | Pause / stop condition |
|------|------|---------|------------------------|
| Step 0 | [Input Classifier](references/step-0-input-classifier.md) | Classify Type A/B/C and form an actionable research question | Type B/C requires user choice |
| Step 1 | [Scene Validator](references/step-1-scene-validator.md) | Verify that a real active research scene exists | No evidence stops; multiple strong scenes pause |
| Step 2 | [Literature Miner](references/step-2-literature-miner.md) | Build a filtered paper pool | Fewer than 5 papers pauses |
| Step 3 | [Paper Analyzer](references/step-3-paper-analyzer.md) | Analyze 4-6 key papers in four dimensions | Full text unavailable means state limitation |
| Step 4 | [Cross-Synthesizer](references/step-4-cross-synthesizer.md) | Build open problems, method map, and directions | Unsupported direction types should be omitted |
| Step 5 | [Report Generator](references/step-5-report-generator.md) | Write the final Markdown decision report | Run consistency checks first |

For multi-turn state management, use [Orchestrator](references/step-orchestrator.md).

## Operating Rules

- Load only the reference file for the current step unless the user asks for a full audit or complete run.
- Output one step at a time by default.
- Keep each step concise enough for the user to decide what happens next.
- Preserve the machine-readable handoff block between steps.
- Separate author-stated limitations from inferred gaps.
- If a search returns more than 50 results, record the raw count before filtering.
- If the evidence is weak, label it weak instead of making it sound stronger.

## Final Report Contract

The final report must include:

1. Executive summary
2. Scene evidence card
3. Literature panorama
4. Innovation direction suggestions
5. Comprehensive assessment
6. Appendix

Write the report to a new Markdown file named like `report-{scene}-{date}.md`.

## Quality Bar

The skill succeeds when a researcher can see:

- What scene was validated
- Which papers were included and why
- Which gaps are author-stated versus inferred
- Why each proposed direction is novel enough to consider
- What risks or feasibility limits remain
