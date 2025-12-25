######################
# Cloud Storage       #
######################

resource "google_storage_bucket" "attachments" {
  name     = local.bucket_name
  location = var.region

  # 統一存取控制（推薦）
  uniform_bucket_level_access = true

  # 版本控制（可選，用於復原誤刪檔案）
  versioning {
    enabled = true
  }

  # 生命週期規則（自動清理舊版本）
  lifecycle_rule {
    condition {
      num_newer_versions = 3 # 保留最新 3 個版本
    }
    action {
      type = "Delete"
    }
  }

  # 防止意外刪除（生產環境設為 true）
  force_destroy = true # 開發環境允許刪除

  # 標籤
  labels = local.common_labels
}

######################
# Bucket IAM          #
######################

# 授予 App Service Account 物件存取權限
resource "google_storage_bucket_iam_member" "app_sa_object_admin" {
  bucket = google_storage_bucket.attachments.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.app_sa.email}"
}

######################
# 設計說明            #
######################

# 🤔 為什麼用 uniform_bucket_level_access？
#
# 1. 簡化權限管理：只用 IAM，不用 ACL
# 2. 更安全：避免 ACL 和 IAM 權限混淆
# 3. 符合企業政策：大多數公司會強制啟用
#
# 🤔 為什麼用 Bucket-level IAM 而非 Project-level？
#
# 1. 最小權限：只授予特定 bucket 權限
# 2. 隔離性：不同 bucket 可以有不同權限
# 3. 可讀性：權限設定和資源放在一起，好理解
