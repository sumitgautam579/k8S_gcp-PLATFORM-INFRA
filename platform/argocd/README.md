# Argo CD install

```bash
kubectl create namespace argocd || true
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Resource trim for small VM:

```bash
kubectl -n argocd set resources deploy argocd-application-controller \
  --requests=cpu=100m,memory=256Mi --limits=cpu=300m,memory=512Mi
kubectl -n argocd set resources deploy argocd-repo-server \
  --requests=cpu=100m,memory=128Mi --limits=cpu=300m,memory=256Mi
kubectl -n argocd set resources deploy argocd-server \
  --requests=cpu=50m,memory=128Mi --limits=cpu=200m,memory=256Mi
```
