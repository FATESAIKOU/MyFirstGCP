#!/usr/bin/env bash

##############################
# Create VPC Peering Address #
##############################

gcloud compute addresses create google-managed-services-$VPC_NAME \
    --global \
    --purpose=VPC_PEERING \
    --address=$GOOGLE_MANAGED_ADDRESS \
    --prefix-length=$GOOGLE_MANAGED_ADDRESS_MASK \
    --network=$VPC_NAME

# gcloud compute addresses list
# gcloud compute addresses describe google-managed-services-$VPC_NAME --global

###########################################
# Connect CloudSQL & VPC with VPC Peering #
###########################################

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --network=$VPC_NAME \
    --ranges=google-managed-services-$VPC_NAME

# gcloud services vpc-peerings list --network=$VPC_NAME
# gcloud services vpc-peerings delete --network=$VPC_NAME --service=servicenetworking.googleapis.com
