# Phase 3: 最小可理解資源

## 📋 本階段目標

逐一添加 GCP 資源到 Terraform，每次只處理一類資源。

> ⚠️ **重要**: 每完成一類資源，都需要 Review 後才能繼續

---

## 資源添加順序

根據依賴關係，我們按以下順序添加：

1. **VPC / Subnet / Firewall** ← 基礎網路（先處理既有 VPC）
2. **IAM / Service Account** ← 權限設計
3. **Cloud SQL** ← 資料庫
4. **Compute Instance** ← 應用伺服器
5. **Cloud Storage** ← 附件儲存

---

## 3.1 VPC / Subnet / Firewall

### 🤔 既有 VPC 的處理策略

你已經用 gcloud 建立了 `learn-vpc-iac`，有兩個選擇：

| 策略 | 說明 | 適用情況 |
|-----|------|---------|
| **Data Source** | 只讀取既有資源 | VPC 是共用的、不想 Terraform 管理 |
| **Import** | 將資源匯入 Terraform state | 想要完整用 Terraform 管理 |

### 選擇：使用 Data Source

因為這是教學情境，我們使用 **Data Source** 讀取既有 VPC：

```hcl
# data.tf

# 讀取既有的 VPC
data "google_compute_network" "existing_vpc" {
  name = "learn-vpc-iac"
}
```

### Subnet 資源

在既有 VPC 上建立 Subnet：

```hcl
# network.tf（從 main.tf 拆出）

# 應用伺服器用的 Subnet
resource "google_compute_subnetwork" "app_subnet" {
  name          = "learn-subnet-app"
  ip_cidr_range = "10.20.0.0/24"
  region        = var.region
  network       = data.google_compute_network.existing_vpc.id

  # 允許 Private Google Access（存取 GCP 服務）
  private_ip_google_access = true
}

# 資料庫用的 Subnet（Private IP Google Access）
resource "google_compute_subnetwork" "db_subnet" {
  name          = "learn-subnet-db"
  ip_cidr_range = "10.20.1.0/24"
  region        = var.region
  network       = data.google_compute_network.existing_vpc.id

  private_ip_google_access = true
}
```

### Firewall Rules

```hcl
# firewall.tf

# 允許 SSH via IAP
resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "learn-fw-allow-ssh-iap"
  network = data.google_compute_network.existing_vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # IAP 的 IP 範圍
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ssh-iap"]
}

# 允許應用服務 Port
resource "google_compute_firewall" "allow_app_port" {
  name    = "learn-fw-allow-app-port"
  network = data.google_compute_network.existing_vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-app-port"]
}
```

### 🤔 在公司既有 infra 中會長怎樣？

真實公司的 VPC/Firewall 通常：
- VPC 是全公司共用，由 Platform Team 管理
- 你只會看到 `data source` 讀取 VPC
- Firewall 可能是你可以新增的，但需要命名規範

---

## 3.2 IAM / Service Account

### 設計理念

在 GCP 中，Service Account 是給「程式」使用的身份，不是給「人」使用的。

```hcl
# iam.tf

# 應用程式專用 Service Account
resource "google_service_account" "app_sa" {
  account_id   = "learn-app-sa"
  display_name = "ToDo App Service Account"
  description  = "Service account for ToDo application VM"
}

# 授予最小必要權限
resource "google_project_iam_member" "app_sa_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}
```

### 🤔 為什麼不用 Default Compute SA？

| 比較項目 | Default SA | 專用 SA |
|---------|-----------|--------|
| 預設權限 | Project Editor（過大） | 無（需明確授予） |
| 可追溯性 | 難以區分 | 每個 app 獨立 |
| 符合規範 | ❌ | ✅ |

---

## 3.3 Cloud SQL

### Private Service Access 前置作業

Cloud SQL 使用 Private IP 需要先設定 VPC Peering：

```hcl
# database.tf

# 預留 IP 範圍給 GCP 託管服務
resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services-${var.existing_vpc_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.existing_vpc.id
}

# 建立 VPC Peering
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.existing_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}
```

### Cloud SQL Instance

```hcl
resource "google_sql_database_instance" "main" {
  name             = "learn-sql"
  database_version = "MYSQL_8_0"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false  # 不使用公網 IP
      private_network = data.google_compute_network.existing_vpc.id
    }
  }
}
```

### 🤔 密碼管理策略

```hcl
# 產生隨機密碼
resource "random_password" "db_password" {
  length  = 24
  special = true
}

# 存入 Secret Manager
resource "google_secret_manager_secret" "db_password" {
  secret_id = "learn-db-password"
  replication { auto {} }
}
```

---

## 3.4 Compute Instance

### VM 設定重點

```hcl
# compute.tf

resource "google_compute_instance" "app_vm" {
  name         = "learn-vm-app"
  machine_type = "e2-micro"
  zone         = var.zone

  # 使用專用 SA（不是 default）
  service_account {
    email  = google_service_account.app_sa.email
    scopes = ["cloud-platform"]
  }

  # 網路標籤 → 對應 Firewall Rules
  tags = ["allow-ssh-iap", "allow-app-port"]

  # 啟用 OS Login
  metadata = {
    enable-oslogin = "TRUE"
  }
}
```

### 🤔 Startup Script vs 其他方式

| 方式 | 適用場景 | 優點 | 缺點 |
|-----|---------|------|------|
| Startup Script | 簡單初始化 | 內建、免費 | 不冪等 |
| Packer | 標準化 Image | 快速啟動 | 需維護 |
| Ansible | 複雜配置 | 冪等 | 額外工具 |

---

## 3.5 Cloud Storage

```hcl
# storage.tf

resource "google_storage_bucket" "attachments" {
  name     = "${var.project_id}-attachments"
  location = var.region

  # 統一用 IAM 控制（不用 ACL）
  uniform_bucket_level_access = true

  # 版本控制
  versioning { enabled = true }
}

# Bucket-level IAM（更精確）
resource "google_storage_bucket_iam_member" "app_sa_object_admin" {
  bucket = google_storage_bucket.attachments.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.app_sa.email}"
}
```

---

## ✅ Phase 3 Complete Checklist

- [x] VPC Data Source（讀取既有 VPC）
- [x] Subnet × 2（app + db）
- [x] Firewall × 3（SSH IAP + App Port + Internal）
- [x] Service Account + IAM Bindings × 5
- [x] Cloud SQL + Database + User
- [x] Secret Manager（密碼管理）
- [x] Compute Instance（含 Cloud SQL Proxy）
- [x] Cloud Storage + Bucket IAM

---

## 📝 最終 Review 問題

1. 為什麼 Cloud SQL 要用 Private IP？
2. `depends_on` 在什麼情況下需要明確指定？
3. Service Account 的 `scopes` 和 IAM role 有什麼差別？
4. 為什麼用 `google_storage_bucket_iam_member` 而不是 `google_project_iam_member`？

---

**🎉 恭喜完成 Terraform IaC 教材！**

---

## ✅ Phase 3.1 (VPC) Checklist

- [ ] 理解 Data Source vs Import 的差異
- [ ] 理解為何選擇 Data Source
- [ ] `data.tf` 已定義讀取既有 VPC
- [ ] `network.tf` 已定義 Subnet
- [ ] `firewall.tf` 已定義 Firewall Rules
- [ ] `terraform plan` 顯示預期的資源

---

## 📝 Review 問題

1. 為什麼用 `data.google_compute_network` 而不是 `resource`？
2. `private_ip_google_access = true` 有什麼用途？
3. Firewall 的 `target_tags` 和 `source_ranges` 各是什麼意思？

---

**完成 Review 後，請回覆「OK，繼續 Phase 3.2 (IAM)」**
