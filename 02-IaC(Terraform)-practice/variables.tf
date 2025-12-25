#################
# 專案層級變數  #
#################

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

#################
# 網路相關變數  #
#################

variable "existing_vpc_name" {
  description = "既有 VPC 名稱（已用 gcloud 建立）"
  type        = string
  default     = "learn-vpc-iac"
}

variable "app_subnet_cidr" {
  description = "應用伺服器 Subnet CIDR"
  type        = string
  default     = "10.20.0.0/24"
}

variable "db_subnet_cidr" {
  description = "資料庫 Subnet CIDR（供 Private Service Access 使用）"
  type        = string
  default     = "10.20.1.0/24"
}

#################
# 運算資源變數  #
#################

variable "machine_type" {
  description = "Compute Engine 機型"
  type        = string
  default     = "e2-micro"
}

variable "boot_disk_size" {
  description = "Boot Disk 大小 (GB)"
  type        = number
  default     = 20
}

#################
# 資料庫變數    #
#################

variable "db_version" {
  description = "Cloud SQL 資料庫版本"
  type        = string
  default     = "MYSQL_8_0"
}

variable "db_tier" {
  description = "Cloud SQL 機型"
  type        = string
  default     = "db-f1-micro"
}

#################
# 儲存空間變數  #
#################

variable "bucket_name_suffix" {
  description = "Cloud Storage bucket 名稱後綴（會加上 project_id 確保唯一）"
  type        = string
  default     = "attachments"
}
