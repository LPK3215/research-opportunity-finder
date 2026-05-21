# Step 1: Scene Validation

> **Version**: v1.0  
> **Author**: LPK3215 | **Repository**: https://github.com/LPK3215/research-opportunity-finder

## Role

You validate whether the research question from Step 0 corresponds to a real, active research scene.

The goal is not to prove novelty yet. The goal is to prevent fabricated or empty research directions from entering the pipeline.

## Input

Use the Step 0 handoff:

```json
{
  "research_question": "...",
  "domain": "...",
  "method_or_object": "...",
  "candidate_scene": "..."
}
```

## Evidence to Search

For each candidate scene, search for:

1. Recent surveys or review papers, preferably within 3 years
2. Benchmarks, datasets, tasks, leaderboards, or shared evaluation protocols
3. Workshops, challenges, special issues, or top-venue papers
4. Active open-source repositories or communities when relevant

Record query terms, source names, and concrete evidence.

## Evidence Rating

| Rating | Meaning |
|--------|---------|
| Strong | Survey/review evidence + benchmark/dataset + top-venue or active community evidence |
| Medium | At least two evidence types, but coverage is incomplete |
| Weak | Only scattered papers or indirect evidence |
| None | No direct evidence found |

## Output Format

```markdown
## Step 1 Output: Scene Validation

### Candidate Scene: [name]

| Evidence type | Findings | Source / query |
|---------------|----------|----------------|
| Survey/review | ... | ... |
| Benchmark/data | ... | ... |
| Venue/community | ... | ... |

**Evidence rating**: Strong / Medium / Weak / None
**Decision**: Proceed / Ask user / Terminate
```

Handoff block:

```json
{
  "step": 1,
  "status": "proceed|pause|terminate",
  "data": {
    "scene": "...",
    "research_question": "...",
    "evidence_rating": "strong|medium|weak|none",
    "evidence_items": [],
    "failed_searches": []
  },
  "warnings": [],
  "next_step": "step-2-literature-miner|user_choice|stop"
}
```

## Branch Rules

- If all scenes are rated `none`, terminate and explain that no valid research scene was found
- If evidence is weak, ask whether the user wants to broaden or adjust the scene
- If multiple strong scenes exist, ask the user to choose
- If one scene is clearly strongest, proceed to Step 2
- If search access is unavailable, pause and ask the user for papers, surveys, benchmark pages, or search permission

## Constraints

- Do not treat generic adjacent papers as direct scene evidence
- Do not invent benchmarks or venue names
- Preserve failed searches; negative evidence is still useful
- Keep evidence and interpretation separate
