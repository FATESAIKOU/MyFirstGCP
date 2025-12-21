#!/usr/bin/env bash

gcloud compute instances delete "$VM_NAME_SSHOPEN" --quiet
gcloud compute instances delete "$VM_NAME_SSHIAP" --quiet
gcloud compute instances delete "$VM_NAME_SSHCLOSED" --quiet
gcloud compute instances delete "$VM_NAME_SSHIAP_PRIVATE" --quiet
gcloud compute routers nats delete "$NAT_NAME" --router="$ROUTER_NAME" --quiet
gcloud compute routers delete "$ROUTER_NAME" --quiet
gcloud sql instances delete "$SQL_INSTANCE_NAME" --quiet

# gcloud storage buckets delete "gs://${BUCKET_NAME}" --quiet
# gcloud compute firewall-rules delete "$SSH_FIREWALL_RULE_NAME" --quiet
# gcloud compute firewall-rules delete "$SSHIAP_FIREWALL_RULE_NAME" --quiet
# gcloud compute firewall-rules delete "$SERVICE_FIREWALL_RULE_NAME" --quiet
# gcloud compute networks subnets delete "$SUBNET_NAME" --region="$REGION" --quiet
# gcloud compute networks subnets delete "$SUBNET_NAME_PRIVATEIPGOOGLEACCESS" --region="$REGION" --quiet
# gcloud compute networks delete "$VPC_NAME" --quiet
# gcloud secrets delete dbuser --quiet
# gcloud secrets delete dbpass --quiet
