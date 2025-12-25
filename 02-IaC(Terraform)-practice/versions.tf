terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Backend 設定 - 目前使用 Local
  # 未來可改為 GCS:
  # backend "gcs" {
  #   bucket = "your-terraform-state-bucket"
  #   prefix = "todo-app/state"
  # }
}
