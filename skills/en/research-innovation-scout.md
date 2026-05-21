# Research Innovation Scout - Master Skill

> **Version**: v1.0  
> **Author**: LPK3215 | **Repository**: https://github.com/LPK3215/research-opportunity-finder

Research Innovation Scout is a discipline-agnostic workflow for turning a vague research interest into literature-anchored candidate research directions.

Core rule: every claim must be grounded in verifiable literature or scene evidence. If evidence is missing, say so clearly and stop or warn. Never fabricate papers, venues, benchmarks, results, or limitations.

If web search or paper access is unavailable, ask the user for sources or state the limitation before continuing.

## File Structure

| File | Step | Purpose |
|------|------|---------|
| `step-0-input-classifier.md` | Step 0 | Classify input and form an actionable research question |
| `step-1-scene-validator.md` | Step 1 | Validate whether a real active research scene exists |
| `step-2-literature-miner.md` | Step 2 | Build a filtered paper pool |
| `step-3-paper-analyzer.md` | Step 3 | Analyze key papers in four dimensions |
| `step-4-cross-synthesizer.md` | Step 4 | Synthesize open problems and candidate directions |
| `step-5-report-generator.md` | Step 5 | Generate the final decision-support report |
| `step-orchestrator.md` | Orchestrator | Manage state, pauses, and data handoff |

## Execution Order

Run the pipeline in this exact order:

1. Step 0: input classification
2. Step 1: scene validation
3. Step 2: literature mining
4. Step 3: paper analysis
5. Step 4: cross-synthesis
6. Step 5: report generation

At each stage, output only the current step unless the user explicitly asks for a complete run. Pause when the rules require user choice.

Each step must preserve this handoff shape:

```json
{
  "step": 0,
  "status": "proceed|pause|terminate",
  "data": {},
  "warnings": [],
  "next_step": "step-1-scene-validator|user_choice|stop"
}
```

## Step 0: Input Classification

Read `step-0-input-classifier.md`.

Classify the input as:

- Type A: specific research question; extract the research question and advance
- Type B: method-oriented input; generate 2-3 candidate scenes and pause
- Type C: broad domain; decompose into 3-5 sub-directions and pause

Output a normalized research question, domain hints, assumptions, and next action.

## Step 1: Scene Validation

Read `step-1-scene-validator.md`.

Search for scene evidence:

- Recent surveys or reviews
- Benchmarks, datasets, tasks, or leaderboards
- Workshops, challenges, or top-venue papers
- Active open-source repositories or communities when relevant

Rate evidence as strong, medium, weak, or none. If all candidate scenes have no evidence, terminate and explain why.

## Step 2: Literature Mining

Read `step-2-literature-miner.md`.

Build a paper pool through:

1. Seed papers
2. Forward/backward citation expansion
3. Hard filters for recency, venue quality, citation signal, and direct relevance
4. Overflow handling when initial search results exceed 50

If fewer than 5 relevant papers remain, warn and ask whether to broaden the scene.

## Step 3: Paper Analysis

Read `step-3-paper-analyzer.md`.

Analyze 4-6 key papers using:

- Problem
- Methodology
- Contribution
- Unresolved issues

Never mix author-stated limitations with inferred gaps. Inferred gaps must include a reasoning chain.

## Step 4: Cross-Synthesis

Read `step-4-cross-synthesizer.md`.

Produce:

- Open problem pool
- Methodology map
- Method-problem matrix
- Four types of innovation directions:
  - Deepen and optimize
  - Method transfer
  - Gap exploration
  - Problem grafting

Each direction must cite specific observations from specific papers.

## Step 5: Report Generation

Read `step-5-report-generator.md`.

Generate a Markdown report with:

1. Executive summary
2. Scene evidence card
3. Literature panorama
4. Innovation direction suggestions
5. Comprehensive assessment
6. Appendix

Write the report to a new `.md` file, for example `report-{scene}-{date}.md`.

## Global Constraints

- Do not invent references, benchmarks, datasets, venues, or metrics
- Mark uncertain reasoning explicitly
- Separate evidence from interpretation
- Keep each step concise unless the user asks for detail
- Preserve data consistency across step outputs
- When search results are too broad, record the raw count before filtering
