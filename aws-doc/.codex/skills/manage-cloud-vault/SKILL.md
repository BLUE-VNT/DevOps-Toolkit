---
name: manage-cloud-vault
description: Manage this multi-cloud Obsidian vault across Alibaba Cloud, AWS, and Tencent Cloud. Use for adding or updating cloud accounts, products, servers, databases, networks, domains, SSL certificates, expiry dates, Calendar reminders, projects, changes, incidents, dashboards, Bases, Index navigation, and cross-agent execution records.
---

# Manage Cloud Vault

Maintain the vault as the source of truth for cloud inventory and operational context.

## Start

1. Read `/AGENTS.md`, `/Index.md`, and `/Log.md` from the vault root.
2. Read `references/vault-schema.md` for canonical paths and properties.
3. Search active files before asking the user for information already recorded.
4. Treat `40-Archive` as history, not current truth.

## Route the task

- Account or resource inventory: use `20-Areas/云资源运营/10-Providers`.
- Cross-cloud views: use `20-Areas/云资源运营/00-Dashboards`.
- Expiry reminders: use `20-Areas/云资源运营/40-Calendar`.
- Time-bounded outcomes: use `10-Projects`.
- Reusable procedures: use `30-Resources`.
- Cloud changes, incidents, or maintenance: use `20-Areas/云资源运营/30-Operations`.

## Update inventory

1. Resolve provider, account ID, product, and resource ID.
2. Create or update one canonical Markdown note per real resource.
3. Use the path `Provider/Accounts/account-id/Products/Product/resource.md`.
4. Add the required YAML properties from `references/vault-schema.md`.
5. Link the resource to its Account Index and dependencies.
6. Do not manually duplicate rows represented by `.base` views.
7. Leave unknown fields empty or set an explicit `unknown`; never infer them.

## Synchronize expiry reminders

When `expires` or `expires_at` is added or changed:

1. Create or update Calendar Daily Notes for 30, 15, and 7 days before expiry and the expiry day.
2. Use `20-Areas/云资源运营/40-Calendar/YYYY-MM-DD.md`.
3. Merge multiple resource reminders into one date note.
4. Do not create reminder dates earlier than the current date.
5. Remove obsolete tasks from old dates after an expiry date changes.
6. Preserve an unknown timezone as `expires_timezone: unknown`.

## Validate and hand off

Before finishing:

1. Validate active Wikilinks.
2. Confirm `resource_id` values are unique.
3. Validate changed Obsidian JSON and `.base` YAML.
4. Confirm Calendar reminders match changed expiry fields.
5. Add a concise timestamped entry at the top of root `/Log.md` with request, action, impact, source, validation, and pending items.

## Protect credentials and production

- Never store passwords, private keys, AccessKey secrets, session tokens, MFA recovery codes, or complete database connection strings.
- Do not treat documentation changes as authorization to mutate cloud resources.
- Require explicit user authorization for the exact provider, account, resources, and action before using a cloud console or API.
- Preserve obsolete material in `40-Archive` unless deletion is explicitly requested.

