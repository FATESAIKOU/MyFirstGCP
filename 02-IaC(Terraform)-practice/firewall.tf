######################
# Firewall Rules      #
######################

# 允許 SSH via IAP（安全的 SSH 存取方式）
resource "google_compute_firewall" "allow_ssh_iap" {
  name    = local.fw_ssh_iap_name
  network = data.google_compute_network.existing_vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # IAP 的 IP 範圍（固定值）
  # 參考: https://cloud.google.com/iap/docs/using-tcp-forwarding
  source_ranges = ["35.235.240.0/20"]

  # 只有帶此 tag 的 VM 才會套用此規則
  target_tags = ["allow-ssh-iap"]

  description = "Allow SSH access via Identity-Aware Proxy"
}

# 允許應用服務 Port（8080）
resource "google_compute_firewall" "allow_app_port" {
  name    = local.fw_app_port_name
  network = data.google_compute_network.existing_vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  # 允許所有來源（公開服務）
  # ⚠️ 生產環境應限制為 Load Balancer IP 或特定範圍
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-app-port"]

  description = "Allow HTTP traffic on port 8080 for application"
}

# 允許內部通訊（同 VPC 內的 VM 可互相連線）
resource "google_compute_firewall" "allow_internal" {
  name    = "${local.name_prefix}-fw-allow-internal"
  network = data.google_compute_network.existing_vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  # 同 VPC 內的所有 subnet CIDR
  source_ranges = [var.app_subnet_cidr, var.db_subnet_cidr]

  description = "Allow internal communication within VPC"
}
