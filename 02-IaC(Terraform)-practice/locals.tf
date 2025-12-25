######################
# 本地計算變數        #
######################

locals {
  # 資源命名前綴（統一命名規則）
  name_prefix = "learn"

  # 完整資源名稱
  subnet_app_name = "${local.name_prefix}-subnet-app"
  subnet_db_name  = "${local.name_prefix}-subnet-db"

  # Firewall 規則名稱
  fw_ssh_iap_name  = "${local.name_prefix}-fw-allow-ssh-iap"
  fw_app_port_name = "${local.name_prefix}-fw-allow-app-port"

  # VM 名稱
  vm_app_name = "${local.name_prefix}-vm-app"

  # Cloud SQL 名稱
  sql_instance_name = "${local.name_prefix}-sql"

  # Cloud Storage bucket 名稱（全域唯一）
  bucket_name = "${var.project_id}-${var.bucket_name_suffix}"

  # Service Account 名稱
  sa_app_name = "${local.name_prefix}-app-sa"

  # 常用標籤
  common_labels = {
    environment = var.environment
    managed_by  = "terraform"
    project     = var.project_id
  }
}
