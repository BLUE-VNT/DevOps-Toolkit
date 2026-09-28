---
type: guide
status: evergreen
updated: 2026-08-14
tags: [system/architecture, system/agent]
---

# 目录结构与 Agent 协作指南

## 目标

本仓库同时服务人工管理和 AI Agent。任何 Agent 进入目录后，应能自行识别数据结构、找到当前事实、继续上一次执行，并在结束时留下可供下一个 Agent 读取的记录。

## 读取顺序

1. 根目录 `AGENTS.md`：执行规则和安全边界。
2. [[Index]]：当前状态和紧急事项。
3. [[20-Areas/云资源运营/10-Providers/Providers Index|云厂商导航]]：找到云厂商。
4. 云厂商下的 Account Index：找到账号。
5. 账号下的 Products：找到产品和具体资源。
6. [[Log]]：了解最近改动。

## 目录结构

```text
Vault/
├── AGENTS.md                         # 所有 Agent 的权威执行规则
├── CLAUDE.md                         # Claude 系 Agent 兼容入口
├── README.md                         # 通用工具和人工入口
├── skills/                           # 跨 Agent 的唯一技能源
│   └── manage-cloud-vault/
│       ├── SKILL.md                  # 触发说明与标准工作流
│       ├── agents/openai.yaml        # OpenAI/Codex UI 元数据
│       └── references/vault-schema.md# 按需读取的数据模型
├── .agents/skills/                   # 通用 Agent 兼容入口
├── .claude/skills/                   # Claude 兼容入口
├── .codex/skills/                    # Codex 兼容入口
├── .opencode/skills/                 # OpenCode 兼容入口
├── Index.md                          # 根目录首页与当前状态
├── Log.md                            # 根目录统一执行记录
├── 00-Inbox/                         # 尚未判断用途的信息
├── 10-Projects/                      # 有明确完成条件的临时工作
├── 20-Areas/                         # 长期维护责任
│   └── 云资源运营/
│       ├── 00-Dashboards/            # 跨厂商、账号、产品的 Base 视图
│       ├── 10-Providers/
│       │   ├── Alibaba Cloud/
│       │   ├── AWS/
│       │   └── Tencent Cloud/
│       │       └── Accounts/
│       │           └── <account-id>/
│       │               ├── Account Index.md
│       │               ├── Account Resources.base
│       │               └── Products/
│       │                   └── <Product>/<resource>.md
│       └── 30-Operations/
│           ├── Changes/              # 具体云资源变更记录
│           ├── Incidents/            # 故障与复盘
│           └── Maintenance/          # 周期维护
│       └── 40-Calendar/              # Calendar 插件读取的到期日期笔记
├── 30-Resources/                     # 可复用运行手册和参考资料
├── 40-Archive/                       # 历史快照，不作为当前事实
├── 70-Maps/                          # 全局说明与导航地图
├── 80-Templates/                     # 账号、资源、变更、故障模板
└── 90-Attachments/                   # 图片、账单和非 Markdown 附件
```

## 信息模型

```text
Provider
  └── Account
       └── Product / Service
            └── Resource
                 ├── Dependency links
                 ├── Change records
                 ├── Incident records
                 └── Runbooks
```

## Skills 发现机制

`skills/` 是唯一内容源。不同 Agent 的隐藏目录只提供指向该目录的兼容入口，禁止复制技能内容，以免版本漂移。

- 通用 Agent：从根目录 `AGENTS.md` 发现技能。
- Codex：`.codex/skills/manage-cloud-vault`。
- Claude：`.claude/skills/manage-cloud-vault`，并由 `CLAUDE.md` 提示读取。
- OpenCode：`.opencode/skills/manage-cloud-vault`。
- 其他支持 Agent Skills 的工具：`.agents/skills/manage-cloud-vault`。

不自动发现仓库技能的 Agent 仍可通过 `README.md` 和本指南找到 `skills/manage-cloud-vault/SKILL.md`。

### 云厂商标准值

| 显示名称 | `provider` 值 | 目录名 |
| --- | --- | --- |
| 阿里云 | `aliyun` | `Alibaba Cloud` |
| AWS | `aws` | `AWS` |
| 腾讯云 | `tencent-cloud` | `Tencent Cloud` |

### 资源属性

| 属性 | 说明 |
| --- | --- |
| `resource_id` | 云厂商提供的唯一 ID；没有 ID 时使用稳定且唯一的业务标识 |
| `provider` | 标准云厂商值 |
| `account` | 指向 Account Index 的 Wikilink |
| `account_id` | 可筛选的账号字符串 |
| `service` | 云产品名称，例如 ECS、EC2、CVM、RDS、S3 |
| `resource_type` | 通用类型，例如 compute、database、network、domain、certificate |
| `environment` | production、staging、test、development 或 shared |
| `region` | 云厂商 Region；全球资源使用 global |
| `status` | active、stopped、pending、released 或 archived |
| `criticality` | critical、high、medium 或 low |
| `renewal` | automatic、manual、not-applicable 或 unknown |
| `expires` | 用于 Base 筛选的到期日期 |
| `expires_at` | 需要精确到时分秒时使用 |

## Base 视图职责

- [[20-Areas/云资源运营/00-Dashboards/多云总览.base|多云总览]]：按云厂商、账号或产品查看全部资源。
- [[20-Areas/云资源运营/00-Dashboards/云资源台账.base|云资源台账]]：到期、过期和信息完整性检查。
- Provider Resources：筛选单一云厂商并按账号或产品分组。
- Account Resources：筛选单一账号并按产品或环境分组。

Base 是实时视图，不是事实存储。事实始终保存在资源 Markdown 的 YAML 和正文中。

## Calendar 到期提醒

所有到期提醒统一使用已安装的 Calendar 插件，不再使用独立提醒插件或外部日历作为本仓库的事实来源。

- Daily Notes 目录：`20-Areas/云资源运营/40-Calendar`
- 文件格式：`YYYY-MM-DD.md`
- 模板：[[80-Templates/Calendar 到期提醒模板]]
- 节点：到期前 30、15、7 天以及到期当天
- 当一个日期有多个资源到期时，合并写入同一个日期笔记
- 修改 `expires` 后必须同步删除旧节点中的任务并建立新节点
- 若提醒节点早于创建当天，不补建已经错过的节点

入口：[[20-Areas/云资源运营/40-Calendar/Calendar Index|云资源到期日历]]。

## Agent 执行记录

每次修改仓库后，在根目录 [[Log]] 顶部追加一条记录。记录事实，不写冗长过程。

```markdown
## YYYY-MM-DD HH:mm:ss · Agent 名称
- 请求：用户目标的简短摘要
- 操作：创建、更新、迁移或归档了什么
- 影响：相关账号、产品、资源 ID 和文件路径
- 来源：user / vault / cloud API
- 验证：链接、唯一 ID、JSON、Base YAML 的结果
- 待处理：仍缺少的字段或下一步；没有则写“无”
```

只要执行记录和当前资源笔记已经包含所需上下文，后续 Agent 应直接继续工作，不要求用户重新说明历史。

## 新增账号

1. 复制 [[80-Templates/云账号模板]]。
2. 创建 `<Provider>/Accounts/<account-id>/Account Index.md`。
3. 创建 `Products/` 和按账号过滤的 `Account Resources.base`。
4. 将账号链接加入对应 Provider Index。

## 新增资源

1. 复制 [[80-Templates/云资源模板]] 或 [[80-Templates/服务器资源模板]]。
2. 放到 `<Provider>/Accounts/<account-id>/Products/<Product>/`。
3. 填齐规范属性并建立账号、依赖和运行手册链接。
4. 检查资源是否自动出现在 Provider、Account 与多云 Base 中。
5. 若有到期日期，在 Calendar 中建立 30、15、7 天及当天提醒。
6. 写入根目录 [[Log]]。

## 安全边界

- 可以记录资源 ID、账号 ID、IP、端点、Region、状态和到期时间。
- 金额记录未注明币种时，按用户约定默认使用人民币（`CNY`）；用户明确指定其他币种时以指定值为准。
- 不记录密码、AccessKey Secret、私钥、会话令牌、MFA 恢复码或完整数据库连接串。
- 修改笔记不等于授权修改真实云资源。操作云控制台或 API 前必须获得针对账号、资源和动作的明确授权。

相关：[[Index]] · [[Log]] · [[70-Maps/Cloud Map]]
