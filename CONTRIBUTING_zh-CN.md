# 为 Research Innovation Scout 做贡献

感谢你愿意参与改进这个项目。

## 如何贡献

### 提交 Issue

- 先搜索已有 Issue，避免重复提交
- 提供复现步骤、期望行为和实际行为
- 如果是 Skill 提示词问题，请附上触发问题的完整输入

### 提交修改

1. Fork 本仓库
2. 创建功能分支：`git checkout -b feat/your-feature-name`
3. 完成修改
4. 提交前充分测试
5. 发起 Pull Request，并写清楚修改目的和影响范围

### Pull Request 要求

- 每个 PR 尽量只包含一个功能或修复
- Commit 信息保持清晰，中英文均可，但同一个 PR 内建议统一语言
- 如果修改影响用法，请同步更新文档
- 如果修改 `skills/step-*.md`，请在 PR 描述中附上修改前后示例

### Skill 提示词修改规则

修改 Skill 文件时：

1. 保持各步骤之间的格式一致性。例如 Step 3 的输出格式变化时，需要同步更新 Step 4 和 Step 5
2. 保留防幻觉约束，不要削弱 explicit / inferred 的区分
3. 提交前至少测试 2 个场景：一个冷门场景，一个热门场景
4. 如果方法论变化，请同步更新 `FRAMEWORK.md`

### 行为准则

- 保持尊重和建设性
- 默认对方是善意的
- 聚焦问题和工作本身

## 有问题？

可以开启 Discussion，也可以在 Issue 中说明你的问题。
