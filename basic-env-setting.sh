#!/usr/bin/env bash

export VPC_NAME="learn-vpc"
export SUBNET_NAME="learn-subnet"
export SUBNET_RANGE="10.10.0.0/24"
export GOOGLE_MANAGED_ADDRESS="10.11.0.0"
export GOOGLE_MANAGED_ADDRESS_MASK="24"

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