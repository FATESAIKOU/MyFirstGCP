######################
# 讀取既有資源        #
######################

# 讀取既有的 VPC（已用 gcloud 建立）
data "google_compute_network" "existing_vpc" {
  name = var.existing_vpc_name
}

# 讀取專案資訊（取得 project number）
data "google_project" "current" {
  project_id = var.project_id
}
