#!/usr/bin/env bash

gcloud compute networks create "$VPC_NAME" --subnet-mode=custom
gcloud compute networks list

gcloud compute networks subnets create "$SUBNET_NAME" --network="$VPC_NAME" --range "$SUBNET_RANGE" # --enable-private-ip-google-access
gcloud compute networks subnets list --network="$VPC_NAME"

# gcloud compute routes create ROUTE_NAME --network=VPC_NAME --destination-range=DESTINATION_RANGE --next-hop-address=NEXT_HOP_ADDRESS
# gcloud compute routes list