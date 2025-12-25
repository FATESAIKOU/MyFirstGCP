######################
# Subnet 定義         #
######################

# 應用伺服器用的 Subnet
resource "google_compute_subnetwork" "app_subnet" {
  name          = local.subnet_app_name
  ip_cidr_range = var.app_subnet_cidr
  region        = var.region
  network       = data.google_compute_network.existing_vpc.id

  # 允許 Private Google Access（VM 無外部 IP 也能存取 GCP 服務）
  private_ip_google_access = true

  # 日誌設定（可選）
  # log_config {
  #   aggregation_interval = "INTERVAL_10_MIN"
  #   flow_sampling        = 0.5
  #   metadata             = "INCLUDE_ALL_METADATA"
  # }
}

# 資料庫用的 Subnet（未來供 Private Service Access 使用）
resource "google_compute_subnetwork" "db_subnet" {
  name          = local.subnet_db_name
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
  network       = data.google_compute_network.existing_vpc.id

  private_ip_google_access = true
}
