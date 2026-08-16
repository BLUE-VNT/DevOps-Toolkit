---
title: Language Guide
tags:
  - documentation
  - i18n
  - multilingual
status: active
updated: 2026-08-16
document_role: language-policy
languages:
  - zh-CN
  - en
  - vi-VN
---

# Language Guide

[[03-Language-Guide-ZH|中文]] · [[03-Language-Guide-EN|English]] · [[03-Language-Guide-VI|Tiếng Việt]]

## File Pattern

```text
10-Release-Process-ZH.md
10-Release-Process-EN.md
10-Release-Process-VI.md
```

## Required Page Switcher

```markdown
[[10-Release-Process-ZH|中文]] · [[10-Release-Process-EN|English]] · [[10-Release-Process-VI|Tiếng Việt]]
```

## Metadata

```yaml
language: zh-CN | en | vi-VN
translation_group: release-process
translation_of: 10-Release-Process
translation_status: synchronized | needs-review | outdated
```

## 中文

- 三个版本必须表达相同的制度、决策状态和安全边界。
- 修改任何版本时必须同步其余版本。
- 命令、路径、AWS 标识符、代码和占位符保持原样。

## English

- All three versions must preserve the same policies, decision status, and security boundaries.
- A change to one version must be synchronized to the other two versions.
- Keep commands, paths, AWS identifiers, code, and placeholders unchanged.

## Tiếng Việt

- Cả ba phiên bản phải giữ nguyên chính sách, trạng thái quyết định và ranh giới bảo mật.
- Khi sửa một phiên bản, phải đồng bộ hai phiên bản còn lại trong cùng một thay đổi.
- Giữ nguyên lệnh, đường dẫn, mã định danh AWS, mã nguồn và phần giữ chỗ.
- Phải sử dụng đầy đủ dấu tiếng Việt và văn phong kỹ thuật trang trọng.

## Translation Quality Gate

- `synchronized`: 内容完整且三语语义一致。
- `needs-review`: 内容完整，但需要母语或技术复核。
- `outdated`: 与其他语言版本不一致，不得作为当前事实来源。
