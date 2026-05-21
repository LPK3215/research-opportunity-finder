# FAQ — Frequently Asked Questions

## Usage

### How do I use this?

Copy the `skills/` folder to your project. Send `skills/research-innovation-scout.md` to an AI, then input your research interest.

### What can I input?

Anything: a broad domain ("AI for Science"), a technique ("GNN"), a specific question ("how to improve few-shot generalization"), or a paper DOI.

### Does it work with any AI?

Yes. The skill files are plain Markdown prompts compatible with any AI that supports file reading and web search.

### Where does the output go?

The final report is written to a new `.md` file in your working directory (e.g., `report-molecular-property-2026-05-21.md`), not in the chat.

## Reliability

### Can I trust the results?

Every innovation direction is anchored to specific literature. Inferred issues are explicitly marked with ⚠️. We recommend independent verification of key papers.

### What if the framework finds nothing?

It will explicitly tell you "no evidence found" and suggest: broadening your search, adjusting keywords, or exploring adjacent fields. It will not fabricate results.

### How does it handle extremely popular topics?

If initial search returns >50 papers, overflow handling kicks in: it records the total count, then narrows by quality filters (venue, citations, recency) before analysis begins.

## Extending

### Can I create my own step?

Yes. Each step file is independent. Follow the same format and maintain the JSON data handoff convention described in `step-orchestrator.md`.

### What's next after finding an innovation direction?

This framework only covers direction discovery. Downstream tasks (paper writing, experiment design, code scaffolding) will be separate skill packs in the future.

## Troubleshooting

### The AI stopped after Step 0 / Step 1

This is expected if your input is ambiguous (Type B/C) or the scene has no evidence (⚪). The framework pauses to let you choose a direction or adjust your query.

### The report numbers don't match

Ensure you're using v1.0+. Earlier versions had a data-consistency oversight. The current version includes a self-check rule in Step 5.
