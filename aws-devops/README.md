# AWS Deployment Knowledge Base

[[README-ZH|中文]] · [[README-EN|English]] · [[README-VI|Tiếng Việt]]

这是一个采用 PARA 组织方式、兼容 Obsidian 和多种 AI 工具直接读取的 AWS 部署知识库。

## 入口

- 人类与 Obsidian：打开 `00-Index.md`
- AI Agent：先读取 `AGENTS.md`
- 自动化工具：读取 `02-Document-Manifest.yaml`
- 历史变更：读取 `0-System/01-Change-Log/01-Change-Log.md`
- 语言规范：读取 `0-System/02-Documentation/03-Language-Guide.md`

## PARA 结构

```text
AWS 部署/
├── 00-Index.md
├── 02-Document-Manifest.yaml
├── AGENTS.md
├── README.md
├── 0-System/
│   ├── 00-Index/
│   ├── 01-Change-Log/
│   └── 02-Documentation/
├── 1-Projects/
├── 2-Areas/
├── 3-Resources/
└── 4-Archives/
```

## 内容约定

- Markdown 文件使用 UTF-8。
- 知识库文件名仅使用数字、英文字母、连字符及标准扩展名。
- Obsidian 内部引用使用 `[[Note Title]]`。
- 正文使用 YAML Frontmatter 描述状态、PARA 分类和更新时间。
- `approved-baseline` 表示现行制度，`proposed` 表示尚未批准的建议。
- 文档不得保存密码、Access Key、私钥、Token 或真实破窗凭证。

## Languages

每个主题目录包含路由页及 `-ZH.md`、`-EN.md`、`-VI.md` 三份正文。三个版本页首提供中文、English、Tiếng Việt 切换链接。详细规则见 `AGENTS.md` 和 `0-System/02-Documentation/03-Language-Guide.md`。
