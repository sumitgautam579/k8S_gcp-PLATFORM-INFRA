# kubernetes Platform Implementation Documentation

## Infra Document

**Project:** Kubernetes DevSecOps Platform on GCP\
**Prepared By:** Sumit_Gautam

**Platform Stack:** Kubernetes (K3s), ArgoCD, Argo Rollouts, Prometheus,
Grafana, Fluent Bit, Velero, Artifact Registry

------------------------------------------------------------------------

# 1. Executive Summary

This document describes the K8s platform implemented on Google
Cloud Platform.\
The infrastructure enables automated deployments, centralized logging,
monitoring, and backup management using modern GitOps principles.

The platform provides:

-   GitOps based application deployment
-   Automated CI/CD pipeline
-   Canary deployment capability
-   Centralized logging
-   Infrastructure monitoring
-   Disaster recovery through automated backups
-   Secure container image management

------------------------------------------------------------------------

# 2. High Level Architecture

``` mermaid
flowchart LR

Developer --> GitHub
GitHub --> CI_Pipeline
CI_Pipeline --> ArtifactRegistry
ArtifactRegistry --> ArgoCD
ArgoCD --> KubernetesCluster
KubernetesCluster --> Applications

Applications --> Logging
Applications --> Monitoring

Logging --> GCSBucket
Monitoring --> Grafana

Velero --> BackupBucket
```

------------------------------------------------------------------------

# 3. Infrastructure Components

## Kubernetes Cluster

A  Kubernetes cluster was deployed using on a Google
Compute Engine instance.

Responsibilities:

-   Container orchestration
-   Service discovery
-   Load balancing
-   Application lifecycle management

Verification command:

``` bash
kubectl get nodes
```

------------------------------------------------------------------------

# 4. GitOps Deployment Platform

## Argo CD

Argo CD is used to implement GitOps deployment.

Features:

-   Declarative deployment from Git
-   Automated sync
-   Self healing
-   Rollback capability

Installation:

``` bash
kubectl get pods -n argocd


Access UI:

``` bash
https://34.32.32.116:31574 | argocd |

kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Retrieve admin password:

``` bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

------------------------------------------------------------------------

# 5. Progressive Deployment

## Argo Rollouts

Argo Rollouts enables advanced deployment strategies such as:

-   Canary deployments
-   Blue/Green deployments
-   Automated rollback

Installation:

Verification:

``` bash
kubectl get pods -n argo-rollouts
```

------------------------------------------------------------------------

# 6. Centralized Logging

Logging is implemented using **Fluent Bit**.

Log pipeline:

``` mermaid
flowchart LR
Pods --> FluentBit
FluentBit --> GCSBucket
```

Features:

-   Centralized log aggregation
-   Persistent storage in Google Cloud Storage
-   Log retention policy

Validation command:

``` bash
kubectl get pods -n logging
```

------------------------------------------------------------------------

# 7. Monitoring Stack

Monitoring is implemented using:

-   Prometheus
-   Grafana

Architecture:

``` mermaid
flowchart LR
Kubernetes --> Prometheus
Prometheus --> Grafana
Grafana --> Dashboards
```

Features:

-   Cluster metrics monitoring
-   Application performance monitoring
-   Custom dashboards
-   Alerting capability

Validation:

``` bash
kubectl get pods -n monitoring

```


``` bash
 http://34.32.32.116:32000 | Grafana | 
```

------------------------------------------------------------------------

# 8. Backup and Disaster Recovery

Backups are implemented using **Velero**.

Velero provides:

-   Cluster state backup
-   Persistent volume backup
-   Disaster recovery

Architecture:

``` mermaid
flowchart LR
KubernetesCluster --> Velero
Velero --> GCSBackupBucket
```

Verify installation:

``` bash
kubectl get pods -n velero
```

------------------------------------------------------------------------

# 9. Container Image Management

Images are stored in **Google Artifact Registry**.

Repository:

    apps
    Region: europe-west10
    Format: Docker

Authenticate docker:

``` bash
gcloud auth configure-docker europe-west10-docker.pkg.dev
```

Build image:

``` bash
docker build -t europe-west10-docker.pkg.dev/<PROJECT_ID>/apps/sample-app:latest .
```

Push image:

``` bash
docker push europe-west10-docker.pkg.dev/<PROJECT_ID>/apps/sample-app:latest
```

------------------------------------------------------------------------

# 10. CI/CD Pipeline Flow

``` mermaid
flowchart LR

Developer --> GitPush
GitPush --> GitHubActions
GitHubActions --> SecurityScans
SecurityScans --> DockerBuild
DockerBuild --> ArtifactRegistry
ArtifactRegistry --> ArgoCDSync
ArgoCDSync --> KubernetesDeployment
```

Pipeline includes:

-   SonarQube static analysis
-   Trivy security scanning
-   Docker image build
-   Image push to Artifact Registry

------------------------------------------------------------------------

# 11. GitOps Application Deployment

Example ArgoCD Application manifest:

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sample-app-nonprod
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/<repo>/Pipeline.git
    targetRevision: main
    path: apps/sample-app/overlays/nonprod
  destination:
    server: https://kubernetes.default.svc
    namespace: nonprod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Deploy application:

``` bash
kubectl apply -f sample-app.yaml
```

Check deployment:

``` bash
kubectl get applications -n argocd
```

------------------------------------------------------------------------

# 12. Environment Separation

The infrastructure supports environment isolation.

  Environment   Namespace   Purpose
  ------------- ----------- -----------------------
  nonprod       nonprod     Development & testing
  prod          prod        Production workloads

Deployment structure:

    apps/sample-app
     ├── base
     └── overlays
          ├── nonprod
          └── prod

------------------------------------------------------------------------

# 13. Security Model

Security controls implemented:

-   Namespace isolation
-   Default deny network policies
-   Container image scanning
-   IAM controlled registry access
-   Git based deployment control
-   Secrets managed through Kubernetes

------------------------------------------------------------------------

# 14. Infrastructure Validation Commands

Cluster health:

``` bash
kubectl get nodes
```

Check system pods:

``` bash
kubectl get pods -A
```

Check applications:

``` bash
kubectl get pods -n nonprod
```

Check services:

``` bash
kubectl get svc -n nonprod
```

Check ingress:

``` bash
kubectl get ingress -n nonprod
```

Check rollout status:

``` bash
kubectl get rollout -n nonprod
```

------------------------------------------------------------------------

# 15. Troubleshooting

View pod logs:

``` bash
kubectl logs <pod-name> -n nonprod
```

Describe pod:

``` bash
kubectl describe pod <pod-name> -n nonprod
```

Check ArgoCD applications:

``` bash
kubectl get applications -n argocd
```

Restart rollout:

``` bash
kubectl rollout restart rollout sample-app -n nonprod
```

------------------------------------------------------------------------

# 16. Platform Benefits

This DevSecOps platform provides:

-   Automated deployments
-   Infrastructure visibility
-   Production safe rollout strategy
-   Centralized observability
-   Disaster recovery capability

------------------------------------------------------------------------

# 18. Conclusion

The implemented platform provides a production-ready Kubernetes
foundation on Google Cloud.\
It supports automated deployments, monitoring, logging, security
controls, and backup mechanisms.

This infrastructure enables development teams to deliver applications
reliably using GitOps principles.
