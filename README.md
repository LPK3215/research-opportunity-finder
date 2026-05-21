# 🔬 Research Innovation Scout

> From vague research ideas to literature-anchored innovation directions — turn "I have a rough direction" into "I have N paper-backed optional topics".

<p align="center">
  <img src="https://img.shields.io/badge/version-v1.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/status-stable-brightgreen" alt="Status">
  <img src="https://img.shields.io/badge/platform-Multi--Tool-purple" alt="Platform">
  <img src="https://img.shields.io/badge/discipline-Agnostic-orange" alt="Discipline">
</p>

<p align="center">
  <img src="./docs/architecture.svg" alt="Architecture" width="700">
</p>

> 📖 [中文版 / Chinese](./README_zh-CN.md)

---

## 🚀 What is this?

Research Innovation Scout is a **discipline-agnostic framework for discovering research innovation directions**. Feed it a vague research interest (a domain, a technique, a keyword, a paper DOI), and it executes a six-step pipeline to output a decision-support report with literature-anchored innovation suggestions.

### vs. Generic AI Prompts

| | Generic Prompts | Research Innovation Scout |
|--|-----------------|--------------------------|
| Starting point | "Find me some ideas" | Input classification + problem formulation |
| Evidence | Fabricates from memory | Every step searches real literature |
| Analysis | Surface-level | Four-dimension breakdown + explicit/inferred separation |
| Directions | Random list | Four types + literature anchors + risk/feasibility |
| Edge cases | Makes things up | Cold → clearly states "no evidence"; Hot → overflow truncation |

Every step is an independent, reusable AI prompt with anti-hallucination design — **if no evidence exists, it says so clearly. Never fabricates.**

---

## ⚡ Quick Start

### Option 1: One-Click Install (Recommended)

```bash
git clone https://cnb.cool/lpk3215/research-opportunity-finder.git
cd research-opportunity-finder
./scripts/install.sh          # Auto-detect your tools and install
```

### Option 2: Install for a Specific Tool

```bash
./scripts/install.sh --tool claude-code   # Claude Code
./scripts/install.sh --tool codebuddy     # CodeBuddy
./scripts/install.sh --tool cursor        # Cursor
./scripts/install.sh --tool copilot       # GitHub Copilot
./scripts/install.sh --tool aider         # Aider
./scripts/install.sh --tool windsurf       # Windsurf
./scripts/install.sh --tool general       # Plain Markdown
```

### Option 3: Manual Use

Send the contents of `skills/research-innovation-scout.md` to any AI that supports file reading and web search. Then input your research interest.

```bash
# Claude Code users: CLAUDE.md is auto-loaded after cloning
claude
# Just say: "Find innovation directions for contrastive learning in molecular property prediction"
```

---

## 🔌 Multi-Tool Integrations

Research Innovation Scout supports one-click install across multiple tools via `scripts/install.sh`:

| Tool | Install Location | How to Use |
|------|-----------------|------------|
| **Claude Code** | `~/.claude/CLAUDE.md` | Auto-loaded on `claude` launch |
| **CodeBuddy** | `.codebuddy/skills/research-innovation-scout/` | Auto-detected as a Skill |
| **Cursor** | `.cursor/rules/research-innovation-scout.mdc` | `@research-innovation-scout <direction>` |
| **GitHub Copilot** | `.github/agents/research-innovation-scout.md` | Auto-effective in project |
| **Aider** | `CONVENTIONS.md` | Auto-read on `aider` launch |
| **Windsurf** | `.windsurfrules` | Auto-loaded by Cascade |
| **Plain Markdown** | `research-innovation-scout/` | Send to any AI |

### Usage Example

```
👤 User: Find innovation directions for diffusion models in materials design

🤖 Framework:
  Step 0: Input Classification → Type A, auto-advance
  Step 1: Scene Validation → 🟢 Strong evidence (survey + benchmark + top venues)
  Step 2: Literature Mining → 18 core papers
  Step 3-4: Paper Analysis + Cross-Synthesis → 5 innovation directions
  Step 5: Report Generation → 📄 report-diffusion-materials-*.md
```

---

## 🏗️ Six-Step Pipeline

![Architecture](./docs/architecture.svg)

| Step | Name | What It Does | Pause Condition |
|------|------|-------------|----------------|
| **Step 0** | Input Classification | Classify as Type A/B/C | Type B/C → pause for user choice |
| **Step 1** | Scene Validation | Search surveys/benchmarks/workshops | No evidence → terminate; multiple scenes → choose |
| **Step 2** | Literature Mining | Seed papers + forward/backward expansion + filtering | <5 papers → warn |
| **Step 3** | Paper Analysis | Four dimensions: Problem · Method · Contribution · Unresolved Issues | — |
| **Step 4** | Cross-Synthesis | Open Problem Pool + Methodology Map + Four Direction Types | — |
| **Step 5** | Report Generation | Write final report to `.md` file | Data self-consistency check |

### Four Innovation Direction Types

| Type | Description | Trigger |
|------|-------------|---------|
| 🔧 **Deepen & Optimize** | Improve within an existing paradigm | Method weaknesses or ablation gaps |
| 🔄 **Method Transfer** | Adapt methods from other fields | Similar problem structure or missing paradigm |
| 🗺️ **Gap Exploration** | Fill blanks in the method-problem matrix | Matrix `—` cells or multiple papers pointing to unsolved areas |
| 🔗 **Problem Grafting** | Connect with cross-domain concerns | Fairness, interpretability, efficiency, etc. |

---

## 🎯 Real-World Test Scenarios

| Scenario | Input | Result | Report |
|----------|------|--------|--------|
| ❄️ Extreme Cold | Topological Quantum Chemistry × Molecular Taste | ⚪ Correctly terminated, no fabrication | [View](reports/report-cold-topological-taste.md) |
| 🔥 Extreme Hot | LLM for Code Generation | 667→8 papers, 5 directions | [View](reports/report-hot-llm-code-gen.md) |
| ⚖️ Normal | Contrastive Learning × Molecular Prediction | 14 papers, 6 directions | [View](reports/report-medium-cl-mol.md) |

---

## 📊 Stats

- 🧩 6-step complete pipeline
- 📁 8 independent Skill files (any step usable standalone)
- 🔬 4 innovation direction types
- 🛡️ 4-layer anti-hallucination (scene / literature / analysis / direction)
- 🌐 6+ tool platforms supported
- 📄 3 extreme scenario validations passed

---

## 📁 Project Structure

```
research-opportunity-finder/
├── README.md                           # This file
├── README_zh-CN.md                     # 中文版 / Chinese
├── CLAUDE.md                           # Claude Code auto-load
├── FRAMEWORK.md                        # Methodology design doc
├── LICENSE                             # MIT
├── CHANGELOG.md / CONTRIBUTING.md / FAQ.md
├── scripts/
│   └── install.sh                      # Multi-tool one-click installer
├── skills/                             # AI Skill prompts (universal)
│   ├── research-innovation-scout.md    # Entry point
│   ├── step-0-input-classifier.md      # Input classification
│   ├── step-1-scene-validator.md       # Scene validation
│   ├── step-2-literature-miner.md      # Literature mining
│   ├── step-3-paper-analyzer.md        # Four-dimension breakdown
│   ├── step-4-cross-synthesizer.md     # Cross-paper synthesis
│   ├── step-5-report-generator.md      # Report generation
│   └── step-orchestrator.md            # Flow orchestrator
├── .codebuddy/skills/                  # CodeBuddy official format
├── docs/architecture.svg               # Pipeline diagram
└── reports/                            # Test reports
```

---

## 🎨 Design Philosophy

1. 🔬 **Anti-Hallucination First** — Scenes require survey/benchmark evidence; literature must be real; explicit ≠ inferred
2. 🌐 **Discipline-Agnostic** — Works across CS, medicine, materials, chemistry, and more
3. 🎮 **User-Controlled** — Pauses at ambiguous inputs; suggests, never decides
4. ⚡ **Edge-Case Robust** — Cold → terminate clearly; Hot → overflow truncation; Normal → full pipeline

---

## 🤝 Contributing

Issues and PRs welcome.

- Modify skill prompts: attach before/after comparison + cold/hot scenario tests
- Report bugs: provide reproduction steps and expected behavior
- Add tool support: follow `scripts/install.sh` pattern to add `install_<tool>` function

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📄 Changelog

| Version | Date | Content |
|---------|------|---------|
| v1.0 | 2026-05-21 | Initial release: complete six-step framework + anti-hallucination + overflow handling + multi-tool installer |

See [CHANGELOG.md](CHANGELOG.md).

---

## 📜 License

MIT License — use freely. See [LICENSE](LICENSE).

---

## 👤 Author

| Field | Info |
|-------|------|
| Author | cnb.lpk |
| Email | 4tdEacxA3Uip3zcDiU1QiA+cnb.lpk@noreply.cnb.cool |
| Repo | https://cnb.cool/lpk3215/research-opportunity-finder |

---

⭐ Star this repo • 🍴 Fork it • 🐛 Report an issue

Made with ❤️ for researchers everywhere
