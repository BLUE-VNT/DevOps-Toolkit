---
title: Chỉ mục triển khai AWS
language: vi-VN
translation_group: index
translation_of: 00-Index
translation_status: synchronized
status: active
---
# Chỉ mục triển khai AWS
[[00-Index-ZH|中文]] · [[00-Index-EN|English]] · [[00-Index-VI|Tiếng Việt]]

> [!info] Trạng thái hiện tại
> GitOps vẫn là đề xuất và chưa thay thế quy trình phát hành thủ công qua hai máy bastion đã được phê duyệt.

## Truy cập nhanh
- [[10-Release-Process-VI|Quy trình phát hành]] — quy định hiện hành
- [[11-GitOps-Architecture-Review-VI|Đánh giá kiến trúc GitOps]] — đề xuất/chờ quyết định
- [[14-Operations-Proposal-Review-VI|Tổng hợp và đánh giá đề xuất vận hành]] — đề xuất/chờ quyết định
- [[21-Bastion-Access-Architecture-VI|Kiến trúc truy cập bastion]]
- [[22-Break-Glass-Access-VI|Truy cập khẩn cấp]]
- [[01-Change-Log-VI|Nhật ký thay đổi]]

## Nguyên tắc có thẩm quyền
- Chỉ Ops có quyền phê duyệt phát hành Production/Test.
- Developer và CI không có quyền triển khai AWS/EKS.
- Hoạt động quản trị của con người phải đi qua đường bastion được kiểm soát.
- Mọi thay đổi Production phải liên kết với phiếu thay đổi, phê duyệt, commit và artifact digest.
