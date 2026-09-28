# Vault schema

## Canonical hierarchy

```text
20-Areas/云资源运营/10-Providers/
└── <Provider>/
    └── Accounts/
        └── <account-id>/
            ├── Account Index.md
            ├── Account Resources.base
            └── Products/
                └── <Product>/<resource>.md
```

Provider mappings:

| Directory | `provider` |
| --- | --- |
| `Alibaba Cloud` | `aliyun` |
| `AWS` | `aws` |
| `Tencent Cloud` | `tencent-cloud` |

## Required resource properties

```yaml
type: cloud-resource
resource_id:
name:
provider:
account: "" # Wikilink to the canonical Account Index
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

Use:

- `environment`: `production`, `staging`, `test`, `development`, or `shared`.
- `status`: `active`, `stopped`, `pending`, `released`, or `archived`.
- `criticality`: `critical`, `high`, `medium`, or `low`.
- `renewal`: `automatic`, `manual`, `not-applicable`, or `unknown`.
- Dates: `YYYY-MM-DD`.
- Datetimes: `YYYY-MM-DDTHH:mm:ss`; add an explicit timezone property when known.

## File responsibilities

- `/Index.md`: outermost navigation and operational summary.
- `/Log.md`: outermost append-only cross-agent execution handoff.
- `/AGENTS.md`: repository-wide instructions for AI agents.
- `00-Dashboards/*.base`: generated cross-cloud views.
- `Account Index.md`: account governance and manually maintained product counts.
- Resource Markdown: canonical resource facts.
- `40-Calendar/YYYY-MM-DD.md`: Calendar expiry tasks.
- `40-Archive`: historical material only.
