---
title: Tổng hợp và đánh giá đề xuất kiến trúc vận hành
language: vi-VN
translation_group: operations-proposal-review
translation_of: 14-Operations-Proposal-Review
translation_status: synchronized
status: proposed
decision: pending
para: project
updated: 2026-08-16
source_type: external-proposal
---

# Tổng hợp và đánh giá đề xuất kiến trúc vận hành

[[14-Operations-Proposal-Review-ZH|中文]] · [[14-Operations-Proposal-Review-EN|English]] · [[14-Operations-Proposal-Review-VI|Tiếng Việt]]

> [!warning] Trạng thái
> Tài liệu này tóm tắt đề xuất trạng thái mục tiêu từ bên ngoài; đây chưa phải kiến trúc đã phê duyệt. Lệnh, giá và cấu hình trong tệp đính kèm chỉ là tài liệu tham khảo. Quy định hiện hành vẫn là [[10-Release-Process-VI|quy trình phát hành đã phê duyệt]].

## Kết luận điều hành

Đề xuất sử dụng bốn AWS Account, ba VPC workload cô lập, PrivateLink ở cấp dịch vụ, Jenkins do Ops khởi động và Argo CD đồng bộ trong private EKS. Hướng thiết kế phù hợp với workload riêng tư, giảm bề mặt mạng, quyền phát hành của Ops và khả năng kiểm toán. Chỉ nên phê duyệt sau khi làm rõ đường quản trị, quyền Jenkins, mức cô lập tài khoản, mô hình phê duyệt GitOps, HA/DR, quản trị bảo mật tập trung và chi phí hiện hành.

## Sơ đồ nguồn

![[34-Multi-Account-Architecture.png]]

![[35-Network-Overview.png]]

![[36-Routing-Security-Matrix.png]]

## Mô hình tài khoản và mạng

| Tài khoản | Trách nhiệm | Mạng và thành phần |
| --- | --- | --- |
| 1 | Private workloads | Production `10.10.0.0/16`, Test `10.40.0.0/16`, Tools `10.50.0.0/16`; EKS, dữ liệu, Argo CD, công cụ CI |
| 2 | Operations và Security | Operations `10.20.0.0/16`; VPN/DX, SSM, kiểm toán, dịch vụ bảo mật, break-glass |
| 3 | Production entry | `10.30.0.0/16`; Cloudflare, public ALB, Nginx/API Gateway, PrivateLink endpoint |
| 4 | Test entry | `10.60.0.0/16`; VPN/ALB nội bộ, Nginx, DNS riêng, PrivateLink endpoint |

Production, Test và Tools không có tuyến trực tiếp. Entry Account không được truy cập cơ sở dữ liệu riêng. Security Group riêng từ chối ingress công khai. Truy cập ứng dụng liên tài khoản dự kiến dùng PrivateLink TCP/HTTPS 443.

## Quy trình phát hành đề xuất

```text
Developer → GitLab Review/Merge → Ops starts Jenkins
→ Build/Test/Scan → ECR/Nexus → Update Helm Manifest
→ Argo CD Pull/Sync → Private EKS
```

Developer không có quyền AWS/EKS/kubectl. GitLab không tự động kích hoạt Jenkins. Jenkins chỉ build; Argo CD thực hiện triển khai.

## Điểm mạnh

- Workload không có điểm vào công khai; chỉ công bố dịch vụ cụ thể giữa các tài khoản.
- Không có định tuyến ngang giữa Production, Test và Tools.
- Tách trách nhiệm entry, workload và operations.
- Argo CD dùng pull model; thiết kế bao gồm MFA, credential tạm thời, SSM, CloudTrail, GuardDuty, Security Hub và break-glass.

## Vấn đề bắt buộc xử lý

1. Báo cáo nói Jenkins không có quyền triển khai nhưng ma trận SG cho phép `Jenkins role → Private EKS API : 443`. Phải xóa hoặc mô tả mục đích chỉ đọc rất hẹp cùng RBAC.
2. Chưa xác định đường từ Operations tới private EKS trong khi Peering/TGW bị từ chối. Phải mô tả đầy đủ route, DNS, endpoint và SG.
3. Jenkins ghi Helm manifest. Jenkins chỉ nên tạo Release PR, không được ghi trực tiếp vào branch Production được bảo vệ; Ops/CODEOWNERS phải phê duyệt và merge.
4. Production, Test và Tools dùng chung AWS Account, nên chỉ cô lập bằng VPC/IAM/RBAC. Phải chấp nhận rủi ro này chính thức hoặc tách tài khoản.
5. Phải chọn một cơ chế phát hành có thẩm quyền: Ops khởi động Jenkins thủ công hoặc CI build tự động với Ops độc quyền phê duyệt Release PR.

## Yêu cầu thiết kế bổ sung

- Bảo vệ origin Cloudflare và ngăn truy cập trực tiếp ALB.
- Xác định điểm kết thúc TLS và chủ sở hữu chứng chỉ qua ALB/Nginx/NLB/PrivateLink.
- Artifact theo digest bất biến, chữ ký, SBOM, scan, admission policy và trách nhiệm ECR/Nexus rõ ràng.
- Organizations/Control Tower, SCP, log archive, quản trị bảo mật, endpoint/KMS policy, secret, DNS, egress và WAF.
- HA, backup, RPO/RTO và DR cho EKS, Argo CD, CI, kho artifact và nền tảng dữ liệu.
- Break-glass hai người, MFA phần cứng ngoại tuyến, cảnh báo, xoay vòng và diễn tập hàng quý.

## Cách hiểu chi phí

Báo cáo đưa ra ví dụ tại Singapore: Peering có chi phí kết nối cố định `0 USD/tháng`; PrivateLink khoảng `29,20 USD/tháng`, hoặc `39,44 USD/tháng` với 1 TB; bốn TGW attachment cộng 1 TB khoảng `166,48 USD/tháng`. Các số này chưa gồm NLB, cross-AZ, DNS, log, monitoring và endpoint khác; phải xác minh lại theo giá AWS hiện hành. Nên chọn PrivateLink vì khả năng cô lập, không phải vì giả định chi phí thấp nhất.

## Khuyến nghị

Giữ trạng thái `proposed / pending`. Chỉ chấp thuận hướng mạng về nguyên tắc sau khi đóng mọi vấn đề bắt buộc, sau đó hợp nhất quy trình phát hành với [[11-GitOps-Architecture-Review-VI|đánh giá GitOps]] thành một thiết kế có thẩm quyền duy nhất.
