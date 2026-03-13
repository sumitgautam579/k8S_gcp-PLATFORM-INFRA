# KubeBlocks PostgreSQL (single-instance for current hardware)

Install KubeBlocks first:

```bash
helm repo add kubeblocks https://apecloud.github.io/helm-charts
helm repo update
helm upgrade --install kubeblocks kubeblocks/kubeblocks \
  --namespace kb-system --create-namespace \
  --set addonChartLocationBase=https://apecloud.github.io/helm-charts \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=256Mi \
  --set resources.limits.cpu=300m \
  --set resources.limits.memory=512Mi
```

Then apply:

```bash
kubectl apply -f apps/postgres/cluster.yaml
kubectl get cluster pg-cluster -n data
kubectl get pods -n data -L kubeblocks.io/role
```
