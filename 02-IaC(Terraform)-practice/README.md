# Terraform IaC Practice - ToDo Application on GCP

## 📋 專案概述

這是一個教學導向的 Terraform IaC 專案，目標是讓使用者：
- 理解 Terraform 如何描述 GCP 資源
- 學會接手與 Review 既有的 Terraform 專案
- 建立「可維護、可討論」的 IaC 實踐經驗

## ✅ 專案狀態：已完成驗證

此專案已通過 `terraform apply` 驗證，所有資源皆可正常建立。

## 🎯 目標架構資源

| 資源類型 | 用途 | 檔案 |
|---------|------|------|
| VPC / Subnet / Firewall | 網路隔離與存取控制 | `network.tf`, `firewall.tf` |
| Compute Engine | App Server + Cloud SQL Auth Proxy | `compute.tf` |
| Cloud SQL (MySQL) | 資料庫（Private IP） | `database.tf` |
| Cloud Storage | 附件儲存 | `storage.tf` |
| IAM / Service Account | 最小權限原則 | `iam.tf` |

## 📁 專案結構

```
02-IaC(Terraform)-practice/
├── README.md                    # 本文件
├── Makefile                     # 常用指令快捷方式
├── phases/                      # 分階段教學文件
│   ├── phase0-prerequisites.md  # 環境前置確認
│   ├── phase1-skeleton.md       # 專案骨架說明
│   ├── phase2-provider.md       # Provider/Backend 設計
│   └── phase3-resources.md      # 資源定義說明
├── versions.tf                  # Terraform 版本約束
├── providers.tf                 # GCP Provider 設定
├── variables.tf                 # 變數定義
├── locals.tf                    # 本地計算變數
├── data.tf                      # Data Sources（讀取既有 VPC）
├── main.tf                      # 資源索引說明
├── network.tf                   # Subnet 定義
├── firewall.tf                  # Firewall Rules
├── iam.tf                       # Service Account + IAM
├── database.tf                  # Cloud SQL + Secret Manager
├── compute.tf                   # Compute Engine VM
├── storage.tf                   # Cloud Storage
├── outputs.tf                   # 輸出值
├── terraform.tfvars.example     # 變數範例
└── .gitignore                   # Git 忽略規則
```

## ⚠️ 前提條件

1. ✅ 已建立 VPC: `learn-vpc-iac` (subnet-mode=custom)
2. ✅ Terraform CLI 已安裝
3. ✅ gcloud CLI 已認證 (`gcloud auth application-default login`)
4. ✅ 專案 ID 已確認

---

## 🚀 快速開始

```bash
# 1. 複製變數檔案
cp terraform.tfvars.example terraform.tfvars

# 2. 編輯變數值
vim terraform.tfvars

# 3. 初始化
make init
# 或 terraform init

# 4. 查看計畫
make plan
# 或 terraform plan

# 5. 部署（會建立實際資源，會產生費用！）
make apply
# 或 terraform apply

# 6. 清理資源
make destroy
# 或 terraform destroy
```

## 📚 教學文件

建議按順序閱讀：

1. [Phase 0: 環境前置確認](phases/phase0-prerequisites.md)
2. [Phase 1: 專案骨架](phases/phase1-skeleton.md)
3. [Phase 2: Provider/Backend 設計](phases/phase2-provider.md)
4. [Phase 3: 資源定義](phases/phase3-resources.md)
