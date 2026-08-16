---
title: Account Architecture
language: en
translation_group: account-architecture
translation_of: 20-Account-Architecture
translation_status: synchronized
status: draft
para: area
updated: 2026-08-16
---
# Account Architecture
[[20-Account-Architecture-ZH|中文]] · [[20-Account-Architecture-EN|English]] · [[20-Account-Architecture-VI|Tiếng Việt]]

| Account | Purpose | Key controls |
| --- | --- | --- |
| Operations | Central identity, operations entry, audit | MFA, STS, least privilege |
| Workload | Applications, EKS, RDS, Kafka | Private subnets, no public management endpoint |
| Production Entry | Production traffic entry | ALB/NLB, WAF, PrivateLink |
| Test Entry | Test traffic entry | Internal ALB, private DNS |

## Decisions required
- [ ] Organizations/SCP; Region/AZ; VPC/subnets/routes
- [ ] DNS, certificates, ingress; centralized logs and retention
- [ ] Backup, RPO/RTO; budget and cost alerts
