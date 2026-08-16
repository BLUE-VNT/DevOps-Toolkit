---
title: Release Process
language: en
translation_group: release-process
translation_of: 10-Release-Process
translation_status: synchronized
status: approved-baseline
para: project
updated: 2026-08-16
---
# Release Process
[[10-Release-Process-ZH|中文]] · [[10-Release-Process-EN|English]] · [[10-Release-Process-VI|Tiếng Việt]]

> [!warning] Pending architecture decision
> The current baseline requires Ops to deploy manually through dual bastions. [[11-GitOps-Architecture-Review-EN|GitOps]] proposes “Ops authorizes, Argo CD executes.” Until approved, this page remains the active baseline.

## Sole release channel
1. Developer submits a change ticket, immutable artifact, and SHA-256 digest.
2. Ops reviews scope, tests, deployment steps, and rollback.
3. After approval, Ops enters the operations network during the release window.
4. Ops uses personal identity and temporary credentials through both bastion layers.
5. Ops deploys, verifies health, and rolls back when required.
6. Ops records the result, logs, and deployed version in the ticket.

Developer must have no Production/Test deployment, server, SSM, or Kubernetes write access.

## Required evidence
- Ticket and approvals; artifact location, version, and digest
- VPN and bastion sessions; STS and CloudTrail events
- SSM/EKS/deployment logs; verification or rollback result
