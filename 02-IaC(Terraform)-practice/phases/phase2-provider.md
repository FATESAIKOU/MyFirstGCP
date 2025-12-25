# Phase 2: Provider / Backend 設計

## 📋 本階段目標

設定 Terraform 的：
1. 版本約束
2. GCP Provider
3. Backend（State 儲存位置）

> ⚠️ **重要**: 本階段 **不建立任何 GCP 資源**，只設定 Terraform 本身

---

## 1. Terraform 版本約束

### versions.tf

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
```

### 🤔 版本約束設計理由

| 設定 | 說明 |
|-----|------|
| `required_version = ">= 1.5.0"` | 確保使用較新的 Terraform，支援最新語法 |
| `source = "hashicorp/google"` | 明確指定 Provider 來源（Registry） |
| `version = "~> 5.0"` | 允許 5.x 任何版本，但不允許 6.0（可能有 breaking change） |

### 版本語法速查

| 語法 | 意義 | 範例 |
|-----|------|------|
| `= 5.0.0` | 精確版本 | 只用 5.0.0 |
| `>= 5.0.0` | 大於等於 | 5.0.0, 5.1.0, 6.0.0 都可 |
| `~> 5.0` | 相容版本 | 5.x.x 可，6.0 不可 |
| `>= 5.0, < 6.0` | 範圍 | 等同 ~> 5.0 |

---

## 2. Provider 設定

### providers.tf

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

### 🤔 為什麼用變數而不是寫死？

- **可重用性**: 同一套 code 可用在不同專案/環境
- **安全性**: 敏感值不會 commit 到 Git
- **可 Review**: 變數集中管理，Review 時好檢查

### 認證方式說明

Terraform GCP Provider 支援多種認證：

| 方式 | 適用場景 | 設定方式 |
|-----|---------|---------|
| ADC (Application Default Credentials) | 本機開發 | `gcloud auth application-default login` |
| Service Account Key | CI/CD | `GOOGLE_CREDENTIALS` 環境變數 |
| Workload Identity | GKE 內執行 | 自動 |

我們目前使用 **ADC**，不需要額外設定。

---

## 3. 變數定義

### variables.tf

```hcl
variable "project_id" {
  description = "GCP 專案 ID"
  type        = string
}

variable "region" {
  description = "GCP 預設區域"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "GCP 預設可用區"
  type        = string
  default     = "asia-northeast1-a"
}

variable "environment" {
  description = "環境名稱 (dev/staging/prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment 必須是 dev, staging, 或 prod"
  }
}
```

### 🤔 變數設計考量

| 變數 | 有無 default | 理由 |
|-----|-------------|------|
| `project_id` | ❌ 無 | 強制使用者指定，避免誤用 |
| `region` | ✅ 有 | 有合理預設，但可覆蓋 |
| `environment` | ✅ 有 + validation | 限制合法值，避免 typo |

---

## 4. Backend 設定（State 儲存）

### 選項比較

| Backend | 優點 | 缺點 | 適用場景 |
|---------|------|------|---------|
| Local | 簡單、快速 | 無法多人協作、無版本控制 | 個人練習 |
| GCS | 支援 locking、版本控制 | 需要先建立 bucket | 團隊協作 |
| Terraform Cloud | 完整 CI/CD | 需要帳號、可能有費用 | 企業 |

### 目前選擇：Local Backend

```hcl
# 在 versions.tf 中，不需要額外設定
# Terraform 預設使用 local backend
```

### 未來升級為 GCS Backend

```hcl
terraform {
  backend "gcs" {
    bucket = "your-terraform-state-bucket"
    prefix = "todo-app/state"
  }
}
```

> 💡 **注意**: Backend 設定不能使用變數，必須寫死或用 `-backend-config` 參數

---

## 5. terraform.tfvars.example

```hcl
# 複製為 terraform.tfvars 並填入實際值
# ⚠️ 不要 commit terraform.tfvars

project_id  = "learn-gcp-ksf"
region      = "asia-northeast1"
zone        = "asia-northeast1-a"
environment = "dev"
```

---

## 6. 驗證設定

完成以上設定後，可以執行：

```bash
# 進入專案目錄
cd 02-IaC\(Terraform\)-practice

# 初始化 Terraform（下載 Provider）
terraform init

# 驗證設定語法
terraform validate

# 格式化程式碼
terraform fmt
```

### 預期輸出

```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/google versions matching "~> 5.0"...
- Installing hashicorp/google v5.x.x...
- Installed hashicorp/google v5.x.x

Terraform has been successfully initialized!
```

---

## ✅ Phase 2 Checklist

- [ ] `versions.tf` 已設定版本約束
- [ ] `providers.tf` 已設定 GCP Provider
- [ ] `variables.tf` 已定義基本變數
- [ ] `terraform.tfvars` 已填入實際值
- [ ] `terraform init` 成功執行
- [ ] `terraform validate` 沒有錯誤

---

## 📝 Review 問題（自我檢查）

1. `~> 5.0` 這個版本語法是什麼意思？
2. 為什麼 `project_id` 沒有設定 default？
3. Local backend 在什麼情況下不適用？
4. 如何讓多人協作同一個 Terraform 專案？

---

**完成 Review 後，請回覆「OK，進入 Phase 3」**

➡️ 下一步：[Phase 3: 最小可理解資源](phase3-resources.md)
