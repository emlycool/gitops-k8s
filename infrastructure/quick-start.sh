#!/bin/bash

# Quick Start Script for TMS GitOps Deployment
# This script helps you get started quickly

set -e

echo "🚀 TMS GitOps Quick Start Script"
echo "=================================="

# Check if running on EC2
if [[ ! -f /sys/hypervisor/uuid ]] || [[ $(head -c 3 /sys/hypervisor/uuid) != "ec2" ]]; then
    echo "⚠️  This script is designed to run on EC2 instances"
    echo "   Please run this on your EC2 instance with k3s"
    exit 1
fi

# Check if k3s is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ k3s/kubectl not found. Please run setup-ec2-k3s.sh first"
    exit 1
fi

echo "✅ k3s detected"

# Get current namespace
NAMESPACE="tms"
echo "📁 Using namespace: $NAMESPACE"

# Create namespace if it doesn't exist
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "🔧 Setting up TMS application..."

# Check if ArgoCD is running
if ! kubectl get pods -n argocd | grep -q "argocd-server.*Running"; then
    echo "❌ ArgoCD is not running. Please ensure ArgoCD is installed and running"
    exit 1
fi

echo "✅ ArgoCD is running"

# Get ArgoCD admin password
echo "🔑 ArgoCD admin password:"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "$ARGOCD_PASSWORD"

# Check if application already exists
if kubectl get application tms-application -n argocd &> /dev/null; then
    echo "ℹ️  TMS application already exists in ArgoCD"
    echo "   You can access it at: https://localhost:8080"
    echo "   Username: admin"
    echo "   Password: $ARGOCD_PASSWORD"
else
    echo "📝 Creating TMS application in ArgoCD..."
    
    # Update argocd-app.yaml with current repository
    echo "   Please update argocd-app.yaml with your repository details"
    echo "   Then apply it with: kubectl apply -f argocd-app.yaml"
fi

echo ""
echo "🌐 To access ArgoCD UI:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "   Then visit: https://localhost:8080"
echo "   Username: admin"
echo "   Password: $ARGOCD_PASSWORD"

echo ""
echo "📊 To check application status:"
echo "   kubectl get applications -n argocd"
echo "   kubectl get pods -n $NAMESPACE"

echo ""
echo "🔍 To access TMS application:"
echo "   kubectl port-forward svc/tms-helm-chart -n $NAMESPACE 8000:8000"
echo "   Then visit: http://localhost:8000"

echo ""
echo "📚 For detailed instructions, see DEPLOYMENT.md"
echo "✅ Quick start setup complete!" 