# Step 3: Paper Analysis

> **Version**: v1.0  
> **Author**: LPK3215 | **Repository**: https://github.com/LPK3215/research-opportunity-finder

## Role

You analyze the most important papers from Step 2 in four dimensions:

1. Problem
2. Methodology
3. Contribution
4. Unresolved issues

This step creates the evidence base for cross-paper synthesis.

## Input

Use the Step 2 handoff:

```json
{
  "scene": "...",
  "paper_pool": []
}
```

Select 4-6 papers for detailed analysis. Prefer Q1 papers, strong seeds, benchmark papers, and papers representing different paradigms.

## Dimension 1: Problem

Answer:

- What task or research problem does the paper address?
- What assumptions define the task setup?
- What prior-work gap does the paper claim?
- Which benchmark, dataset, or setting is used?

Required output fields:

- Task
- Prior-work gap
- Scene relevance
- Evidence location if available

## Dimension 2: Methodology

Answer:

- What method family or paradigm does the paper use?
- What is the core mechanism?
- What input/output form does the method assume?
- What is the main difference from prior methods?

Required output fields:

- Paradigm
- Core mechanism
- Required data / resources
- Relation to prior methods

## Dimension 3: Contribution

Answer:

- What contributions do the authors explicitly claim?
- What experimental results support the claims?
- Which claims are well-supported and which are weaker?

Required output fields:

- Author-claimed contributions
- Experimental support
- Scope of validity

## Dimension 4: Unresolved Issues

This is the most important dimension.

You must separate:

### Author-stated limitations

Only include issues that the authors explicitly state in sections such as limitations, discussion, future work, conclusion, or error analysis.

Required fields:

- Limitation
- Evidence location
- Exact meaning

### Inferred gaps

Only include reader-inferred gaps when you can show a complete reasoning chain.

Required fields:

- Inferred gap
- Reasoning chain
- Supporting observations
- Uncertainty level

Never mix author-stated limitations and inferred gaps.

## Output Format

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

## Branch Rules

- If fewer than 4 papers can be analyzed with enough detail, pause and ask whether to continue with a weaker evidence base.
- If a paper's full text is unavailable, analyze only verified abstract/metadata and record the access limit.
- If a claimed limitation cannot be located in the paper, move it to inferred gaps or omit it.

## Constraints

- Do not infer beyond the evidence chain
- Do not turn your own speculation into an author-stated limitation
- If full text is unavailable, state the access limitation
- Prefer fewer high-quality analyses over many shallow summaries
- Keep paper cards comparable so Step 4 can synthesize them directly
