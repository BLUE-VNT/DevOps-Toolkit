# 多云资源知识库

这是一个使用 Obsidian 管理阿里云、AWS 和腾讯云账号、产品与资源的本地知识库。

## 开始使用

- 人工浏览：打开 [[Index]]
- AI Agent：先读取 [`AGENTS.md`](AGENTS.md)
- 仓库技能：`skills/manage-cloud-vault/SKILL.md`
- 目录与数据规范：[[70-Maps/目录结构与 Agent 协作指南]]
- 历史执行记录：[[Log]]

资源按照“云厂商 → 账号 → 产品 → 具体资源”组织，并由 Obsidian Bases 自动汇总。不要在本仓库保存密码、AccessKey Secret、私钥或会话令牌。

## 一键提交并推送

在仓库根目录执行：

```bash
./scripts/git-push.sh "更新说明"
```

不传提交信息时，脚本会自动生成带时间的提交信息。脚本会先执行 `git diff --check`，确认当前分支和 `origin` 远端后，再执行提交和推送。
