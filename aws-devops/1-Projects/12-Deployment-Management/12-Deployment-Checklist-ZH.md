---
title: 部署检查清单
tags:
  - aws
  - checklist
  - release
status: active
language: zh-CN
translation_group: deployment-checklist
translation_of: 12-Deployment-Checklist
translation_status: synchronized
para: project
updated: 2026-08-16
---

# 部署检查清单

[[12-Deployment-Checklist-ZH|中文]] · [[12-Deployment-Checklist-EN|English]] · [[12-Deployment-Checklist-VI|Tiếng Việt]]

## 发布前

- [ ] 变更单已经审批
- [ ] Artifact 版本与 SHA-256 已核验
- [ ] 测试、安全扫描和兼容性检查通过
- [ ] 数据库变更已经评审
- [ ] 回滚步骤已经验证
- [ ] 监控、告警和维护窗口已经确认
- [ ] Ops 操作人员和复核人员已经指定

## 发布中

- [ ] 使用个人身份和 MFA 登录
- [ ] 通过规定的双堡垒路径访问
- [ ] 使用目标环境对应的临时角色
- [ ] 记录开始时间和实际执行命令
- [ ] 部署后执行健康检查与冒烟测试

## 发布后

- [ ] 确认应用、依赖和关键指标正常
- [ ] 确认日志与审计事件已写入集中存储
- [ ] 更新变更单的实际版本和结果
- [ ] 结束临时会话并移除临时授权
- [ ] 发生异常时完成回滚与事件复盘

## 相关笔记

- [[10-Release-Process|发布流程]]
- [[13-Change-Request-Template|变更单模板]]
