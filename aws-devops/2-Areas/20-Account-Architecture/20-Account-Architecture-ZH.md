---
title: 架构与账户规划
tags:
  - aws
  - architecture
status: draft
language: zh-CN
translation_group: account-architecture
translation_of: 20-Account-Architecture
translation_status: synchronized
para: area
updated: 2026-08-16
---

# 架构与账户规划

[[20-Account-Architecture-ZH|中文]] · [[20-Account-Architecture-EN|English]] · [[20-Account-Architecture-VI|Tiếng Việt]]

## 建议账户结构

| 账户 | 用途 | 关键控制 |
| --- | --- | --- |
| Operations | 集中身份、运维入口和审计 | MFA、STS、最小权限 |
| Workload | 应用、EKS、RDS、Kafka | 私有子网、无公网管理入口 |
| Production Entry | 生产流量入口 | ALB/NLB、WAF、PrivateLink |
| Test Entry | 测试流量入口 | Internal ALB、Private DNS |

## 待确认

- [ ] AWS Organizations 与 SCP 设计
- [ ] Region 与可用区
- [ ] VPC、子网和路由规划
- [ ] 域名、证书与入口流量
- [ ] 日志归档账户与保留周期
- [ ] 备份、RPO 和 RTO
- [ ] 成本预算与告警阈值

## 相关笔记

- [[00-Index|AWS 部署索引]]
- [[21-Bastion-Access-Architecture|堡垒机访问架构]]
- [[10-Release-Process|发布流程]]
