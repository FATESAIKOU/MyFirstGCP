# Phase 0: 本機環境與前置確認

## 📋 本階段目標

在開始寫任何 Terraform 之前，我們必須確保：
1. Terraform CLI 已正確安裝
2. GCP 認證已完成
3. 專案環境變數已確認

> ⚠️ **重要**: 本階段 **不會** 產生任何 `.tf` 檔案，也 **不會** 執行 `terraform init`

---

## 1. Terraform 安裝確認（macOS）

### 檢查是否已安裝

```bash
terraform version
```

預期輸出類似：
```
Terraform v1.x.x
on darwin_arm64
```

### 若尚未安裝

使用 Homebrew 安裝：
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

或手動安裝：
```bash
# 下載並解壓縮
# https://developer.hashicorp.com/terraform/downloads
```

---

## 2. GCP 認證狀態確認

### 2.1 確認 gcloud 已登入

```bash
gcloud auth list
```

預期輸出：應顯示你的帳號並標示 `ACTIVE`

### 2.2 確認 Application Default Credentials (ADC)

Terraform 使用 ADC 進行認證：

```bash
gcloud auth application-default login
```

這會開啟瀏覽器進行 OAuth 登入，完成後 Terraform 就能使用你的身份。

### 2.3 確認目前專案

```bash
gcloud config get-value project
```

預期輸出：`learn-gcp-ksf`（或你的專案 ID）

若需要切換專案：
```bash
gcloud config set project YOUR_PROJECT_ID
```

---

## 3. 確認既有 VPC 狀態

你已經用 gcloud 建立了 VPC，讓我們確認它存在：

```bash
gcloud compute networks list --filter="name=learn-vpc-iac"
```

預期輸出：
```
NAME            SUBNET_MODE  BGP_ROUTING_MODE  IPV4_RANGE  GATEWAY_IPV4
learn-vpc-iac   CUSTOM       REGIONAL
```

### 🤔 為什麼 VPC 已經存在？

在真實公司環境中，你接手的 infra 通常不是從零開始。
這個 VPC 就是模擬「既有基礎設施」的情境。

後續 Terraform 有兩種處理方式：
1. **Import**: 將既有資源匯入 Terraform state
2. **Data Source**: 只讀取既有資源的資訊

我們會在 Phase 3 詳細說明這個抉擇。

---

## 4. 環境變數備忘（供後續使用）

請確認以下資訊，後續會用到：

| 項目 | 值 | 確認指令 |
|-----|-----|---------|
| Project ID | `learn-gcp-ksf` | `gcloud config get-value project` |
| Region | `asia-northeast1` | 自行決定 |
| Zone | `asia-northeast1-a` | 自行決定 |
| 既有 VPC | `learn-vpc-iac` | `gcloud compute networks list` |

---

## ✅ Phase 0 Checklist

請逐一確認：

- [ ] `terraform version` 顯示版本號
- [ ] `gcloud auth list` 顯示你的帳號為 ACTIVE
- [ ] `gcloud auth application-default login` 已完成
- [ ] `gcloud config get-value project` 顯示正確專案
- [ ] `gcloud compute networks list` 可看到 `learn-vpc-iac`

---

## 📝 Review 問題（自我檢查）

1. Terraform 是用什麼認證方式連接 GCP？
2. 為什麼要用 `application-default login` 而不是 service account？
3. 既有的 VPC 後續要怎麼處理？

---

**完成以上所有項目後，請回覆「OK，進入 Phase 1」**

➡️ 下一步：[Phase 1: Terraform 專案骨架](phase1-skeleton.md)
