# Contributing to Research Innovation Scout

Thanks for your interest in contributing!

## How to Contribute

### Reporting Issues

- Search existing issues first to avoid duplicates
- Include the steps to reproduce, expected vs actual behavior
- For skill prompt issues, include the exact input that caused the problem

### Proposing Changes

1. **Fork** the repository
2. Create a feature branch: `git checkout -b feat/your-feature-name`
3. Make your changes
4. **Test** your changes thoroughly before submitting
5. Submit a **Pull Request** with a clear description

### Pull Request Guidelines

- Keep PRs focused — one feature or fix per PR
- Write clear commit messages (prefer Chinese or English, be consistent)
- Update documentation if your change affects usage
- If modifying skill prompts (`skills/step-*.md`), include a before/after example in the PR description

### Skill Prompt Modification Rules

When editing skill files:

1. **Maintain consistency** across all step files — if you change the output format of Step 3, update Step 4 and Step 5 accordingly
2. **Preserve the anti-hallucination constraints** — never remove or weaken the explicit/inferred distinction
3. **Test with at least 2 scenarios** (cold + hot) before submitting
4. **Update FRAMEWORK.md** if the methodology changes

### Code of Conduct

- Be respectful and constructive
- Assume good intent
- Focus on the work, not the person

## Questions?

Open a Discussion or email the maintainer.
