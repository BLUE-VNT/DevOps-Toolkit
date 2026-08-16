---
title: Kiến trúc tài khoản
language: vi-VN
translation_group: account-architecture
translation_of: 20-Account-Architecture
translation_status: synchronized
status: draft
para: area
updated: 2026-08-16
---
# Kiến trúc tài khoản
[[20-Account-Architecture-ZH|中文]] · [[20-Account-Architecture-EN|English]] · [[20-Account-Architecture-VI|Tiếng Việt]]

| Tài khoản | Mục đích | Kiểm soát chính |
| --- | --- | --- |
| Operations | Danh tính tập trung, cổng vận hành, kiểm toán | MFA, STS, đặc quyền tối thiểu |
| Workload | Ứng dụng, EKS, RDS, Kafka | Subnet riêng, không có điểm quản trị công khai |
| Production Entry | Cổng lưu lượng Production | ALB/NLB, WAF, PrivateLink |
| Test Entry | Cổng lưu lượng Test | Internal ALB, DNS riêng |

## Quyết định cần xác nhận
- [ ] Organizations/SCP; Region/AZ; VPC/subnet/route
- [ ] DNS, chứng chỉ, ingress; log tập trung và thời gian lưu giữ
- [ ] Sao lưu, RPO/RTO; ngân sách và cảnh báo chi phí
