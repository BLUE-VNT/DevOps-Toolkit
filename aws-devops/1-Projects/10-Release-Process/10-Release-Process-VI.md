---
title: Quy trình phát hành
language: vi-VN
translation_group: release-process
translation_of: 10-Release-Process
translation_status: synchronized
status: approved-baseline
para: project
updated: 2026-08-16
---
# Quy trình phát hành
[[10-Release-Process-ZH|中文]] · [[10-Release-Process-EN|English]] · [[10-Release-Process-VI|Tiếng Việt]]

> [!warning] Đang chờ quyết định kiến trúc
> Quy định hiện tại yêu cầu Ops triển khai thủ công qua hai máy bastion. [[11-GitOps-Architecture-Review-VI|GitOps]] đề xuất “Ops cấp quyền, Argo CD thực thi”. Trước khi được phê duyệt, trang này vẫn là quy định hiện hành.

## Kênh phát hành duy nhất
1. Developer gửi phiếu thay đổi, artifact bất biến và mã băm SHA-256.
2. Ops xem xét phạm vi, kết quả kiểm thử, bước triển khai và phương án rollback.
3. Sau khi phê duyệt, Ops vào mạng vận hành trong khung giờ phát hành.
4. Ops dùng danh tính cá nhân và thông tin xác thực tạm thời qua hai lớp bastion.
5. Ops triển khai, kiểm tra tình trạng và rollback khi cần.
6. Ops ghi kết quả, vị trí log và phiên bản thực tế vào phiếu thay đổi.

Developer không được có quyền triển khai Production/Test, truy cập máy chủ, SSM hoặc quyền ghi Kubernetes.

## Bằng chứng bắt buộc
- Phiếu thay đổi và phê duyệt; vị trí, phiên bản và digest của artifact
- Phiên VPN và bastion; sự kiện STS và CloudTrail
- Log SSM/EKS/triển khai; kết quả xác minh hoặc rollback
