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

請回覆「OK，繼續 IAM/Service Account」後再展開此段落。

---

## 3.3 Cloud SQL

請回覆「OK，繼續 Cloud SQL」後再展開此段落。

---

## 3.4 Compute Instance

請回覆「OK，繼續 Compute Instance」後再展開此段落。

---

## 3.5 Cloud Storage

請回覆「OK，繼續 Cloud Storage」後再展開此段落。

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
