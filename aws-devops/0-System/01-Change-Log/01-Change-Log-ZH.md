---
title: 变更日志
tags:
  - aws
  - changelog
  - audit
status: active
language: zh-CN
translation_group: change-log
translation_of: 01-Change-Log
translation_status: synchronized
updated: 2026-08-16
document_role: changelog
---

# 变更日志

[[01-Change-Log-ZH|中文]] · [[01-Change-Log-EN|English]] · [[01-Change-Log-VI|Tiếng Việt]]

## 2026-08-16 — 运维方案资料归档与评审

- 归档中、越文架构报告和三张 A3 架构图，并记录 SHA-256。
- 新建三语运维架构方案评审，归纳账号、网络、发布、成本和安全控制。
- 标记 Jenkins/EKS 权限、管理路由、GitOps 写入边界和账号隔离等批准前问题。
- 保持方案为 `proposed / pending`，未改变现行发布制度。

## 2026-08-16 — 主题目录归并

- 将 PARA 目录统一改为数字和英文连字符格式。
- 将每个主题的路由页及 ZH、EN、VI 文件归入独立主题目录。
- 将系统文档、日志、语言指南和架构图片分别集中管理。
- 更新 Manifest、AGENTS 和 README 中的全部权威路径。

## 2026-08-16 — 补充架构图

- 将上传的 Dual Bastion 和 GitOps 架构图保存到 `3 Resources`。
- 将两张图同步嵌入对应的中、英、越文档。
- 在机器清单中登记用途和 SHA-256。

## 2026-08-16 — 三语迁移完成

- 为所有业务与运维主题生成 ZH、EN、VI 三份语言文件。
- 为每个主题保留无语言后缀的稳定路由页。
- 所有语言文件增加语言切换链接和翻译元数据。
- 文档清单更新为 `complete / synchronized`。

## 2026-08-16 — 三语文档规范

- 确认采用三文件模式支持中文、English 和 Tiếng Việt。
- 在 `AGENTS.md` 中加入强制三语同步、默认语言、术语和安全规则。
- 在文档清单中加入语言后缀、语义一致性和切换要求。
- 新增语言维护指南；翻译未完成的文件不得标记为已同步。

## 2026-08-16 — 文件命名规范

- 将知识库正文改为数字前缀与英文文件名。
- 保留中文标题和 Obsidian 中文显示文本。
- 保留 `AGENTS.md` 与 `README.md` 标准发现文件名。
- `.obsidian/plugins` 为第三方插件文件，不参与改名。

## 2026-08-16

### PARA 与 AI 读取规范

- 将文档重组为 `1 Projects`、`2 Areas`、`3 Resources`、`4 Archives`。
- 新建根索引、README、AGENTS 和机器可读文档清单。
- 为正文补充 `para` 与 `updated` 元数据。
- 将旧版索引移入 Archives，保留历史记录和链接兼容性。

### GitOps 架构评审

- 记录运维团队提出的 GitOps 发布方案。
- 评审结论为原则上推荐，但状态保持 `proposed / pending`。
- 补充 Git、Artifact、Argo CD、EKS、Secret、审计和验收控制项。
- 明确当前手工发布基线与推荐 GitOps 方案之间的政策冲突。

### 初始文档

- 建立发布流程、双堡垒访问、破窗账户、部署检查清单和变更单模板。

## 记录规则

每次文档变更按日期追加，至少记录：

- 修改内容
- 修改原因
- 受影响文档
- 决策状态是否改变
- 修改人或执行主体（如可获得）

## 相关笔记

- [[00-Index|AWS 部署索引]]
- [[11-GitOps-Architecture-Review|GitOps 发布架构评审]]
- [[10-Release-Process|发布流程]]
