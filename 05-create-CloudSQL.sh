#!/usr/bin/env bash

############################################################################
# Add Secret Manager Access Role to Compute Engine Default Service Account #
############################################################################

## Add secret access to service account
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="get(projectNumber)")

## Create your own service account and use it instead of the default compute service account
# gcloud iam service-accounts create web-sa

## You have to use email or uniqueId to identify the service account
# gcloud iam service-accounts desribe/delete web-sa@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding "$PROJECT_NUMBER" \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"

## Check iam policy bindings after adding
# gcloud projects get-iam-policy "$PROJECT_ID"

##################################################################
# Create Cloud SQL Instance without Public IP and connect to VPC #
##################################################################

gcloud sql instances create "$SQL_INSTANCE_NAME" \
    --database-version="$DB_VERSION" \
    --tier="$DB_TIER" \
    --network="$VPC_NAME" \
    --region="$REGION" \
    --no-assign-ip
## Hint: Somehow, it doesn't use defaule region set in gcloud config. So specify region explicitly.

## Hint: not need to enable firewall rule for Cloud SQL, because CloudSQL is not in subnet, it's a managed service.

