---
title: Bastion Access Architecture
language: en
translation_group: bastion-access-architecture
translation_of: 21-Bastion-Access-Architecture
translation_status: synchronized
status: draft
para: area
updated: 2026-08-16
---
# Bastion Access Architecture
[[21-Bastion-Access-Architecture-ZH|中文]] · [[21-Bastion-Access-Architecture-EN|English]] · [[21-Bastion-Access-Architecture-VI|Tiếng Việt]]

## Architecture diagram

![[30-Dual-Bastion-Architecture.png]]

> [!note] Diagram scope
> The diagram shows the access relationship among the corporate network, MFA VPN, dual Mac mini bastion layers, Operations Account, and target AWS Accounts. The written security rules and approved decisions override example parameters shown in the diagram.

Dual bastions protect human administration, troubleshooting, and emergencies. They should not automatically be the sole application deployment engine.

```text
Corporate device → Office LAN → MFA VPN → Operations LAN
→ Mac mini #1 (VPN/jump) → Mac mini #2 (workstation)
→ Operations Account → AssumeRole → Target Account
```

## Controls
- Mac mini #1 has no AWS CLI, kubectl, or development tools.
- Mac mini #2 is reachable only through #1 and uses MDM, FileVault, and EDR.
- Use personal identities, MFA, STS, separate Production/Test roles, and no shared accounts.
- Centralize CloudTrail, SSM, EKS audit, and session logs.
- A fixed source IP is only a network restriction, not user authentication.
- Define controlled AWS Console/API egress, DNS, proxy/endpoints, ports, and domains.
