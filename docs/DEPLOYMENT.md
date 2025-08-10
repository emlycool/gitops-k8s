# GitOps Deployment Guide for TMS Application

This guide will walk you through deploying your TMS (Ticket Management System) application using GitOps principles with GitHub Actions, ArgoCD, and k3s on EC2.

## Prerequisites

- EC2 instance with Ubuntu 20.04+ (t3.medium or larger recommended)
- GitHub repository with your TMS application code
- Docker Hub account
- Basic knowledge of Kubernetes and Git

## Step 1: Setup EC2 Instance

### 1.1 Launch EC2 Instance
- Launch an Ubuntu 20.04+ instance
- Security Group: Allow SSH (22), HTTP (80), HTTPS (443), and custom port 8080 for ArgoCD
- Instance type: t3.medium or larger
- Storage: At least 20GB

### 1.2 Connect to EC2
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### 1.3 Run Setup Script
```bash
# Make script executable
chmod +x setup-ec2-k3s.sh

# Run as root
sudo ./setup-ec2-k3s.sh
```

## Step 2: Configure GitHub Repository

### 2.1 Add Docker Hub Secrets
Go to your GitHub repository → Settings → Secrets and variables → Actions, and add:
- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub access token

### 2.2 Update Repository URLs
In the following files, replace `YOUR_USERNAME` and `YOUR_REPO_NAME`:
- `argocd-app.yaml`
- `helm-chart/values.yaml` (image repository)

### 2.3 Push Code to GitHub
```bash
git add .
git commit -m "Initial GitOps setup"
git push origin main
```

## Step 3: Deploy ArgoCD Application

### 3.1 Access ArgoCD UI
```bash
# Port forward ArgoCD server
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access at https://localhost:8080
# Username: admin
# Password: (from setup script output)
```

### 3.2 Create Application

#### Option 1: Using ArgoCD UI (Recommended for beginners)

1. **Click "New App"** button in the top-right corner

2. **Fill in the General section:**
   - **Application Name**: `tms-application`
   - **Project**: `default`
   - **Description**: `TMS Ticket Management System`

3. **Fill in the Source section:**
   - **Repository URL**: `https://github.com/emlycool/gitops-k8s.git`
   - **Revision**: `HEAD` (or leave blank for latest)
   - **Path**: `helm-chart`

4. **Fill in the Destination section:**
   - **Cluster URL**: `https://kubernetes.default.svc`
   - **Namespace**: `tms`

5. **Advanced Settings (optional but recommended):**
   - **Directory Recurse**: Check this if you have nested Helm charts
   - **Helm Values**: Leave empty (uses values.yaml from chart)

6. **Sync Policy section:**
   - **Enable Auto-Sync**: Check this box
   - **Self Heal**: Check this box
   - **Prune Resources**: Check this box

7. **Click "Create"** button

#### Option 2: Using ArgoCD CLI

```bash
# Install ArgoCD CLI if not already installed
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

# Login to ArgoCD
argocd login localhost:8080 --username admin --password YOUR_PASSWORD

# Create the application
argocd app create tms-application \
  --repo https://github.com/emlycool/gitops-k8s.git \
  --path helm-chart \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace tms \
  --sync-policy automated \
  --self-heal \
  --prune

# Check application status
argocd app get tms-application
```

#### Option 3: Using kubectl (YAML manifest)

```bash
# Apply the pre-configured manifest
kubectl apply -f argocd-app.yaml

# Check application status
kubectl get applications -n argocd
kubectl describe application tms-application -n argocd
```

## Step 4: Monitor Deployment

### 4.1 Check Application Status
```bash
# Check ArgoCD application status
kubectl get applications -n argocd

# Check pods in tms namespace
kubectl get pods -n tms

# Check services
kubectl get svc -n tms
```

### 4.2 Access Application
```bash
# Port forward to TMS application
kubectl port-forward svc/tms-helm-chart -n tms 8000:8000

# Access at http://localhost:8000
```

## Step 5: Verify Deployment

### 5.1 Check Resources
```bash
# List all resources in tms namespace
kubectl get all -n tms

# Check persistent volumes
kubectl get pv,pvc -n tms

# Check logs
kubectl logs -f deployment/tms-helm-chart -n tms
```

### 5.2 Test Application
- Access the admin interface at `/admin/`
- Create a test user
- Test ticket creation functionality

## Step 6: Continuous Deployment

### 6.1 Make Code Changes
1. Make changes to your Django application
2. Commit and push to GitHub
3. GitHub Actions will automatically:
   - Build new Docker image
   - Push to Docker Hub
   - Update Helm chart version
   - Commit changes back to repository

### 6.2 ArgoCD Auto-Sync
- ArgoCD will detect changes in the repository
- Automatically deploy the new version
- Monitor the deployment in ArgoCD UI

## Troubleshooting

### Common Issues

#### 1. Pods in CrashLoopBackOff
```bash
# Check pod logs
kubectl logs -f pod/pod-name -n tms

# Check pod description
kubectl describe pod pod-name -n tms
```

#### 2. Database Connection Issues
```bash
# Check MySQL pod status
kubectl get pods -n tms | grep mysql

# Check MySQL logs
kubectl logs -f deployment/tms-helm-chart-mysql -n tms
```

#### 3. ArgoCD Sync Issues
```bash
# Check ArgoCD application status
kubectl describe application tms-application -n argocd

# Check ArgoCD server logs
kubectl logs -f deployment/argocd-server -n argocd

# Check if repository is accessible
argocd repo list
argocd repo add https://github.com/emlycool/gitops-k8s.git --username YOUR_GITHUB_USERNAME --password YOUR_GITHUB_TOKEN
```

#### 4. ArgoCD Application Creation Issues
```bash
# Check if namespace exists
kubectl get namespace tms

# Create namespace if it doesn't exist
kubectl create namespace tms

# Check ArgoCD project configuration
kubectl get projects -n argocd

# Verify cluster access
kubectl cluster-info
```

### Useful Commands

```bash
# Get kubeconfig
sudo cat /etc/rancher/k3s/k3s.yaml

# Check k3s status
sudo systemctl status k3s

# Restart k3s
sudo systemctl restart k3s

# Check ArgoCD password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Security Considerations

1. **Change Default Passwords**: Update MySQL and Django secret keys
2. **Network Policies**: Implement network policies to restrict pod communication
3. **RBAC**: Configure proper role-based access control
4. **Secrets Management**: Use Kubernetes secrets for sensitive data
5. **TLS**: Enable HTTPS for production deployments

## Scaling

### Horizontal Pod Autoscaling
```bash
# Enable HPA in values.yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

### Database Scaling
- Consider using managed MySQL service (RDS) for production
- Implement read replicas for better performance
- Use connection pooling

## Monitoring and Logging

### 1. Install Prometheus and Grafana
```bash
# Add Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

### 2. Application Logs
```bash
# View application logs
kubectl logs -f deployment/tms-helm-chart -n tms

# View MySQL logs
kubectl logs -f deployment/tms-helm-chart-mysql -n tms
```

## Backup and Recovery

### 1. Database Backup
```bash
# Create backup job
kubectl create job --from=cronjob/backup-mysql backup-mysql-manual -n tms
```

### 2. Application Backup
- Use ArgoCD to backup application manifests
- Backup persistent volumes
- Document configuration changes

## Next Steps

1. **Production Hardening**: Implement proper security measures
2. **Monitoring**: Set up comprehensive monitoring and alerting
3. **Backup Strategy**: Implement automated backup and recovery
4. **CI/CD Enhancement**: Add testing and quality gates
5. **Multi-Environment**: Set up staging and production environments

## Support

For issues and questions:
1. Check ArgoCD application logs
2. Review Kubernetes events
3. Check GitHub Actions workflow logs
4. Review this documentation
5. Check ArgoCD and k3s documentation 