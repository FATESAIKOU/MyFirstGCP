######################
# 輸出值定義          #
######################

# VPC 資訊
output "vpc_id" {
  description = "既有 VPC 的 ID"
  value       = data.google_compute_network.existing_vpc.id
}

output "vpc_self_link" {
  description = "既有 VPC 的 self_link"
  value       = data.google_compute_network.existing_vpc.self_link
}

# 專案資訊
output "project_number" {
  description = "GCP 專案編號"
  value       = data.google_project.current.number
}

# Subnet 資訊
output "app_subnet_id" {
  description = "應用伺服器 Subnet ID"
  value       = google_compute_subnetwork.app_subnet.id
}

output "db_subnet_id" {
  description = "資料庫 Subnet ID"
  value       = google_compute_subnetwork.db_subnet.id
}

# VM 資訊
output "vm_name" {
  description = "應用伺服器 VM 名稱"
  value       = google_compute_instance.app_vm.name
}

output "vm_external_ip" {
  description = "應用伺服器外部 IP"
  value       = google_compute_instance.app_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_internal_ip" {
  description = "應用伺服器內部 IP"
  value       = google_compute_instance.app_vm.network_interface[0].network_ip
}

# Cloud SQL 資訊
output "sql_connection_name" {
  description = "Cloud SQL 連線名稱（供 Cloud SQL Auth Proxy 使用）"
  value       = google_sql_database_instance.main.connection_name
}

output "sql_private_ip" {
  description = "Cloud SQL Private IP"
  value       = google_sql_database_instance.main.private_ip_address
}

# Cloud Storage 資訊
output "bucket_name" {
  description = "附件儲存 Bucket 名稱"
  value       = google_storage_bucket.attachments.name
}

output "bucket_url" {
  description = "附件儲存 Bucket URL"
  value       = google_storage_bucket.attachments.url
}

# Service Account 資訊
output "app_service_account_email" {
  description = "應用程式 Service Account Email"
  value       = google_service_account.app_sa.email
}

# 連線指令（方便使用）
output "ssh_command" {
  description = "SSH 連線指令（透過 IAP）"
  value       = "gcloud compute ssh ${google_compute_instance.app_vm.name} --zone=${var.zone} --tunnel-through-iap"
}

output "app_url" {
  description = "應用程式 URL"
  value       = "http://${google_compute_instance.app_vm.network_interface[0].access_config[0].nat_ip}:8080"
}
