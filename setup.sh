#!/bin/sh

echo "Input your User OCID for OCI Container Registory operations:"
read $DEVOPS_USER_OCID
echo "Input your OKE Cluster OCID:"
read $OKE_CLUSTER_OCID
echo "Input your repo name for OCI Container Registry:"
read $REPO_NAME
echo "Input your Compartment OCID:"
read $COMPARTMENT_OCID

### OCI KUBECTL Wiring for Cloud Shell
oci ce cluster create-kubeconfig --cluster-id $OKE_CLUSTER_OCID --file $HOME/.kube/config --region us-ashburn-1 --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT

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

# Create demo services namespace
kubectl create namespace oci-demo

### PREPARE OCI Container Registry for Images REF: https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrycreatingarepository.htm
# Generate Auth Token
oci iam auth-token create --description "Auth Token for OCI container registry access to push images" --user-id $DEVOPS_USER_OCID

# Create container registry
oci artifacts container repository create --display-name $REPO_NAME --compartment-id $COMPARTMENT_OCID



