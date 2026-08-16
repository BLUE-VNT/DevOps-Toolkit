---
title: AWS 部署索引
aliases:
  - AWS Deployment Index
  - AWS 部署索引
tags:
  - aws
  - devops
  - index
  - para
status: active
language: zh-CN
translation_group: index
translation_of: 00-Index
translation_status: synchronized
updated: 2026-08-16
document_role: canonical-index
---

# AWS 部署索引

[[00-Index-ZH|中文]] · [[00-Index-EN|English]] · [[00-Index-VI|Tiếng Việt]]

> [!info] 当前状态
> GitOps 架构处于提案阶段，尚未替代现行“双堡垒机手工发布”基线。参见 [[11-GitOps-Architecture-Review|GitOps 发布架构评审]]。

## 快速读取

1. [[10-Release-Process|发布流程]]：现行发布基线
2. [[11-GitOps-Architecture-Review|GitOps 发布架构评审]]：推荐方案、差距与待决策项
3. [[14-Operations-Proposal-Review-ZH|运维架构方案归纳与评审]]：外部方案、矛盾、风险和决策门槛
4. [[21-Bastion-Access-Architecture|堡垒机访问架构]]：人工管理访问边界
5. [[22-Break-Glass-Access|破窗账户管理]]：严重紧急访问控制
6. [[01-Change-Log|变更日志]]：文档修改历史

## 1 Projects

有明确目标、交付结果或完成条件的工作：

- [[11-GitOps-Architecture-Review|GitOps 发布架构评审]] — `proposed / pending`
- [[14-Operations-Proposal-Review-ZH|运维架构方案归纳与评审]] — `proposed / pending`
- [[10-Release-Process|发布流程]] — `approved-baseline`
- [[12-Deployment-Checklist|部署检查清单]] — `active`
- [[13-Change-Request-Template|变更单模板]] — `template`

## 2 Areas

需要长期维护的运维责任域：

- [[20-Account-Architecture|架构与账户规划]]
- [[21-Bastion-Access-Architecture|堡垒机访问架构]]
- [[22-Break-Glass-Access|破窗账户管理]]

## 3 Resources

参考资料、外部标准、图示和调研材料。目前为空；新增资料时应注明来源与访问日期。

## 4 Archives

- [[90-Legacy-Index|旧版 AWS 部署索引]]

## 权威原则

- Ops 是 Production/Test 发布的唯一授权与批准方。
- Developer 和 CI 不得持有 AWS/EKS 部署权限。
- 人工管理访问必须经过受控堡垒路径。
- 正常发布是手工还是 GitOps 执行，仍待正式架构决策。
- 任何生产变更必须关联变更单、审批、Commit 和 Artifact digest。

## AI 导航

- AI 读取规范：`AGENTS.md`
- 机器可读清单：`02-Document-Manifest.yaml`
- 人类快速说明：`README.md`
- 变更历史：[[01-Change-Log|变更日志]]
