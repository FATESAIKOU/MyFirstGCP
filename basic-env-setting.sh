#!/usr/bin/env bash

export PROJECT_ID="learn-gcp-ksf"
export REGION="asia-northeast1"
export VPC_NAME="learn-vpc"
export SUBNET_NAME="learn-subnet"
export SUBNET_RANGE="10.10.0.0/24"
export SUBNET_NAME_PRIVATEIPGOOGLEACCESS="learn-subnet-privateipgoogleaccess"
export SUBNET_RANGE_PRIVATEIPGOOGLEACCESS="10.10.1.0/24"
export GOOGLE_MANAGED_ADDRESS="10.11.0.0"
export GOOGLE_MANAGED_ADDRESS_MASK="24"

# Workaround
export GOOGLE_MANAGED_ADDRESS2="10.12.0.0"
export GOOGLE_MANAGED_ADDRESS_MASK2="16"


export SSH_FIREWALL_RULE_NAME="allow-ssh"
export SSHIAP_FIREWALL_RULE_NAME="allow-ssh-iap"
export SERVICE_FIREWALL_RULE_NAME="allow-service-port"

export VM_NAME_SSHOPEN="learn-vm-sshopen"
export VM_NAME_SSHIAP="learn-vm-sshiap"
export VM_NAME_SSHCLOSED="learn-vm-sshclosed"
export VM_NAME_SSHIAP_PRIVATE="learn-vm-sshiap-private"
export MACHINE_TYPE="e2-micro"
export IMAGE_FAMILY="ubuntu-2204-lts"
export IMAGE_PROJECT="ubuntu-os-cloud"

export ROUTER_NAME="learn-router"
export NAT_NAME="learn-nat"

export SQL_INSTANCE_NAME="learn-sql"
export DB_VERSION="MYSQL_8_0"
export DB_TIER="db-f1-micro"
