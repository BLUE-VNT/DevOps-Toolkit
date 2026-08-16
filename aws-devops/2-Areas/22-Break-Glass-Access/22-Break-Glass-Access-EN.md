---
title: Break-glass Access
language: en
translation_group: break-glass-access
translation_of: 22-Break-Glass-Access
translation_status: synchronized
status: draft
para: area
updated: 2026-08-16
---
# Break-glass Access
[[22-Break-Glass-Access-ZH|中文]] · [[22-Break-Glass-Access-EN|English]] · [[22-Break-Glass-Access-VI|Tiếng Việt]]

Use only when ordinary Ops channels are completely unavailable, such as network loss or data-center power failure.

- Two independent custodians hold separate factors; two-person authorization is mandatory.
- Store independent hardware MFA and credentials sealed offline.
- Never store them in scripts, bastions, or ordinary shared vaults.
- Activation must alert Security and open an incident record.
- Revoke sessions, rotate credentials, and review every use.
- Test quarterly, including SCP and trust-policy reachability.

Record the incident, reason, both approvers, start/end time, actions, rotation, and audit report.
