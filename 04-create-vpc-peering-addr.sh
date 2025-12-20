#!/usr/bin/env bash

##############################
# Create VPC Peering Address #
##############################

gcloud compute addresses create google-managed-services-$VPC_NAME \
    --global \
    --purpose=VPC_PEERING \
    --addresses=$GOOGLE_MANAGED_ADDRESS \
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

# Workaround
gcloud compute addresses create google-managed-services-$VPC_NAME-2 \
    --global \
    --purpose=VPC_PEERING \
    --addresses=$GOOGLE_MANAGED_ADDRESS2 \
    --prefix-length=$GOOGLE_MANAGED_ADDRESS_MASK2 \
    --network=$VPC_NAME

gcloude services vpc-peerings update \
    --service=servicenetworking.googleapis.com \
    --network=$VPC_NAME \
    --ranges="google-managed-services-$VPC_NAME,google-managed-services-$VPC_NAME-2"
