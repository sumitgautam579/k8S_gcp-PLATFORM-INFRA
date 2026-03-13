# Centralized logging

## Goal

- Keep local VM logs short-lived
- Send searchable logs to Cloud Logging
- Archive selected logs to GCS for cheaper retention

## Steps

1. Run `./gcp/create-log-bucket.sh`
2. Run `./bootstrap/install-ops-agent.sh`
3. Run `./gcp/create-log-sinks.sh`
4. Grant sink writer identities `roles/storage.objectCreator` on the bucket
5. Apply `bootstrap/journald-hardening.sh`
6. Install `bootstrap/logrotate-k8s-containers.conf` into `/etc/logrotate.d/`
