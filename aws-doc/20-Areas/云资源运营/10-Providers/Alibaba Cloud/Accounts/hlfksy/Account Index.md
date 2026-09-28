---
type: cloud-account
provider: aliyun
account_id: hlfksy
account_name:
company: 和联
console_url: https://bsn.console.aliyun.com/?spm=a2c4g.11186623.0.0.75013755i2K4Js#/bsnManagement
status: active
owner:
created: 2026-08-15
tags:
  - cloud/aliyun
  - asset/account
---
# 阿里云账号 · hlfksy

> 所属公司：和联

## 产品与资源

打开 [[20-Areas/云资源运营/10-Providers/Alibaba Cloud/Accounts/hlfksy/Account Resources.base|账号资源视图]]，默认按产品分组。

- ECS：1

## 控制台入口

- [阿里云 BSN 管理控制台](https://bsn.console.aliyun.com/?spm=a2c4g.11186623.0.0.75013755i2K4Js#/bsnManagement)

## 治理清单

- [ ] 补充账号负责人和紧急联系人
- [ ] 核对 RAM 最小权限与 MFA
- [ ] 核对费用预警、余额预警和到期通知
- [ ] 核对 ActionTrail/操作审计与日志留存

## 安全边界

本笔记只记录账号标识与治理状态，不记录密码、AccessKey Secret、MFA 恢复码或私钥。

相关：[[20-Areas/云资源运营/10-Providers/Alibaba Cloud/Alibaba Cloud Index|阿里云]] · [[20-Areas/云资源运营/云资源运营 Index]]



| 序号  | 资源类型    | 资源 ID / 范围               | 关联业务                     | 当前建议      | 预计退款/节省（元） | 备注                           |
| --- | ------- | ------------------------ | ------------------------ | --------- | ---------- | ---------------------------- |
| 1   | 云服务器    | `i-8vb3cdceix4eab1fizt6` | JumpServer               | 取消续费，暂时保留 | 102.27     | 原始记录称“退款金额”，需确认取消续费后是否确实产生退款 |
| 2   | 云服务器    | `i-8vbgff16qyll3g0t6ezm` | JumpServer               | 释放        | 460.712    | 建议释放前确认无业务依赖                 |
| 3   | 云服务器    | `i-j6cfu9523qud8c25m3k1` | Hydrus、千钧盾、25 网段、梨花汇、蜻蜓集 | 评估退款      | 803.10     | 涉及领取京东 E 卡；需确认退款条件及业务影响      |
| 4   | WAF     | Web 应用防火墙                | 未注明                      | 评估停用或降配   | 1,317.20   | 清单中金额最高的优化项                  |
| 5   | 弹性公网 IP | 15 个未使用 IP               | 未注明                      | 暂时保有      | 105.00     | 若继续保有，预计节省可能无法实现             |
