---
title: 破窗账户管理
tags:
  - aws
  - iam
  - emergency-access
status: draft
language: zh-CN
translation_group: break-glass-access
translation_of: 22-Break-Glass-Access
translation_status: synchronized
para: area
updated: 2026-08-16
---

# 破窗账户管理

[[22-Break-Glass-Access-ZH|中文]] · [[22-Break-Glass-Access-EN|English]] · [[22-Break-Glass-Access-VI|Tiếng Việt]]

## 使用条件

仅在网络中断、数据中心断电或常规 Ops 渠道完全不可用时启用。

## 保管和启用

- 两名独立保管人分别保存认证要素，必须双人授权。
- 使用独立硬件 MFA，凭证离线密封保存。
- 不将凭证写入脚本、堡垒机或日常共享密码库。
- 启用时立即触发安全告警并建立事件记录。
- 使用后立即吊销会话、轮换凭证并完成复盘。
- 每季度进行受控演练，验证 SCP 和信任策略不会阻断紧急访问。

## 启用记录

| 字段 | 内容 |
| --- | --- |
| 事件编号 |  |
| 启用原因 |  |
| 两名批准人 |  |
| 启用时间 |  |
| 停用时间 |  |
| 执行操作 |  |
| 凭证轮换记录 |  |
| 审计报告 |  |

## 相关笔记

- [[10-Release-Process|发布流程]]
- [[21-Bastion-Access-Architecture|堡垒机访问架构]]
- [[00-Index|AWS 部署索引]]
