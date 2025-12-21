#!/usr/bin/env bash

gcloud compute instances create "$VM_NAME_SSHOPEN" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --tags="$SSH_FIREWALL_RULE_NAME,$SERVICE_FIREWALL_RULE_NAME" \
  --scopes=cloud-platform \
  --boot-disk-size="20GB"

gcloud compute instances create "$VM_NAME_SSHIAP" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --tags="$SSHIAP_FIREWALL_RULE_NAME,$SERVICE_FIREWALL_RULE_NAME" \
  --scopes=cloud-platform \
  --boot-disk-size="20GB"

gcloud compute instances create "$VM_NAME_SSHCLOSED" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --tags="$SERVICE_FIREWALL_RULE_NAME" \
  --scopes=cloud-platform \
  --boot-disk-size="20GB"

# gcloud compute instances list
# ⭕️ gcloud compute ssh "$VM_NAME_SSHOPEN"
# ⭕️ gcloud compute ssh "$VM_NAME_SSHOPEN" --tunnel-through-iap
# ❌ gcloud compute ssh "$VM_NAME_SSHIAP"
# ⭕️ gcloud compute ssh "$VM_NAME_SSHIAP" --tunnel-through-iap
# ❌ gcloud compute ssh "$VM_NAME_SSHCLOSED"
# ❌ gcloud compute ssh "$VM_NAME_SSHCLOSED" --tunnel-through-iap
# (show ssh command) gcloud compute ssh "$VM_NAME" --dry-run

# Create a VM without external IP
gcloud compute instances create "$VM_NAME_SSHIAP_PRIVATE" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME_PRIVATEIPGOOGLEACCESS" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --no-address \
  --tags="$SSHIAP_FIREWALL_RULE_NAME,$SERVICE_FIREWALL_RULE_NAME" \
  --scopes=cloud-platform \
  --boot-disk-size="20GB"

# create router and nat for private VM to access internet
gcloud compute routers create "$ROUTER_NAME" --network="$VPC_NAME"
gcloud compute routers nats create "$NAT_NAME" --router="$ROUTER_NAME" --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges
