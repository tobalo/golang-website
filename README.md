# Golang Webapp Demo for OCI

## Configure .env
Get a News API key here: https://newsapi.org/
```
PORT=
NEWS_API_KEY=
```

To Run
```bash
go run main.go
```

## Docker Build
```bash
docker build -t oci-golang-demo .
```

# ArgoCD on Oracle Kubernetes Engine (PUBLIC ENDPOINTS)

## Provision OKE Cluster
Provision your OKE Cluster via OCI Console, OCI CLI, Terraform, or Ansible

## Configure kubectl
Replace `<CLUSTER_OCID>` with your OKE OCID. If you provisioned through the UI, click Access Cluster for your command.
```bash
oci ce cluster create-kubeconfig --cluster-id <CLUSTER_OCID> --file $HOME/.kube/config --region us-ashburn-1 --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT
```

## Setup ArgoCD as Declarative GitOps tool
```bash
# Setup ArgoCD Namespace and Services
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Change ArgoCD Service type to LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Port Forward ArgoCD service API
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get ArgoCD Service Endpoint IP
kubectl get all -n argocd

# Get default password for ArgoCD Web UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```