# Cloud Resource Vault Agent Instructions

This directory is an Obsidian vault and the source of truth for multi-cloud resource documentation.

## Repository skills

Reusable skills live in the root `skills/` directory. Before cloud inventory, expiry, Calendar, dashboard, or execution-log work, read and follow `skills/manage-cloud-vault/SKILL.md`. Compatibility paths under `.agents/skills`, `.claude/skills`, `.codex/skills`, and `.opencode/skills` point to the same source.

## Read first

Before changing files, read these in order:

1. `70-Maps/目录结构与 Agent 协作指南.md`
2. `Index.md`
3. The relevant provider, account, product, and resource notes
4. `Log.md`

Do not ask the user to restate information already present in this vault. Search the vault first with `rg` or equivalent.

## Source-of-truth model

- Navigation hierarchy: `provider -> account -> product -> resource`.
- One real cloud resource must have one active Markdown note.
- Resource path:
  `20-Areas/云资源运营/10-Providers/<Provider>/Accounts/<account-id>/Products/<Product>/<resource>.md`
- Active resources use `type: cloud-resource` and a unique `resource_id`.
- Account notes use `type: cloud-account`.
- `.base` files are generated views. Never duplicate their rows manually in Markdown tables.
- `40-Archive` is historical context, not the current source of truth.

Canonical provider values:

- Alibaba Cloud: `aliyun`
- AWS: `aws`
- Tencent Cloud: `tencent-cloud`

## Required resource properties

Every cloud resource note must contain:

```yaml
type: cloud-resource
resource_id:
name:
provider:
account:
account_id:
service:
resource_type:
environment:
region:
status:
owner:
criticality:
renewal:
expires:
created:
updated:
tags: []
```

Use ISO dates (`YYYY-MM-DD`) and ISO datetimes (`YYYY-MM-DDTHH:mm:ss`). If a supplied datetime has no timezone, preserve it and set `expires_timezone: unknown` instead of guessing.

## Mutation workflow

1. Read current notes and resolve the correct provider/account/product.
2. Update or create the single canonical resource note.
3. Add Wikilinks to its account and dependencies.
4. Update manually maintained counts only when such counts exist.
5. Validate active Wikilinks, unique `resource_id` values, JSON, and changed `.base` YAML.
6. If `expires` or `expires_at` changed, update Calendar Daily Notes in `20-Areas/云资源运营/40-Calendar` for 30, 15, 7 days before expiry and the expiry date. Do not create reminder dates earlier than today.
7. Append a concise entry to the root-level `Log.md`.

The execution-log entry must include timestamp, agent name when known, action, affected paths/resources, validation result, and source (`user`, `vault`, or `cloud API`). This log is the handoff between agents; read it instead of asking for prior execution history.

## Safety

- Never store passwords, private keys, access-key secrets, session tokens, MFA recovery codes, or complete database connection strings.
- Resource IDs, account IDs, public IPs, endpoints, regions, and expiry dates may be documented when needed for operations.
- Documentation changes do not authorize changes in a cloud console or API.
- Before an external cloud mutation, require explicit user authorization for the exact account, resources, and action.
- Never infer missing account IDs, regions, owners, environments, or timezones. Use an empty value or `unknown` and add a follow-up task.
- Preserve user content. Move obsolete material to `40-Archive` instead of deleting it unless deletion is explicitly requested.

## Completion standard

A documentation task is complete only when the canonical note is updated, expiry reminders are synchronized with Calendar when applicable, links resolve, structured fields remain consistent, and the execution log contains the handoff entry.
