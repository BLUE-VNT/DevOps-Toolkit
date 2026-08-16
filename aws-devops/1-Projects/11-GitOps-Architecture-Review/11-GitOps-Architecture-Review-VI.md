---
title: Đánh giá kiến trúc phát hành GitOps
language: vi-VN
translation_group: gitops-architecture-review
translation_of: 11-GitOps-Architecture-Review
translation_status: synchronized
status: proposed
decision: pending
para: project
updated: 2026-08-16
---
# Đánh giá kiến trúc phát hành GitOps
[[11-GitOps-Architecture-Review-ZH|中文]] · [[11-GitOps-Architecture-Review-EN|English]] · [[11-GitOps-Architecture-Review-VI|Tiếng Việt]]

## Sơ đồ kiến trúc

![[31-GitOps-Architecture.png]]

> [!note] Phạm vi sơ đồ
> Sơ đồ thể hiện ranh giới trách nhiệm giữa Developer, GitLab, CI/Jenkins, kho artifact, phê duyệt của Ops, Argo CD, Private EKS, hai máy bastion và truy cập break-glass. Đây là sơ đồ đề xuất và không có nghĩa GitOps đã được phê duyệt.

> [!success] Khuyến nghị
> Chỉ chấp thuận về nguyên tắc sau khi hoàn thành mọi kiểm soát bắt buộc và được phê duyệt chính thức về kiến trúc và bảo mật. Ops giữ quyền phát hành; Argo CD thực thi trạng thái Git đã được phê duyệt.

## Các cơ chế bảo mật
- Triển khai ứng dụng: Git PR → Ops phê duyệt → Argo CD → Private EKS
- Truy cập quản trị: Ops → VPN/MFA → Dual Bastion → AWS

## Ranh giới trách nhiệm
| Chủ thể | Trách nhiệm | Không được phép |
| --- | --- | --- |
| Developer | Code, branch, code/release PR | AWS credential, kubectl, EKS access, merge Production |
| CI/Jenkins | Build, test, SAST/SCA, scan, ký và đẩy artifact | EKS credential, quyền triển khai hoặc merge |
| Ops | Review, phê duyệt, merge, cho phép rollback | Danh tính dùng chung hoặc thay đổi trực tiếp không kiểm toán |
| Argo CD | Pull và đồng bộ desired state đã duyệt | Ghi Git hoặc đặc quyền cluster quá mức |
| Bastion | Quản trị và xử lý sự cố | Trở thành phụ thuộc duy nhất của phát hành thường lệ |
| Break-glass | Khôi phục trong tình huống nghiêm trọng | Phát hành hoặc xử lý sự cố thông thường |

## Phát hành và rollback
```text
Developer → Code PR → CI Build/Test/Scan → Signed Artifact Digest
→ Release PR → Ops Approval → Protected Merge → Argo CD → Private EKS
Incident → Rollback PR → Ops Approval → Merge → Argo CD → Previous Digest
```

## Kiểm soát bắt buộc
- Bảo vệ repository/branch phát hành, CODEOWNERS, Ops phê duyệt, hai người phê duyệt Production; cấm direct/force push, tự phê duyệt và admin bypass.
- CI có thể mở nhưng không được phê duyệt hoặc merge Production PR; mọi PR phải liên kết phiếu thay đổi, kết quả CI và digest.
- Bật ECR tag immutability; triển khai theo digest; lưu SBOM và kết quả scan; ký artifact và xác minh tại admission; kiểm soát ngoại lệ và xóa artifact.
- Argo CD/EKS ở mạng riêng; Git credential chỉ đọc; dùng IRSA hoặc EKS Pod Identity; Project/Application/RBAC theo đặc quyền tối thiểu; giới hạn repository, cluster, namespace và loại tài nguyên.
- Quyết định và kiểm thử Auto-Sync, Prune, Self-Heal; ngăn nâng quyền qua Helm/Kustomize, hook, Job, RBAC hoặc IaC.
- Không lưu secret dạng rõ trong Git; dùng nguồn secret riêng. Liên kết phiếu, PR, commit, digest, phê duyệt và lần sync. Lưu tập trung GitLab, CI, Argo CD, EKS audit và CloudTrail.

## Thay đổi chính sách cần phê duyệt
Hiện tại: `Ops → Dual Bastion → Manual Deployment`

Đề xuất: `Ops Approval → Protected Git Merge → Argo CD Deployment`

Ops vẫn là bên duy nhất có quyền phê duyệt phát hành Production; Argo CD trở thành danh tính thực thi thường lệ duy nhất. Bastion tiếp tục phục vụ quản trị, xử lý sự cố và tình huống khẩn cấp đã được cho phép.

## Kiểm thử nghiệm thu
- Developer không thể trực tiếp hoặc gián tiếp merge Production; CI không thể truy cập EKS hoặc assume deployment role.
- Artifact chưa ký, sai digest hoặc không tuân thủ không thể triển khai.
- Argo CD không thể nhắm đến repository, cluster, namespace hoặc tài nguyên ngoài danh sách cho phép.
- Phát hành đã duyệt và GitOps rollback vẫn hoạt động khi văn phòng/bastion gặp sự cố.
- Lỗi Argo CD phải cảnh báo mà không gây drift ngoài kiểm soát; break-glass cần hai người và phải cảnh báo.
- Mọi Pod Production đang chạy phải truy vết được tới phiếu thay đổi, commit, người phê duyệt và digest.
