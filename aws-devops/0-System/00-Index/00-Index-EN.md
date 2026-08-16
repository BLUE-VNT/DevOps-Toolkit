---
title: AWS Deployment Index
language: en
translation_group: index
translation_of: 00-Index
translation_status: synchronized
status: active
---
# AWS Deployment Index
[[00-Index-ZH|中文]] · [[00-Index-EN|English]] · [[00-Index-VI|Tiếng Việt]]

> [!info] Current state
> GitOps remains a proposal and has not replaced the approved dual-bastion manual-release baseline.

## Quick access
- [[10-Release-Process-EN|Release Process]] — approved baseline
- [[11-GitOps-Architecture-Review-EN|GitOps Architecture Review]] — proposed/pending
- [[14-Operations-Proposal-Review-EN|Operations Architecture Proposal Review]] — proposed/pending
- [[21-Bastion-Access-Architecture-EN|Bastion Access Architecture]]
- [[22-Break-Glass-Access-EN|Break-glass Access]]
- [[01-Change-Log-EN|Change Log]]

## Authoritative principles
- Ops is the only authority that may approve Production/Test releases.
- Developer and CI have no AWS/EKS deployment permission.
- Human administration uses the controlled bastion path.
- Every production change must map to a ticket, approval, commit, and artifact digest.
