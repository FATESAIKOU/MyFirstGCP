#!/usr/bin/env bash

gcloud storage buckets create "gs://${BUCKET_NAME}" \
    --location="${REGION}" \
    --uniform-bucket-level-access

## Granting Roles to the Service Account of Cloud Shell

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="get(projectNumber)")
gcloud projects add-iam-policy-binding "$PROJECT_NUMBER" \
    --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
    --role="roles/storage.objectAdmin"

## To upload
# gcloud storage cp <LOCAL_FILE_PATH> gs://"${BUCKET_NAME}"/<DESTINATION_PATH>
## To download
# gcloud storage cp gs://"${BUCKET_NAME}"/<SOURCE_PATH> <LOCAL_FILE_PATH>
## To list files
# gcloud storage ls gs://"${BUCKET_NAME}"/<SOURCE_PATH>
## To delete files
# gcloud storage rm gs://"${BUCKET_NAME}"/<SOURCE_PATH>
