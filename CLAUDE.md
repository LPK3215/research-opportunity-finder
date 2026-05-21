# Claude Project Memory

This repository ships Claude Code skills as the primary project entrypoint:

- English skill: `.claude/skills/research-innovation-scout/SKILL.md`
- Chinese skill: `.claude/skills/research-innovation-scout-zh-cn/SKILL.md`

When a user asks for research innovation directions, topic selection, literature-backed gaps, scene validation, paper mining, paper analysis, synthesis, or a decision report, use the matching skill.

Keep this file lightweight. The workflow lives in the skill folders so Claude can load the detailed step references only when needed.

Core behavior:

- Ground every claim in verifiable scene or literature evidence.
- State missing or weak evidence clearly.
- Do not invent papers, venues, datasets, benchmarks, metrics, citations, author claims, or limitations.
- Run one workflow step at a time unless the user asks for a complete run.
- Pause for user choice when the skill's rules require it.
