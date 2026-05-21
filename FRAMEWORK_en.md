# Research Innovation Scout - Methodology Overview

> **Version**: v1.0  
> **Positioning**: A discipline-agnostic framework for discovering research innovation directions  
> **Scope**: Direction discovery only; paper writing, experiment design, and implementation are intentionally out of scope

---

## 1. Overview

Research Innovation Scout helps researchers move from a vague research interest to a set of literature-anchored candidate research directions. It is designed for uncertain early-stage exploration: a user may provide a domain, a method name, a keyword, a research question, a paper title, or a DOI.

The framework emphasizes evidence first. Each step must rely on verifiable literature or scene evidence. If evidence is missing, the system should stop or warn instead of inventing plausible-sounding ideas.

---

## 2. Typical Users

- PhD students or postdocs entering a new field
- Cross-disciplinary researchers looking for transfer opportunities
- Advisors or project leads exploring new topics for a group
- Industry researchers evaluating frontier research directions

---

## 3. Input Types

| Type | Meaning | Behavior |
|------|---------|----------|
| Type A | Specific research question | Extract the research question and advance |
| Type B | Method-oriented input | Reverse-query 2-3 active scenes, then pause for user choice |
| Type C | Broad domain | Decompose into 3-5 sub-directions, then pause for user choice |

Optional input hints include domain, scope, time range, and language preference.

---

## 4. Six-Step Pipeline

### Step 0: Input Classification

Classify the user input as Type A, B, or C. The goal is to turn an ambiguous phrase into an actionable research question without over-deciding for the user.

### Step 1: Scene Validation

Search for recent surveys, benchmarks, datasets, workshops, challenges, and top-venue papers. Rate the scene as strong, medium, weak, or none. If no evidence exists, terminate clearly.

### Step 2: Literature Mining

Find seed papers, expand through forward/backward citations, and filter by recency, venue quality, citations, and direct relevance. Strong scenes should normally produce a pool of 10-25 papers; fewer than 5 papers requires a warning.

### Step 3: Paper Analysis

For the most important papers, analyze four dimensions:

| Dimension | Purpose |
|-----------|---------|
| Problem | Task setup and prior-work gap |
| Methodology | Paradigm and core mechanism |
| Contribution | Author-claimed contribution and experimental support |
| Unresolved Issues | Author-stated limitations vs. inferred gaps |

The explicit/inferred distinction is mandatory.

### Step 4: Cross-Synthesis

Merge unresolved issues into an open problem pool, build a methodology map, and generate candidate directions. Each direction must link back to specific observations from specific papers.

### Step 5: Report Generation

Write a structured decision-support report with:

1. Executive summary
2. Scene evidence card
3. Literature panorama
4. Innovation direction suggestions
5. Comprehensive assessment
6. Appendix

The report should be written to a new Markdown file.

---

## 5. Direction Types

| Type | Description |
|------|-------------|
| Deepen & Optimize | Improve within an existing paradigm |
| Method Transfer | Adapt methods from another field |
| Gap Exploration | Fill blank cells in the method-problem matrix |
| Problem Grafting | Connect the scene with cross-domain concerns such as fairness, interpretability, efficiency, or security |

---

## 6. Design Principles

- **Anti-hallucination first**: no evidence means no fabricated direction
- **Discipline-agnostic**: the workflow should work across fields
- **User-controlled**: ambiguous inputs pause for user choice
- **Traceable evidence**: every direction should point to a literature anchor
- **Robust to extremes**: cold scenes terminate; hot scenes trigger overflow handling

For the full Chinese methodology document, see [FRAMEWORK.md](./FRAMEWORK.md).
