---
title: AWS 部署索引（旧版）
aliases:
  - Legacy AWS Deployment Index
tags:
  - aws
  - devops
  - index
status: active
language: zh-CN
translation_group: legacy-index
translation_of: 90-Legacy-Index
translation_status: synchronized
para: archive
archived: 2026-08-16
---

# AWS 部署索引（旧版）

[[90-Legacy-Index-ZH|中文]] · [[90-Legacy-Index-EN|English]] · [[90-Legacy-Index-VI|Tiếng Việt]]

> [!warning] 已归档
> 当前入口为 [[00-Index|AWS 部署索引]]。

> [!info] 用途
> 本目录用于维护 AWS 架构、发布控制、操作手册和审计记录。

## 架构与访问

- [[20-Account-Architecture|架构与账户规划]]
- [[21-Bastion-Access-Architecture|堡垒机访问架构]]
- [[22-Break-Glass-Access|破窗账户管理]]

## 发布与变更

- [[10-Release-Process|发布流程]]
- [[11-GitOps-Architecture-Review|GitOps 发布架构评审]]
- [[12-Deployment-Checklist|部署检查清单]]
- [[13-Change-Request-Template|变更单模板]]

## 基本原则

- Ops 是生产与测试发布的唯一授权与批准方；实际执行机制以正式批准的架构决策为准。
- Developer 只提交变更单和不可变版本制品，不拥有部署权限。
- 人工管理操作通过受控堡垒机、个人身份和短期凭证执行。
- 发布行为必须能够关联到审批、制品摘要和审计日志。
