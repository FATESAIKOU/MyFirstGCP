######################
# Private Service Access (Cloud SQL Private IP 前置作業)
######################

# 為 Cloud SQL Private IP 預留內部 IP 範圍
resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services-${var.existing_vpc_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.existing_vpc.id
  address       = "10.100.0.0" # 預留範圍，避免與其他 subnet 衝突
}

# 建立 VPC Peering 連線（連接 GCP 託管服務網路）
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.existing_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

  # 刪除時不要刪除 peering（避免影響其他服務）
  deletion_policy = "ABANDON"
}

######################
# Cloud SQL Instance  #
######################

resource "google_sql_database_instance" "main" {
  name             = local.sql_instance_name
  database_version = var.db_version
  region           = var.region

  # 依賴 VPC Peering 連線完成
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.db_tier
    availability_type = "ZONAL" # 單區（開發用），生產環境用 REGIONAL

    # 使用 Private IP
    ip_configuration {
      ipv4_enabled                                  = false # 不使用公網 IP
      private_network                               = data.google_compute_network.existing_vpc.id
      enable_private_path_for_google_cloud_services = true
    }

    # Backup 設定
    backup_configuration {
      enabled            = true
      binary_log_enabled = true # MySQL 需要此設定才能 point-in-time recovery
      start_time         = "03:00" # UTC 時間
    }

    # 維護視窗
    maintenance_window {
      day          = 7 # 週日
      hour         = 3 # UTC 03:00
      update_track = "stable"
    }

    # 標籤
    user_labels = local.common_labels
  }

  # 刪除保護（生產環境應設為 true）
  deletion_protection = false
}

# 建立資料庫
resource "google_sql_database" "app_db" {
  name     = "todo_app"
  instance = google_sql_database_instance.main.name
  charset  = "utf8mb4"
}

######################
# 資料庫使用者        #
######################

# 產生隨機密碼
resource "random_password" "db_password" {
  length  = 24
  special = true
}

# 建立資料庫使用者
resource "google_sql_user" "app_user" {
  name     = "app_user"
  instance = google_sql_database_instance.main.name
  password = random_password.db_password.result
}

# 將密碼存入 Secret Manager
resource "google_secret_manager_secret" "db_password" {
  secret_id = "${local.name_prefix}-db-password"

  replication {
    auto {}
  }

  labels = local.common_labels
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

######################
# 設計說明            #
######################

# 🤔 為什麼用 Private IP 而不是 Public IP？
#
# 1. 安全性：資料庫不暴露在公網
# 2. 效能：走 VPC 內部網路，延遲更低
# 3. 成本：不需要額外的 Public IP 費用
#
# 🤔 為什麼用 Secret Manager 存密碼？
#
# 1. 不寫死在 Terraform（tfstate 也會有）
# 2. 可以版本控制、輪換
# 3. 應用程式透過 IAM 存取，不需要 key file
