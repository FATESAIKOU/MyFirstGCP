#!/usr/bin/env bash

gcloud compute firewall-rules create "learn-fw-allow-ssh" \
    --network "$VPC_NAME" \
    --direction 'INGRESS' \
    --action 'ALLOW' \
    --rules 'tcp:22' \
    --source-ranges '0.0.0.0/0' \
    --target-tags "$SSH_FIREWALL_RULE_NAME"

gcloud compute firewall-rules create "learn-fw-allow-sshiap" \
    --network "$VPC_NAME" \
    --direction 'INGRESS' \
    --action 'ALLOW' \
    --rules 'tcp:22' \
    --source-ranges '0.0.0.0/0' \
    --target-tags "$SSHIAP_FIREWALL_RULE_NAME"

gcloud compute firewall-rules create "learn-fw-allow-service-port" \
    --network "$VPC_NAME" \
    --direction 'INGRESS' \
    --action 'ALLOW' \
    --rules 'tcp:8080' \
    --source-ranges '0.0.0.0/0' \
    --target-tags "$SERVICE_FIREWALL_RULE_NAME"