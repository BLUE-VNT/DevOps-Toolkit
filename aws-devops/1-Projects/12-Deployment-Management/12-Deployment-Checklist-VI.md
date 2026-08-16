---
title: Danh sách kiểm tra triển khai
language: vi-VN
translation_group: deployment-checklist
translation_of: 12-Deployment-Checklist
translation_status: synchronized
status: active
para: project
updated: 2026-08-16
---
# Danh sách kiểm tra triển khai
[[12-Deployment-Checklist-ZH|中文]] · [[12-Deployment-Checklist-EN|English]] · [[12-Deployment-Checklist-VI|Tiếng Việt]]

## Trước khi triển khai
- [ ] Phiếu đã được duyệt; đã xác minh phiên bản artifact và SHA-256
- [ ] Đã xem xét kiểm thử, quét bảo mật, tính tương thích và thay đổi cơ sở dữ liệu
- [ ] Đã kiểm thử rollback; xác nhận giám sát, cảnh báo, khung giờ, người thực hiện và người kiểm tra
## Trong khi triển khai
- [ ] Dùng danh tính cá nhân, MFA, đường bastion đã phê duyệt và role tạm thời đúng môi trường
- [ ] Ghi thời gian bắt đầu và lệnh; chạy kiểm tra tình trạng và smoke test
## Sau khi triển khai
- [ ] Xác nhận dịch vụ, phụ thuộc, chỉ số, log và sự kiện kiểm toán
- [ ] Cập nhật phiếu; kết thúc phiên và quyền tạm thời
- [ ] Rollback và đánh giá sự cố nếu có bất thường
