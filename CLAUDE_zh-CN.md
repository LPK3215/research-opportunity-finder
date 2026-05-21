# Claude 项目记忆

本仓库以 Claude Code Skills 作为主要项目入口：

- 英文 Skill：`.claude/skills/research-innovation-scout/SKILL.md`
- 中文 Skill：`.claude/skills/research-innovation-scout-zh-cn/SKILL.md`

当用户要求寻找科研创新方向、研究选题、文献支撑的 gap、场景校验、文献检索、论文拆解、综合分析或决策报告时，使用对应 Skill。

本文件保持轻量。完整工作流放在 Skill 文件夹中，让 Claude 只在需要时加载详细步骤。

核心行为：

- 每个判断都要有可验证的场景证据或文献证据。
- 证据缺失或证据较弱时必须明确说明。
- 不得编造论文、会议、数据集、benchmark、指标、引用、作者结论或作者局限。
- 除非用户要求完整运行，否则一次只执行一个工作流步骤。
- Skill 规则要求暂停时，必须等待用户选择。
