---
title: GitOps Release Architecture Review
language: en
translation_group: gitops-architecture-review
translation_of: 11-GitOps-Architecture-Review
translation_status: synchronized
status: proposed
decision: pending
para: project
updated: 2026-08-16
---
# GitOps Release Architecture Review
[[11-GitOps-Architecture-Review-ZH|中文]] · [[11-GitOps-Architecture-Review-EN|English]] · [[11-GitOps-Architecture-Review-VI|Tiếng Việt]]

## Architecture diagram

![[31-GitOps-Architecture.png]]

> [!note] Diagram scope
> The diagram shows the responsibility boundaries among Developer, GitLab, CI/Jenkins, the artifact repository, Ops approval, Argo CD, Private EKS, dual bastions, and break-glass access. It represents a proposal and does not mean GitOps has been approved.

> [!success] Recommendation
> Adopt in principle only after all mandatory controls and formal architecture/security approval. Ops retains release authority; Argo CD executes the approved Git state.

## Security mechanisms
- Application deployment: Git PR → Ops approval → Argo CD → Private EKS
- Administrative access: Ops → VPN/MFA → Dual Bastion → AWS

## Responsibility boundary
| Actor | Responsibility | Prohibited |
| --- | --- | --- |
| Developer | Code, branches, code/release PRs | AWS credentials, kubectl, EKS access, Production merge |
| CI/Jenkins | Build, test, SAST/SCA, scan, sign, push artifacts | EKS credentials, deployment or merge permission |
| Ops | Review, approve, merge, authorize rollback | Shared identity or unaudited direct change |
| Argo CD | Pull and reconcile approved desired state | Git write or excessive cluster privilege |
| Bastion | Administration and troubleshooting | Sole normal release dependency |
| Break-glass | Severe emergency recovery | Routine release or troubleshooting |

## Release and rollback
```text
Developer → Code PR → CI Build/Test/Scan → Signed Artifact Digest
→ Release PR → Ops Approval → Protected Merge → Argo CD → Private EKS
Incident → Rollback PR → Ops Approval → Merge → Argo CD → Previous Digest
```

## Mandatory controls
- Protected release repository/branch, CODEOWNERS, Ops approval, two-person Production approval, no direct/force push, self-approval, or administrator bypass.
- CI may open but cannot approve/merge a Production PR; every PR links ticket, CI result, and digest.
- ECR tag immutability; deploy by digest; retain SBOM and scan results; sign artifacts and verify them at admission; govern exceptions and deletion.
- Private Argo CD/EKS; read-only Git credentials; IRSA or EKS Pod Identity; least-privilege Project/Application/RBAC; restrict repository, cluster, namespace, and resource kinds.
- Decide and test Auto-Sync, Prune, and Self-Heal; block privilege escalation through Helm/Kustomize, hooks, Jobs, RBAC, or IaC.
- No plaintext secrets in Git; use a private secret source. Correlate ticket, PR, commit, digest, approval, and sync. Centralize GitLab, CI, Argo CD, EKS audit, and CloudTrail logs.

## Policy change requiring approval
Current: `Ops → Dual Bastion → Manual Deployment`

Proposed: `Ops Approval → Protected Git Merge → Argo CD Deployment`

Ops remains the only Production release authority; Argo CD becomes the only normal execution identity. Bastions remain for authorized administration, troubleshooting, and emergencies.

## Acceptance tests
- Developer cannot directly or indirectly merge Production; CI cannot reach EKS or assume a deployment role.
- Unsigned, mismatched, or noncompliant artifacts cannot deploy.
- Argo CD cannot target unapproved repositories, clusters, namespaces, or resources.
- Approved release and GitOps rollback work during office/bastion outage.
- Argo CD failure alerts without uncontrolled drift; break-glass requires two people and alerts.
- Every running Production Pod traces to a ticket, commit, approver, and digest.
