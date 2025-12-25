# Terraform IaC Practice - ToDo Application on GCP

## 📋 專案概述

這是一個教學導向的 Terraform IaC 專案，目標是讓使用者：
- 理解 Terraform 如何描述 GCP 資源
- 學會接手與 Review 既有的 Terraform 專案
- 建立「可維護、可討論」的 IaC 實踐經驗

## 🎯 目標架構資源

| 資源類型 | 用途 |
|---------|------|
| VPC / Subnet / Firewall | 網路隔離與存取控制 |
| Compute Engine | App Server + Cloud SQL Auth Proxy |
| Cloud SQL (MySQL) | 資料庫（Private IP） |
| Cloud Storage | 附件儲存 |
| IAM / Service Account | 最小權限原則 |

## 📁 專案結構

```
02-IaC(Terraform)-practice/
├── README.md                 # 本文件
├── phases/                   # 分階段教學文件
│   ├── phase0-prerequisites.md
│   ├── phase1-skeleton.md
│   ├── phase2-provider.md
│   └── phase3-resources.md
├── main.tf                   # 主要資源定義（逐步添加）
├── variables.tf              # 變數定義
├── outputs.tf                # 輸出值
├── providers.tf              # Provider 設定
├── terraform.tfvars.example  # 變數值範例
└── modules/                  # （Phase 3+ 才會使用）
```

## ⚠️ 前提條件

1. ✅ 已建立 VPC: `learn-vpc-iac` (subnet-mode=custom)
2. ⬜ Terraform CLI 已安裝
3. ⬜ gcloud CLI 已認證
4. ⬜ 專案 ID 已確認

---

## 🚀 開始之前

**請按順序完成以下 Phase，每個 Phase 完成後需經過 Review 才能進入下一步。**

➡️ 請先閱讀 [Phase 0: 環境前置確認](phases/phase0-prerequisites.md)
