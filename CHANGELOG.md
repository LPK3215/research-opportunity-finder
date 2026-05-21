# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed

- Added GitHub repository metadata and public project links.
- Split diagrams, example reports, docs, and skill prompts into English and Chinese variants.
- Added language-aware installation via `./scripts/install.sh --lang en|zh-CN`.
- Added Claude Code project skills under `.claude/skills/`.
- Added Codex/OpenAI `SKILL.md` + `references/` packages under `skills/codex/`.
- Added Cursor project rules under `.cursor/rules/`.
- Reworked installer priority so Claude Code, Codex, and Cursor are the primary targets; CodeBuddy is compatibility-only.
- Added GitHub Issue and Pull Request templates.
- Added `.gitattributes` to keep shell scripts LF-safe across Windows and GitHub.

## [v1.0] — 2026-05-21

### Added

- Complete 6-step research innovation discovery framework (Step 0–5)
- `skills/research-innovation-scout.md` — unified entry point
- 7 individual step skill files with full operational logic
- Anti-hallucination design: explicit/inferred distinction at every level
- Hot/cold/normal scenario stress testing and overflow handling
- Decision support report auto-generation with file output
- Three test reports in `reports/` demonstrating framework behavior
- MIT License

### Design

- Discipline-agnostic: works across CS, medicine, materials, etc.
- Four innovation direction types: Deepen, Transfer, Gap, Graft
- User-controlled pauses at ambiguous inputs
- Data self-consistency rule in report generation
