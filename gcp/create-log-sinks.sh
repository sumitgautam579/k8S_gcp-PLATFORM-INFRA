#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID=$(gcloud config get-value project)
LOG_BUCKET_NAME=${LOG_BUCKET_NAME:-${PROJECT_ID}-central-logs}

gcloud logging sinks create runtime-logs-to-gcs \
  storage.googleapis.com/${LOG_BUCKET_NAME} \
  --log-filter='resource.type=("gce_instance" OR "k8s_container") AND severity>=INFO' || true

gcloud logging sinks create audit-logs-to-gcs \
  storage.googleapis.com/${LOG_BUCKET_NAME} \
  --log-filter='logName:"cloudaudit.googleapis.com" OR log_id("syslog") OR log_id("auth")' || true

echo "Grant writer identities to bucket:"
echo "gcloud logging sinks describe runtime-logs-to-gcs --format='value(writerIdentity)'"
echo "gcloud logging sinks describe audit-logs-to-gcs --format='value(writerIdentity)'"
