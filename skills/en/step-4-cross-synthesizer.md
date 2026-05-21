# Step 4: Cross-Paper Synthesis

> **Version**: v1.0  
> **Author**: LPK3215 | **Repository**: https://github.com/LPK3215/research-opportunity-finder

## Role

You synthesize the paper analyses from Step 3 into a structured map of open problems, methods, and candidate innovation directions.

Do not generate directions from intuition alone. Every direction must connect to paper-level observations.

## Input

Use the Step 3 handoff:

```json
{
  "paper_cards": [],
  "author_stated_issues": [],
  "inferred_gaps": []
}
```

## Task 1: Open Problem Pool

Merge unresolved issues across papers.

For each problem cluster, record:

- Problem name
- Source papers
- Whether the evidence is author-stated, inferred, or mixed
- Consensus level
- Why it matters

Consensus levels:

| Level | Meaning |
|-------|---------|
| High | Appears across multiple papers or a survey |
| Medium | Appears in 2 papers or one strong paper |
| Low | Appears in one paper or is mostly inferred |

## Task 2: Methodology Map

Group methods into paradigms.

For each paradigm, record:

- Representative papers
- Core mechanism
- Covered problems
- Strengths
- Weaknesses

Then create a method-problem matrix. Empty or weakly covered cells are potential gap-exploration candidates.

## Task 3: Innovation Directions

Generate directions in four categories.

### 1. Deepen and Optimize

Improve within an existing paradigm.

Triggers:

- Known method weakness
- Ablation gap
- Scalability issue
- Robustness or generalization problem

### 2. Method Transfer

Adapt methods from another field or adjacent subfield.

Triggers:

- Similar problem structure
- Missing paradigm in the current field
- Mature technique elsewhere

Only propose transfer directions when the source method or adjacent-field evidence is itself verified. Cite both the current-scene paper anchors and the source-method anchor.

### 3. Gap Exploration

Fill blank or weak cells in the method-problem matrix.

Triggers:

- Matrix cell is empty
- Multiple papers imply the same uncovered setting
- Benchmark exists but methods are underdeveloped

### 4. Problem Grafting

Connect the scene to cross-domain concerns.

Examples:

- Fairness
- Interpretability
- Efficiency
- Safety
- Security
- Uncertainty

## Direction Template

```markdown
#### [ID]: [Direction name]

- **Type**: Deepen / Transfer / Gap / Graft
- **Core idea**: ...
- **Literature anchors**: ...
- **Novelty**: High / Medium / Low + reason
- **Feasibility**: High / Medium / Low + prerequisites
- **Risks**: ...
- **Suggested first experiment**: ...
```

## Output Format

```markdown
## Step 4 Output: Cross-Paper Synthesis

### I. Open Problem Pool

...

### II. Methodology Map

...

### III. Innovation Direction Suggestions

#### Deepen and Optimize
...

#### Method Transfer
...

#### Gap Exploration
...

#### Problem Grafting
...

### IV. Direction Ranking

...
```

Handoff block:

```json
{
  "step": 4,
  "status": "proceed|pause",
  "data": {
    "open_problem_pool": [],
    "methodology_map": [],
    "directions": [],
    "ranking": []
  },
  "warnings": [],
  "next_step": "step-5-report-generator|user_choice"
}
```

## Constraints

- Each direction must cite specific papers or problem clusters
- Do not create directions unsupported by the paper pool
- Mark weakly supported directions explicitly
- Prefer 4-8 high-quality directions over a long loose list
- If one of the four direction categories has no support, omit it and explain why
