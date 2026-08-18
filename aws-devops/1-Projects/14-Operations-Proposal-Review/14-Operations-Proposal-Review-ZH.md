---
title: 运维架构方案归纳与评审
language: zh-CN
translation_group: operations-proposal-review
translation_of: 14-Operations-Proposal-Review
translation_status: synchronized
status: proposed
decision: pending
para: project
updated: 2026-08-18
source_type: external-proposal
---

# 运维架构方案归纳与评审

[[14-Operations-Proposal-Review-ZH|中文]] · [[14-Operations-Proposal-Review-EN|English]] · [[14-Operations-Proposal-Review-VI|Tiếng Việt]]

> [!warning] 文档定位
> 本文归纳运维同事提交的目标状态方案，不代表该架构已经批准。附件中的命令、价格和配置均为参考资料；正式制度仍以 [[10-Release-Process-ZH|现行发布流程]] 及后续批准的架构决策为准。

## 一页结论

方案以四个 AWS Account 建立职责边界，在 Workload Account 内用 Production、Test、Tools 三个互不路由的 VPC 隔离环境，通过 PrivateLink 只发布指定服务；Ops 手动启动 Jenkins，Jenkins 构建和更新 Manifest，Argo CD 在私有 EKS 内同步状态。

方向与“私有工作负载、最小网络暴露、Ops 控制发布、完整审计”目标一致，可以作为目标架构候选。但在批准前必须解决管理网络闭环、Jenkins 权限矛盾、账号级隔离强度、GitOps 审批模型、HA/DR、集中安全治理和成本验证问题。

## 原始架构图

### 多账号与发布流程

![[34-Multi-Account-Architecture.png]]

### 网络与 CIDR

![[35-Network-Overview.png]]

### 路由与安全控制矩阵

![[36-Routing-Security-Matrix.png]]

### 第一版架构总览（用户提供）

该图作为本次运维方案评审的第一版架构参考资料归档；图中内容不代表已批准的实施基线，当前方案仍保持 `proposed / pending`。

![[32-AWS-Multi-Account-Architecture-Overview-v1-HD.jpg]]

## 账号与网络模型

| Account | 责任 | 主要网络与组件 |
| --- | --- | --- |
| Account 1 | Private Workloads | Production VPC `10.10.0.0/16`、Test VPC `10.40.0.0/16`、Tools VPC `10.50.0.0/16`；EKS、数据服务、Argo CD、GitLab/Jenkins/ECR/Nexus |
| Account 2 | Operations & Security | Operations VPC `10.20.0.0/16`；VPN/Direct Connect、SSM、CloudTrail、Security Hub、GuardDuty、Central Logs、Break-glass |
| Account 3 | Production Entry | Production Entry VPC `10.30.0.0/16`；Cloudflare、Public ALB、Nginx/API Gateway、Interface Endpoint |
| Account 4 | Test Entry | Test Entry VPC `10.60.0.0/16`；内部 VPN、Internal ALB、Nginx、Private DNS、Interface Endpoint |

明确隔离原则：

- Production、Test 与 Tools VPC 之间不配置 Peering、TGW 路由或直接访问。
- 私有数据子网仅允许相应 Application Security Group 访问。
- Entry Account 不得访问私有数据库。
- 私有 Security Group 禁止 `0.0.0.0/0` 入站。
- AWS API 访问通过 VPC Endpoint；应用入口跨账号使用 PrivateLink HTTPS 443。

## 关键流量路径

```text
Production:
Users → Cloudflare CDN/WAF → Public ALB → Nginx/API Gateway
→ Interface VPC Endpoint → PrivateLink → Endpoint Service
→ Internal NLB → Private Production Workload

Test:
Internal Tester → VPN → Internal ALB → Nginx
→ Interface VPC Endpoint → PrivateLink → Endpoint Service
→ Internal NLB → Private Test Workload

Operations:
Ops + MFA → VPN/Direct Connect → Operations Account
→ SSM / Approved Management Endpoint → Private Management Plane
```

## 提议的发布流程

```text
Developer Push → GitLab Review/Merge
→ Ops Manually Starts Jenkins
→ Jenkins Pulls Approved Code
→ Build/Test/SAST/SCA/Container Scan
→ Push ECR/Nexus → Update Helm Manifest
→ Argo CD Pull/Sync → Private EKS
```

方案明确：Developer 无 AWS/EKS/kubectl 权限；GitLab 不通过 Webhook 自动触发 Jenkins；只有 Ops 可以启动 Jenkins；Jenkins 不直接部署 Kubernetes；Argo CD 执行声明式同步。

## 值得保留的设计

- Private Workload Account 不提供公网工作负载入口。
- PrivateLink 将跨账号暴露限制在具体服务，而不是开放整个 VPC CIDR。
- Production/Test/Tools 无横向路由，降低跨环境移动风险。
- Entry、Workload、Operations 职责分离，便于审计和故障域控制。
- Developer 与 CI 不持有常规直接部署权限，Argo CD 采用 AWS 内部 Pull 模式。
- MFA、短期凭证、SSM、CloudTrail、GuardDuty、Security Hub 和 Break-glass 被纳入总体设计。

## 必须澄清的矛盾与缺口

### P0 — 批准前必须解决

1. **Jenkins 权限矛盾**：报告称 Jenkins 无 EKS 直接部署权限，但安全矩阵允许 `Operations CIDR / Jenkins role → Private EKS API : TCP 443`。应删除 Jenkins 对 EKS API 的访问，或明确其不可绕过 Argo CD 的必要只读用途及 Kubernetes RBAC。
2. **管理路由未闭环**：方案同时声明无 Peering/TGW 路由，又要求 Operations Account 管理 Private EKS。必须明确实际机制，例如独立管理 PrivateLink 服务、TGW 管理域、Client VPN/Direct Connect 路由或其他受控路径，并给出 Route Table、DNS 和 Security Group 规则。
3. **GitOps 写入与审批边界不清**：Jenkins 更新 Helm Manifest，因此 Jenkins 对发布仓库具有写权限。需明确它只能创建 Release PR，不能直接写受保护生产分支；Ops/CODEOWNERS 完成审批和合并后 Argo CD 才能同步。
4. **生产与测试仍在同一 AWS Account**：当前隔离主要依赖 VPC、IAM 和 EKS RBAC，不是账号级边界。需正式接受该风险，或将 Production、Test、Tools 拆为独立账号。
5. **图中的人工 Jenkins 流程与既有 GitOps 提案不同**：需决定“Ops 手动启动 Jenkins”还是“CI 自动构建、Ops 只批准 Release PR”；不要同时保留两套唯一发布流程。

### P1 — 设计阶段补齐

- 明确 Cloudflare 到 ALB 的 Origin Protection：仅允许 Cloudflare IP、Authenticated Origin Pull/mTLS、Header 校验及绕过防护。
- 明确 TLS 终止点、证书责任和 NLB/PrivateLink 后端加密方式；PrivateLink 本身不等于应用层 HTTPS 策略。
- 补充 ECR/Nexus 的唯一职责、Artifact digest、Tag Immutability、签名、SBOM 和 Admission Policy。
- 补充 AWS Organizations/Control Tower、SCP、集中 Log Archive/Security Account 和委派管理员设计。
- 定义 DNS Resolver、Endpoint Policy、KMS Key Policy、Secret 轮换、Egress、Network Firewall/WAF 规则。
- 定义 EKS、Argo CD、Jenkins、GitLab、Nexus/ECR、RDS、Redis、MSK 的 HA、备份、RPO/RTO 和灾难恢复。
- 将 Break-glass 扩展为双人控制、离线硬件 MFA、实时告警、使用后轮换和季度演练。

## 成本资料的正确用法

报告中的新加坡区域规划示例为：VPC Peering 固定连接费约 `USD 0/月`；PrivateLink 示例约 `USD 29.20/月`，加 1 TB 数据后约 `USD 39.44/月`；四个 TGW Attachment 示例加 1 TB 数据约 `USD 166.48/月`。这些数字未包含 NLB、跨 AZ、DNS、日志、监控及其他 Interface Endpoint 成本，且必须在决策前使用当前 AWS Pricing Calculator 重新验证。

该方案选择 PrivateLink 的主要理由应是服务级隔离，而不是最低成本。

## 建议决策

> [!tip] 推荐
> 将方案状态维持为 `proposed / pending`，在完成 P0 闭环后进行一次 Architecture Review。网络方向可原则接受；发布流程需与 [[11-GitOps-Architecture-Review-ZH|GitOps 架构评审]] 合并成单一权威版本。

建议评审输出：

- [ ] 最终 Account/VPC 边界与 CIDR 表
- [ ] 可验证的 Route Table、Endpoint、DNS、SG/NACL 流量矩阵
- [ ] Ops 到 EKS 管理面的唯一受控路径
- [ ] Jenkins、Argo CD、GitLab 与 Ops 的 IAM/RBAC 权限矩阵
- [ ] Production Release 与 Rollback 的唯一状态机
- [ ] HA/DR、日志、安全治理和成本基线
- [ ] 威胁模型与上线前验收测试

## 相关笔记

- [[20-Account-Architecture-ZH|架构与账户规划]]
- [[11-GitOps-Architecture-Review-ZH|GitOps 发布架构评审]]
- [[21-Bastion-Access-Architecture-ZH|堡垒机访问架构]]
- [[22-Break-Glass-Access-ZH|破窗账户管理]]
- [[10-Release-Process-ZH|现行发布流程]]
