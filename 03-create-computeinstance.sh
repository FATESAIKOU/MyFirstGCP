#!/usr/bin/env bash

gcloud compute instances create "$VM_NAME_SSHOPEN" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --tags="$SSH_FIREWALL_RULE_NAME,$SERVICE_FIREWALL_RULE_NAME" \
  --boot-disk-size="20GB"

gcloud compute instances create "$VM_NAME_SSHIAP" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --tags="$SSHIAP_FIREWALL_RULE_NAME,$SERVICE_FIREWALL_RULE_NAME" \
  --boot-disk-size="20GB"

gcloud compute instances create "$VM_NAME_SSHCLOSED" \
  --machine-type="$MACHINE_TYPE" \
  --subnet="$SUBNET_NAME" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --tags="$SERVICE_FIREWALL_RULE_NAME" \
  --boot-disk-size="20GB"


# gcloud compute instances list

# ⭕️ gcloud compute ssh "$VM_NAME_SSHOPEN"
# ⭕️ gcloud compute ssh "$VM_NAME_SSHOPEN" --tunnel-through-iap
# ❌ gcloud compute ssh "$VM_NAME_SSHIAP"
# ⭕️ gcloud compute ssh "$VM_NAME_SSHIAP" --tunnel-through-iap
# ❌ gcloud compute ssh "$VM_NAME_SSHCLOSED"
# ❌ gcloud compute ssh "$VM_NAME_SSHCLOSED" --tunnel-through-iap
# (show ssh command) gcloud compute ssh "$VM_NAME" --dry-run
