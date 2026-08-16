---
title: GitOps 发布架构评审
aliases:
  - AWS Multi-Account GitOps Architecture Review
tags:
  - aws
  - gitops
  - eks
  - security
  - architecture-decision
status: proposed
decision: pending
language: zh-CN
translation_group: gitops-architecture-review
translation_of: 11-GitOps-Architecture-Review
translation_status: synchronized
para: project
updated: 2026-08-16
---

# GitOps 发布架构评审

[[11-GitOps-Architecture-Review-ZH|中文]] · [[11-GitOps-Architecture-Review-EN|English]] · [[11-GitOps-Architecture-Review-VI|Tiếng Việt]]

## 架构图

![[31-GitOps-Architecture.png]]

> [!note] 图示说明
> 本图展示 Developer、GitLab、CI/Jenkins、Artifact Repository、Ops Approval、Argo CD、Private EKS、Dual Bastion 和 Break-glass 的职责边界。它是提案图，不代表 GitOps 已获批准。

## 结论

> [!success] 推荐意见
> 原则上建议采用，但须完成本文的强制控制项并通过正式架构与安全审批。该方案保留 Ops 对发布的控制权，将发布执行从人工命令改为 Argo CD 对已批准 Git 状态的同步。

它合理地拆分了两个安全机制：

- **Application Deployment**：Git PR → Ops Approval → Argo CD → Private EKS
- **Administrative Access**：Ops → VPN/MFA → Dual Bastion → AWS

这能降低办公室停电、ISP、VPN、Mac mini 或运维局域网故障对正常发布和回滚的影响，同时保留职责分离和完整审计链。

## 目标职责边界

| 主体 | 职责 | 明确禁止 |
| --- | --- | --- |
| Developer | 编码、Branch、代码 PR、Release PR 发起 | AWS Credential、kubectl、EKS Access、合并生产发布 |
| GitLab | Source、Manifest、PR、审批与历史 | 绕过分支保护的直接写入 |
| CI/Jenkins | Build、Test、SAST/SCA、镜像扫描、签名和推送制品 | EKS Credential、生产部署权限、生产分支合并权限 |
| ECR/Nexus | 保存不可变且可验证的 Artifact | 覆盖已发布版本、未授权删除 |
| Ops | Review、Approve、Merge、Rollback 授权 | 使用共享身份或未审计的直接变更 |
| Argo CD | 从 Git 拉取并同步已批准 Desired State | 修改 Git、获取超出目标环境的权限 |
| Dual Bastion | 管理、排障、受控人工操作 | 成为正常发布唯一执行依赖 |
| Break-glass | 常规渠道失效时的严重紧急恢复 | 日常发布和普通排障 |

## 推荐发布流

```text
Developer → Code PR → CI Build/Test/Scan
→ Signed Artifact by Digest → ECR/Nexus
→ Release PR → Ops Approval → Protected Merge
→ Argo CD Pull/Reconcile → Private EKS
```

## 推荐回滚流

```text
Incident → Rollback PR → Ops Approval
→ Protected Merge → Argo CD Reconcile
→ Previous Artifact Digest
```

如果 GitLab、Argo CD 或其身份链路同时故障，才进入已批准的紧急操作程序；人工修复后必须回写 Git，避免 Desired State 再次覆盖现场状态。

## 强制安全控制

### Git 与审批

- [ ] Production/Test Manifest 使用独立受保护分支或独立发布仓库。
- [ ] 通过 CODEOWNERS 强制 Ops 审批，Production 建议两人审批。
- [ ] 禁止直接 Push、强制 Push、删除保护分支和审批者自批。
- [ ] 限制 Maintainer/Admin 绕过规则，并定期审计例外权限。
- [ ] 每个 Release PR 必须关联变更单、CI 结果和 Artifact digest。
- [ ] CI 可创建 Release PR，但不能批准或合并生产 PR。

### Artifact 与供应链

- [ ] ECR 开启 Tag Immutability，生产 Manifest 使用 image digest，不仅使用 tag。
- [ ] 生成并保存 SBOM、SAST/SCA 和容器扫描结果。
- [ ] 对镜像和 Helm Artifact 签名，并在部署准入阶段验证签名与来源。
- [ ] 设置漏洞阻断阈值、例外审批和例外有效期。
- [ ] ECR/Nexus 的删除、复制及生命周期策略具有独立权限和审计。

### Argo CD 与 EKS

- [ ] Argo CD 在私有网络运行，EKS API 不向 Developer 或 CI 开放。
- [ ] Git 凭证只读、按仓库隔离，并建立轮换机制。
- [ ] 使用 IRSA 或 EKS Pod Identity，禁止静态 AWS Access Key。
- [ ] Argo CD Project、Application 和 Kubernetes RBAC 按环境及 Namespace 最小授权。
- [ ] 限制可部署的仓库、Cluster、Namespace 和资源类型。
- [ ] Production 是否 Auto-Sync、Prune、Self-Heal 必须单独决策并测试失败模式。
- [ ] 防止 Developer 通过 Helm/Kustomize、Hook、Job、RBAC 或 IaC 间接提升生产权限。

### Secrets 与审计

- [ ] Git 中不保存明文 Secret；使用 AWS Secrets Manager 等私有密钥源。
- [ ] 变更单、PR、Commit、Artifact digest、审批与 Argo CD Sync 可端到端关联。
- [ ] 集中保存 GitLab Audit、CI、Argo CD、EKS Audit 和 CloudTrail 日志。
- [ ] 对直接 kubectl、Argo CD 管理变更、权限变更和 Break-glass 启用实时告警。

## 需要管理层确认的政策变化

当前基线是：

```text
Ops → Dual Bastion → Manual Deployment
```

建议基线是：

```text
Ops Approval → Protected Git Merge → Argo CD Deployment
```

因此，“唯一发布渠道”应重新表述为：

> Production/Test 的唯一正常发布渠道是受保护的 GitOps Release 流程；Ops 是唯一生产发布授权方，Argo CD 是唯一常规部署执行主体。Dual Bastion 仅用于经授权的管理、排障和紧急操作。

## 验收测试

- [ ] Developer 无法直接或间接合并 Production Release PR。
- [ ] CI 凭证无法访问 EKS API 或 AssumeRole 到部署角色。
- [ ] 未签名、摘要不匹配或不合规的镜像无法部署。
- [ ] 非允许仓库、Cluster、Namespace 或资源类型无法由 Argo CD 同步。
- [ ] 堡垒机和办公室网络中断时，已批准发布及 GitOps 回滚仍可执行。
- [ ] Argo CD 故障时，监控能够告警且不会造成不可控漂移。
- [ ] Break-glass 使用需要双人控制，并能触发实时告警和事后轮换。
- [ ] 任一生产 Pod 均可追溯到变更单、Commit、审批人与 Artifact digest。

## 待决策事项

- [ ] 接受 / 拒绝 GitOps 作为唯一正常发布渠道
- [ ] GitLab 与 Argo CD 的高可用和灾难恢复方案
- [ ] Production Auto-Sync、Prune、Self-Heal 策略
- [ ] 发布仓库、环境分支和 CODEOWNERS 模型
- [ ] Artifact 签名、SBOM 与 Admission Policy 工具选型
- [ ] 紧急回滚在 GitLab或 Argo CD 不可用时的操作手册

## 相关笔记

- [[00-Index|AWS 部署索引]]
- [[10-Release-Process|发布流程]]
- [[21-Bastion-Access-Architecture|堡垒机访问架构]]
- [[22-Break-Glass-Access|破窗账户管理]]
- [[20-Account-Architecture|架构与账户规划]]
- [[12-Deployment-Checklist|部署检查清单]]
