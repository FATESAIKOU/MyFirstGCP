#!/usr/bin/env bash

###################################################
# Grant default compute sa to use cloud sql proxy #
###################################################

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="get(projectNumber)")

## Create your own service account and use it instead of the default compute service account
# gcloud iam service-accounts create web-sa

## You have to use email or uniqueId to identify the service account
# gcloud iam service-accounts desribe/delete web-sa@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding "$PROJECT_NUMBER" \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/cloudsql.client"

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

############################################################################
# Add Secret Manager Access Role to Compute Engine Default Service Account #
############################################################################

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="get(projectNumber)")

gcloud projects add-iam-policy-binding "$PROJECT_NUMBER" \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor"

################################
# Create DBUser and save to SM #
################################

DBUSER="dbuser"
DBPASS="LearnGCP1234!"

gcloud sql users create "$DBUSER" \
    --instance="$SQL_INSTANCE_NAME" \
    --password="$DBPASS"

# Save DB credentials to Secret Manager
echo -n "$USERNAME" | gcloud secrets create dbuser --data-file=-
echo -n "$PASSWORD" | gcloud secrets create dbpass --data-file=-
## To retrieve secret value:
# gcloud secrets versions access latest --secret="dbuser"
# gcloud secrets versions access latest --secret="dbpass"

################
## To test SQL #
################

## get instance connection name
# export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe learn-sql --format="value(connectionName)")

## Install cloud-sql-proxy
# sudo curl -L -o /usr/local/bin/cloud-sql-proxy \
#   https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.19.0/cloud-sql-proxy.linux.amd64
# sudo chmod +x /usr/local/bin/cloud-sql-proxy

## test & launch cloud sql proxy
# cloud-sql-proxy --version
# cloud-sql-proxy \
#   --private-ip \
#   --address 127.0.0.1 \
#   --port 3306 \
#   $INSTANCE_CONNECTION_NAME

## Do connect
# mysql -h 127.0.0.1 -P3306 -u$(gcloud secrets versions access latest --secret="dbuser") -p$(gcloud secrets versions access latest --secret="dbpass")