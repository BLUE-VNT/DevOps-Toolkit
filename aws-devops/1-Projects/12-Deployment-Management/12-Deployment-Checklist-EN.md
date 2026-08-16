---
title: Deployment Checklist
language: en
translation_group: deployment-checklist
translation_of: 12-Deployment-Checklist
translation_status: synchronized
status: active
para: project
updated: 2026-08-16
---
# Deployment Checklist
[[12-Deployment-Checklist-ZH|中文]] · [[12-Deployment-Checklist-EN|English]] · [[12-Deployment-Checklist-VI|Tiếng Việt]]

## Before
- [ ] Ticket approved; artifact version and SHA-256 verified
- [ ] Tests, security scans, compatibility, and database changes reviewed
- [ ] Rollback tested; monitoring, alerts, window, operator, and reviewer confirmed
## During
- [ ] Use personal identity, MFA, approved bastion path, and correct temporary role
- [ ] Record start time and commands; run health and smoke tests
## After
- [ ] Confirm services, dependencies, metrics, logs, and audit events
- [ ] Update ticket; terminate sessions and temporary grants
- [ ] Roll back and review the incident when abnormal behavior occurs
