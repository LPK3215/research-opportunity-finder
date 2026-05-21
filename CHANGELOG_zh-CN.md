# 更新日志

本项目的重要变化会记录在这里。

## [未发布]

### 变更

- 新增 GitHub 仓库元信息和公开项目链接。
- 将架构图、示例报告、文档和 Skill 提示词拆分为中英文版本。
- 安装脚本新增 `./scripts/install.sh --lang en|zh-CN` 语言选择。
- 新增 `.claude/skills/` 下的 Claude Code 项目 Skill。
- 新增 `skills/codex/` 下的 Codex/OpenAI `SKILL.md` + `references/` 包。
- 新增 `.cursor/rules/` 下的 Cursor 项目规则。
- 调整安装优先级：Claude Code、Codex、Cursor 为主入口，CodeBuddy 仅作为兼容支持。
- 新增 GitHub Issue 和 Pull Request 模板。
- 新增 `.gitattributes`，保证 shell 脚本在 Windows 和 GitHub 上保持 LF 换行。

## [v1.0] — 2026-05-21

### 新增

- 完整的 6 步科研创新方向发现框架（Step 0-5）
- `skills/research-innovation-scout.md` 统一入口
- 7 个独立步骤 Skill 文件，包含完整操作逻辑
- 防幻觉设计：在每个层级区分 explicit / inferred
- 冷门、热门、正常三类场景压力测试，以及溢出处理
- 决策支持报告自动生成并写入文件
- `reports/` 中提供三份测试报告展示框架行为
- MIT License

### 设计

- 学科无关：适用于 CS、医学、材料、化学等领域
- 四类创新方向：深化、迁移、无人区、嫁接
- 模糊输入时暂停，保留用户控制权
- 报告生成阶段加入数据自洽性规则
