---
title: Operations Architecture Proposal Review
language: en
translation_group: operations-proposal-review
translation_of: 14-Operations-Proposal-Review
translation_status: synchronized
status: proposed
decision: pending
para: project
updated: 2026-08-18
source_type: external-proposal
---

# Operations Architecture Proposal Review

[[14-Operations-Proposal-Review-ZH|中文]] · [[14-Operations-Proposal-Review-EN|English]] · [[14-Operations-Proposal-Review-VI|Tiếng Việt]]

> [!warning] Status
> This note summarizes an external target-state proposal; it is not an approved architecture. Commands, prices, and configurations in the attachments are reference material. Current policy remains [[10-Release-Process-EN|the approved release process]].

## Executive conclusion

The proposal uses four AWS Accounts, three isolated workload VPCs, PrivateLink service-level ingress, an Ops-started Jenkins workflow, and Argo CD reconciliation in private EKS. It aligns with private workloads, least exposure, Ops release authority, and auditability. Approval should wait until the management path, Jenkins permissions, account isolation, GitOps approval model, HA/DR, centralized security governance, and current costs are resolved.

## Source diagrams

![[34-Multi-Account-Architecture.png]]

![[35-Network-Overview.png]]

![[36-Routing-Security-Matrix.png]]

### Version 1 Architecture Overview (User-provided)

This diagram is archived as the first-version reference for the operations proposal review. It is not an approved implementation baseline; the proposal remains `proposed / pending`.

![[32-AWS-Multi-Account-Architecture-Overview-v1-HD.jpg]]

## Account and network model

| Account | Responsibility | Networks/components |
| --- | --- | --- |
| 1 | Private workloads | Production `10.10.0.0/16`, Test `10.40.0.0/16`, Tools `10.50.0.0/16`; EKS, data, Argo CD, CI tools |
| 2 | Operations and security | Operations `10.20.0.0/16`; VPN/DX, SSM, audit, security services, break-glass |
| 3 | Production entry | `10.30.0.0/16`; Cloudflare, public ALB, Nginx/API Gateway, PrivateLink endpoint |
| 4 | Test entry | `10.60.0.0/16`; internal VPN/ALB, Nginx, private DNS, PrivateLink endpoint |

Production, Test, and Tools have no direct routes. Entry Accounts cannot reach private databases. Private SGs deny public ingress. Cross-account application access is intended to use PrivateLink TCP/HTTPS 443.

## Proposed release flow

```text
Developer → GitLab Review/Merge → Ops starts Jenkins
→ Build/Test/Scan → ECR/Nexus → Update Helm Manifest
→ Argo CD Pull/Sync → Private EKS
```

Developer has no AWS/EKS/kubectl access. GitLab does not auto-trigger Jenkins. Jenkins is described as build-only; Argo CD performs deployment.

## Strengths

- No public workload entry and service-level cross-account exposure.
- No Production/Test/Tools lateral routing.
- Separation of entry, workload, and operations responsibilities.
- Pull-based Argo CD and centralized MFA, temporary credentials, SSM, CloudTrail, GuardDuty, Security Hub, and break-glass concepts.

## Blocking issues

1. The report denies Jenkins deployment access, while the SG matrix allows `Jenkins role → Private EKS API : 443`. Remove it or document a narrowly scoped read-only purpose and RBAC.
2. The Operations-to-private-EKS route is not defined while peering/TGW routes are denied. Specify the complete route, DNS, endpoint, and SG model.
3. Jenkins writes Helm manifests. It should create a Release PR, not write a protected Production branch; Ops/CODEOWNERS must approve and merge.
4. Production, Test, and Tools share one AWS Account, so isolation is VPC/IAM/RBAC-based rather than account-level. Explicitly accept this or split accounts.
5. Choose one authoritative release mechanism: manual Jenkins start or automated CI build with Ops-only Release PR approval.

## Additional design requirements

- Cloudflare origin protection and direct-origin bypass prevention.
- TLS termination and certificate ownership across ALB/Nginx/NLB/PrivateLink.
- Immutable digest, signing, SBOM, scanning, admission policy, and clear ECR/Nexus ownership.
- Organizations/Control Tower, SCPs, log archive/security administration, endpoint and KMS policies, secrets, DNS, egress, and WAF controls.
- HA, backup, RPO/RTO, and DR for EKS, Argo CD, CI, artifact services, and data platforms.
- Two-person break-glass, offline hardware MFA, alerting, rotation, and quarterly exercises.

## Cost interpretation

The report gives illustrative Singapore estimates: Peering fixed connection cost `USD 0/month`; PrivateLink about `USD 29.20/month`, or `USD 39.44/month` with 1 TB; four TGW attachments plus 1 TB about `USD 166.48/month`. These exclude NLB, cross-AZ, DNS, logging, monitoring, and other endpoints and must be revalidated with current AWS pricing. PrivateLink should be selected for isolation, not assumed lowest cost.

## Recommendation

Keep `proposed / pending`. Accept the network direction in principle only after all blocking items close, then merge the release model with [[11-GitOps-Architecture-Review-EN|the GitOps review]] into one authoritative design.
