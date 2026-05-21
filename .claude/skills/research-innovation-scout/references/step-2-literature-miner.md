# Step 2: Literature Mining and Filtering

> **Version**: v1.0  
> **Author**: LPK3215 | **Repository**: https://github.com/LPK3215/research-opportunity-finder

## Role

You build a high-quality paper pool for the validated scene from Step 1.

The output should be useful for downstream paper analysis, not a loose bibliography.

## Input

Use the Step 1 handoff:

```json
{
  "scene": "...",
  "research_question": "...",
  "evidence_rating": "strong|medium|weak",
  "evidence_items": []
}
```

## Mining Strategy

### Phase 0: Overflow Handling

If the first broad search returns more than 50 results:

1. Record the raw count and broad query
2. Add scene-specific filters
3. Filter by survey, benchmark, top venue, citation signal, and recency
4. Report the narrowing process explicitly

### Phase 1: Seed Papers

Find 2-3 seed papers:

- Recent surveys or reviews
- Highly cited foundational papers
- Benchmark or dataset papers
- Recent top-venue papers directly matching the scene

### Phase 2: Citation Expansion

Expand through:

- Backward citations: key references in seed papers
- Forward citations: important papers citing the seeds
- Same-benchmark or same-dataset papers
- Papers by active research groups in the scene

### Phase 3: Hard Filtering

Filter by:

| Criterion | Rule |
|----------|------|
| Relevance | Directly addresses the validated scene |
| Recency | Prefer recent 5 years unless foundational |
| Venue quality | Prefer top venues, Q1 journals, or recognized archives |
| Citation signal | Prefer papers with strong influence for their age |
| Diversity | Cover multiple paradigms, not only one method family |

## Quality Labels

| Label | Meaning |
|-------|---------|
| Q1 | Top venue or authoritative work with high relevance |
| Q2 | Relevant and credible, but less authoritative or newer |
| Q3 | Useful context only; do not over-weight |

## Output Format

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

## Branch Rules

- Strong scene target: 10-25 papers
- Medium scene target: 5-15 papers
- If fewer than 5 papers remain, warn and ask whether to broaden the scene
- If the pool is too large, apply stricter filters and record the process

## Constraints

- Never invent titles, authors, venues, years, or citation counts
- Do not include papers only because they share generic keywords
- Separate seed papers from expanded papers
- Preserve enough metadata for Step 3 and Step 4
- If exact metadata cannot be verified, mark it as unverified instead of guessing
