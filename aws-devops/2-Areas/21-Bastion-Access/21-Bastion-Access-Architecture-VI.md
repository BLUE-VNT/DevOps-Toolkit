---
title: Kiến trúc truy cập bastion
language: vi-VN
translation_group: bastion-access-architecture
translation_of: 21-Bastion-Access-Architecture
translation_status: synchronized
status: draft
para: area
updated: 2026-08-16
---
# Kiến trúc truy cập bastion
[[21-Bastion-Access-Architecture-ZH|中文]] · [[21-Bastion-Access-Architecture-EN|English]] · [[21-Bastion-Access-Architecture-VI|Tiếng Việt]]

## Sơ đồ kiến trúc

![[30-Dual-Bastion-Architecture.png]]

> [!note] Phạm vi sơ đồ
> Sơ đồ thể hiện quan hệ truy cập giữa mạng công ty, VPN MFA, hai lớp bastion Mac mini, Operations Account và các AWS Account đích. Quy tắc bảo mật bằng văn bản và quyết định đã phê duyệt có ưu tiên cao hơn các tham số minh họa trong sơ đồ.

Hai máy bastion bảo vệ hoạt động quản trị của con người, xử lý sự cố và tình huống khẩn cấp. Chúng không nên mặc nhiên là công cụ triển khai ứng dụng duy nhất.

```text
Thiết bị công ty → Mạng văn phòng → VPN MFA → Mạng vận hành
→ Mac mini #1 (VPN/jump) → Mac mini #2 (máy trạm)
→ Operations Account → AssumeRole → Tài khoản đích
```

## Kiểm soát
- Mac mini #1 không có AWS CLI, kubectl hoặc công cụ phát triển.
- Chỉ có thể truy cập Mac mini #2 qua máy #1; máy #2 dùng MDM, FileVault và EDR.
- Dùng danh tính cá nhân, MFA, STS, role Production/Test riêng và không dùng chung tài khoản.
- Lưu tập trung CloudTrail, SSM, EKS audit và log phiên làm việc.
- IP nguồn cố định chỉ là giới hạn mạng, không thay thế xác thực người dùng.
- Xác định đường ra AWS Console/API, DNS, proxy/endpoint, port và domain được phép.
