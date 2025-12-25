######################
# Service Account     #
######################

# 應用程式專用 Service Account
# 遵循最小權限原則，只授予必要的權限
resource "google_service_account" "app_sa" {
  account_id   = local.sa_app_name
  display_name = "ToDo App Service Account"
  description  = "Service account for ToDo application VM"
  project      = var.project_id
}

######################
# IAM Bindings        #
######################

# 授予 Cloud SQL Client 權限（連接 Cloud SQL）
resource "google_project_iam_member" "app_sa_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# 授予 Cloud Storage Object Admin 權限（讀寫附件）
resource "google_project_iam_member" "app_sa_storage_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.app_sa.email}"

  # 條件：只允許存取特定 bucket（可選，更安全）
  # condition {
  #   title       = "Only app bucket"
  #   description = "Only allow access to the app's attachment bucket"
  #   expression  = "resource.name.startsWith('projects/_/buckets/${local.bucket_name}')"
  # }
}

# 授予 Secret Manager 存取權限（讀取資料庫密碼等）
resource "google_project_iam_member" "app_sa_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# 授予 Logging 寫入權限（應用程式日誌）
resource "google_project_iam_member" "app_sa_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# 授予 Monitoring 指標寫入權限
resource "google_project_iam_member" "app_sa_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

######################
# 設計說明            #
######################

# 🤔 為什麼要建立專用 Service Account？
#
# 1. 最小權限原則：只授予應用程式需要的權限
# 2. 可追溯性：審計日誌可以識別是哪個應用程式的操作
# 3. 隔離性：不同應用程式使用不同 SA，互不影響
#
# 如果使用 Compute Engine Default SA：
# - 權限過大（預設是 Project Editor）
# - 無法區分不同應用程式
# - 不符合企業安全規範
