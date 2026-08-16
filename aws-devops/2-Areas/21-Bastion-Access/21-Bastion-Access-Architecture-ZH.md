---
title: 堡垒机访问架构
tags:
  - aws
  - bastion
  - security
status: draft
language: zh-CN
translation_group: bastion-access-architecture
translation_of: 21-Bastion-Access-Architecture
translation_status: synchronized
para: area
updated: 2026-08-16
---

# 堡垒机访问架构

[[21-Bastion-Access-Architecture-ZH|中文]] · [[21-Bastion-Access-Architecture-EN|English]] · [[21-Bastion-Access-Architecture-VI|Tiếng Việt]]

## 架构图

![[30-Dual-Bastion-Architecture.png]]

> [!note] 图示说明
> 本图描述公司网络、MFA VPN、双 Mac mini 堡垒层、Operations Account 和目标 AWS Accounts 之间的访问关系。正文中的安全规则和正式决策优先于图中示例参数。

> [!info] 建议的职责边界
> 双堡垒机适合保护人工 Administrative Access、故障排查和紧急操作，不宜天然成为应用发布引擎的唯一依赖。正常应用发布可由 [[11-GitOps-Architecture-Review|GitOps 发布架构评审]] 中的 AWS 内部 Pull 模式承担，最终以正式架构决策为准。

## 访问链路

```text
公司设备 → 办公网 → MFA VPN → 运维隔离网
→ Mac mini #1（VPN/跳板层）
→ Mac mini #2（运维工作站）
→ AWS Operations Account
→ AssumeRole → 目标 AWS Account
```

## 控制要求

- Mac mini #1 不配置 AWS CLI、kubectl 或开发工具。
- Mac mini #2 仅允许从 Mac mini #1 访问，并由 MDM、FileVault 和 EDR 管理。
- AWS 使用个人身份、MFA 和 STS 临时凭证，禁止共享账户。
- 生产与测试使用独立角色；生产操作应增加二次审批。
- CloudTrail、SSM、EKS Audit Log 和堡垒机会话日志集中保存。
- 安全组的固定来源 IP 只是网络限制，不能代替人员身份认证。

## 网络设计待办

- [ ] 明确 AWS Console/API 的受控出口或 PrivateLink 路径
- [ ] 定义 DNS、代理和 VPC Endpoint 清单
- [ ] 定义管理平面允许的端口和目标域名
- [ ] 验证运维网络不可访问非必要互联网资源

## 相关笔记

- [[20-Account-Architecture|架构与账户规划]]
- [[11-GitOps-Architecture-Review|GitOps 发布架构评审]]
- [[10-Release-Process|发布流程]]
- [[22-Break-Glass-Access|破窗账户管理]]
