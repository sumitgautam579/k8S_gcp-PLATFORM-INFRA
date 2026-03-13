#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID=$(gcloud config get-value project)
REGION=${REGION:-europe-west10}
LOG_BUCKET_NAME=${LOG_BUCKET_NAME:-${PROJECT_ID}-central-logs}

gcloud storage buckets create gs://${LOG_BUCKET_NAME} \
  --project=${PROJECT_ID} \
  --location=${REGION} \
  --uniform-bucket-level-access || true

gcloud storage buckets update gs://${LOG_BUCKET_NAME} \
  --lifecycle-file=gcp/gcs-lifecycle.json

echo "Created/updated gs://${LOG_BUCKET_NAME}"
