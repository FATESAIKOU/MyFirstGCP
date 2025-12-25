######################
# Compute Engine VM   #
######################

resource "google_compute_instance" "app_vm" {
  name         = local.vm_app_name
  machine_type = var.machine_type
  zone         = var.zone

  # 使用專用 Service Account
  service_account {
    email  = google_service_account.app_sa.email
    scopes = ["cloud-platform"] # 完整 scope，實際權限由 IAM 控制
  }

  # Boot Disk
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.boot_disk_size
      type  = "pd-balanced"
    }
  }

  # 網路設定
  network_interface {
    subnetwork = google_compute_subnetwork.app_subnet.id

    # 分配外部 IP（開發用）
    # 生產環境可以移除，透過 Load Balancer 暴露服務
    access_config {
      // Ephemeral public IP
    }
  }

  # 網路標籤（套用 Firewall 規則）
  tags = ["allow-ssh-iap", "allow-app-port"]

  # Metadata
  metadata = {
    # 啟用 OS Login（更安全的 SSH 存取方式）
    enable-oslogin = "TRUE"

    # Cloud SQL 連線資訊（供啟動腳本使用）
    db-connection-name = google_sql_database_instance.main.connection_name
    db-name            = google_sql_database.app_db.name
  }

  # 啟動腳本（安裝必要軟體）
  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    # 更新系統
    apt-get update
    apt-get upgrade -y

    # 安裝 Cloud SQL Auth Proxy
    curl -o /usr/local/bin/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.1/cloud-sql-proxy.linux.amd64
    chmod +x /usr/local/bin/cloud-sql-proxy

    # 取得連線資訊
    CONNECTION_NAME=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-connection-name" -H "Metadata-Flavor: Google")

    # 建立 systemd service
    cat > /etc/systemd/system/cloud-sql-proxy.service <<SYSTEMD
    [Unit]
    Description=Cloud SQL Auth Proxy
    After=network.target

    [Service]
    Type=simple
    User=root
    ExecStart=/usr/local/bin/cloud-sql-proxy --port 3306 $CONNECTION_NAME
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    SYSTEMD

    systemctl daemon-reload
    systemctl enable cloud-sql-proxy
    systemctl start cloud-sql-proxy

    echo "Startup script completed!" >> /var/log/startup-script.log
  EOF

  # 標籤
  labels = local.common_labels

  # 允許停止以更新
  allow_stopping_for_update = true

  # 依賴 Cloud SQL
  depends_on = [google_sql_database_instance.main]
}

######################
# 設計說明            #
######################

# 🤔 為什麼用 Cloud SQL Auth Proxy？
#
# 1. IAM 認證：不需要管理資料庫密碼
# 2. 加密連線：自動 TLS
# 3. 連線管理：自動處理 connection pooling
#
# 🤔 為什麼用 OS Login？
#
# 1. 集中管理：透過 IAM 控制 SSH 存取
# 2. 審計日誌：所有 SSH 連線都有記錄
# 3. 自動金鑰管理：不需要手動管理 SSH key
