#!/bin/bash

# Setup script for EC2 instance with k3s and ArgoCD
# Run this script as root or with sudo

set -e

echo "🚀 Setting up k3s and ArgoCD on EC2..."

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install required packages
echo "📦 Installing required packages..."
apt install -y curl wget git vim

# Install k3s
echo "🐳 Installing k3s..."
curl -sfL https://get.k3s.io | sh -

# Wait for k3s to be ready
echo "⏳ Waiting for k3s to be ready..."
sleep 30

# Get kubeconfig
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
chmod 644 $KUBECONFIG

# Install ArgoCD
echo "🚀 Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Get ArgoCD admin password
echo "🔑 ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Port forward ArgoCD server (optional, for local access)
echo "🌐 To access ArgoCD UI, run:"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"

# Install ArgoCD CLI
echo "📥 Installing ArgoCD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Access ArgoCD UI at https://localhost:8080 (after port-forward)"
echo "2. Login with admin and the password shown above"
echo "3. Create your ArgoCD application using the argocd-app.yaml file"
echo "4. Push your code to GitHub to trigger the deployment" 