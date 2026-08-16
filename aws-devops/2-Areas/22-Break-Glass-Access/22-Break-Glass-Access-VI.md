---
title: Truy cập khẩn cấp
language: vi-VN
translation_group: break-glass-access
translation_of: 22-Break-Glass-Access
translation_status: synchronized
status: draft
para: area
updated: 2026-08-16
---
# Truy cập khẩn cấp
[[22-Break-Glass-Access-ZH|中文]] · [[22-Break-Glass-Access-EN|English]] · [[22-Break-Glass-Access-VI|Tiếng Việt]]

Chỉ sử dụng khi kênh Ops thông thường hoàn toàn không khả dụng, ví dụ mất mạng hoặc trung tâm dữ liệu mất điện.

- Hai người quản lý độc lập giữ các yếu tố khác nhau; bắt buộc phê duyệt hai người.
- Niêm phong ngoại tuyến thông tin xác thực và thiết bị MFA độc lập.
- Không lưu trong script, máy bastion hoặc kho dùng chung thông thường.
- Khi kích hoạt phải cảnh báo bộ phận Security và mở hồ sơ sự cố.
- Thu hồi phiên, xoay vòng thông tin xác thực và đánh giá mọi lần sử dụng.
- Kiểm thử hàng quý, bao gồm khả năng truy cập qua SCP và trust policy.

Phải ghi mã sự cố, lý do, hai người phê duyệt, thời gian bắt đầu/kết thúc, thao tác, việc xoay vòng và báo cáo kiểm toán.
