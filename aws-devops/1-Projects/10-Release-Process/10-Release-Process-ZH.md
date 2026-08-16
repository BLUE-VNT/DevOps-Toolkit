---
title: 发布流程
tags:
  - aws
  - release
  - operations
status: approved-baseline
language: zh-CN
translation_group: release-process
translation_of: 10-Release-Process
translation_status: synchronized
para: project
updated: 2026-08-16
---

# 发布流程

[[10-Release-Process-ZH|中文]] · [[10-Release-Process-EN|English]] · [[10-Release-Process-VI|Tiếng Việt]]

> [!warning] 架构决策待确认
> 当前基线要求 Ops 通过双堡垒机手工执行发布。运维团队提出的 [[11-GitOps-Architecture-Review|GitOps 发布架构评审]] 建议改为“Ops 授权、Argo CD 执行”，以消除堡垒机和办公室网络对正常发布及回滚的单点依赖。在正式审批前，本页仍代表现行基线。

## 唯一发布渠道

1. Developer 提交变更单、版本制品及 SHA-256 校验值。
2. Ops 审核变更范围、测试结果、部署步骤和回滚方案。
3. 审批通过后，Ops 在规定发布窗口进入运维网络。
4. Ops 通过双层堡垒机，以个人身份和临时凭证进入目标 AWS 账户。
5. Ops 执行部署、健康检查和必要的回滚。
6. Ops 将结果、日志位置和实际版本写回变更单并关闭发布。

> [!danger] 权限边界
> Developer 不得拥有生产或测试环境的部署权限，也不得直接访问部署服务器、SSM 会话或 Kubernetes 写入接口。

## 必需证据

- 变更单与审批记录
- Artifact 地址、版本和摘要
- VPN 与堡垒机会话记录
- STS Role Session 与 CloudTrail 事件
- SSM、EKS 或部署流水线日志
- 发布验证或回滚结果

## 相关笔记

- [[11-GitOps-Architecture-Review|GitOps 发布架构评审]]
- [[13-Change-Request-Template|变更单模板]]
- [[12-Deployment-Checklist|部署检查清单]]
- [[21-Bastion-Access-Architecture|堡垒机访问架构]]
- [[22-Break-Glass-Access|破窗账户管理]]
