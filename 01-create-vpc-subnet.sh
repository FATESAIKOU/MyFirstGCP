#!/usr/bin/env bash

gcloud compute networks create "$VPC_NAME" --subnet-mode=custom
gcloud compute networks list

gcloud compute networks subnets create "$SUBNET_NAME" --network="$VPC_NAME" --range "$SUBNET_RANGE" # --region=asia-northeast1
gcloud compute networks subnets list --network="$VPC_NAME"