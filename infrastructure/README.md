# Infrastructure & Deployment

This folder contains all the infrastructure and deployment configurations for the TMS application.

## 📁 Folder Structure

```
infrastructure/
├── 📁 helm-chart/           # Kubernetes Helm charts
│   ├── Chart.yaml           # Chart metadata
│   ├── values.yaml          # Default configuration values
│   └── templates/           # Kubernetes manifest templates
│       ├── deployment.yaml  # Main application deployment
│       ├── service.yaml     # Application service
│       ├── mysql-deployment.yaml  # MySQL database deployment
│       ├── mysql-service.yaml     # MySQL service
│       └── mysql-pvc.yaml         # MySQL persistent volume claim
├── argocd-app.yaml          # ArgoCD application manifest
├── setup-ec2-k3s.sh         # EC2 setup script for k3s and ArgoCD
├── quick-start.sh            # Quick deployment script
└── README.md                 # This file
```

## 🚀 Quick Start

### 1. Setup EC2 Instance
```bash
# Make script executable and run
chmod +x setup-ec2-k3s.sh
sudo ./setup-ec2-k3s.sh
```

### 2. Deploy Application
```bash
# Make script executable and run
chmod +x quick-start.sh
./quick-start.sh
```

### 3. Access ArgoCD
```bash
# Port forward to ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access: https://localhost:8080
# Username: admin
# Password: (from setup script output)
```

## 🏗️ Components

### Helm Chart
The `helm-chart/` directory contains a complete Helm chart for deploying:
- **TMS Application**: Django application with Gunicorn
- **MySQL Database**: In-cluster MySQL with persistent storage
- **Services**: Network services for application access
- **Health Checks**: Liveness and readiness probes

### ArgoCD Application
The `argocd-app.yaml` file defines how ArgoCD should deploy the application:
- **Source**: Git repository and Helm chart path
- **Destination**: Target cluster and namespace
- **Sync Policy**: Automated deployment with self-healing

### Setup Scripts
- **`setup-ec2-k3s.sh`**: Installs k3s, ArgoCD, and necessary tools
- **`quick-start.sh`**: Provides quick deployment instructions

## 🔧 Configuration

### Helm Values
Key configuration options in `helm-chart/values.yaml`:
- **Image**: Docker image repository and tag
- **Replicas**: Number of application instances
- **Resources**: CPU and memory limits
- **Database**: MySQL configuration and persistence
- **Environment**: Django environment variables

### ArgoCD Settings
Application configuration in `argocd-app.yaml`:
- **Repository**: GitHub repository URL
- **Path**: Helm chart location
- **Namespace**: Target deployment namespace
- **Sync Policy**: Automated deployment settings

## 📊 Monitoring

### Application Status
```bash
# Check ArgoCD application status
kubectl get applications -n argocd
argocd app get tms-application

# Check deployed resources
kubectl get all -n tms
```

### Logs
```bash
# Application logs
kubectl logs -f deployment/tms-helm-chart -n tms

# MySQL logs
kubectl logs -f deployment/tms-helm-chart-mysql -n tms

# ArgoCD logs
kubectl logs -f deployment/argocd-server -n argocd
```

## 🔒 Security

### Network Policies
- **ClusterIP Services**: Internal cluster communication only
- **Namespace Isolation**: Resources isolated in `tms` namespace
- **Service Accounts**: Minimal required permissions

### Container Security
- **Non-root Users**: Containers run as non-privileged users
- **Resource Limits**: CPU and memory constraints
- **Health Checks**: Application health monitoring

## 🚨 Troubleshooting

### Common Issues

#### 1. Application Not Starting
```bash
# Check pod status
kubectl get pods -n tms

# Check pod events
kubectl describe pod <pod-name> -n tms

# Check application logs
kubectl logs <pod-name> -n tms
```

#### 2. Database Connection Issues
```bash
# Check MySQL pod status
kubectl get pods -n tms | grep mysql

# Check MySQL logs
kubectl logs -f deployment/tms-helm-chart-mysql -n tms

# Test database connectivity
kubectl exec -it <mysql-pod> -n tms -- mysql -u tms_user -p
```

#### 3. ArgoCD Sync Issues
```bash
# Check application status
argocd app get tms-application

# Check sync events
argocd app get tms-application --events

# Manual sync
argocd app sync tms-application
```

### Debug Commands
```bash
# Check all resources in namespace
kubectl get all -n tms

# Check persistent volumes
kubectl get pvc -n tms

# Check services and endpoints
kubectl get svc,endpoints -n tms

# Check ArgoCD application controller
kubectl get pods -n argocd
```

## 📚 Additional Resources

- **[Main Deployment Guide](../docs/DEPLOYMENT.md)** - Complete deployment instructions
- **[ArgoCD Setup Guide](../docs/ARGOCD_SETUP_GUIDE.md)** - Detailed ArgoCD setup
- **[Quick Reference](../docs/ARGOCD_QUICK_REFERENCE.md)** - ArgoCD commands
- **[Helm Documentation](https://helm.sh/docs/)** - Helm chart development
- **[ArgoCD Documentation](https://argo-cd.readthedocs.io/)** - ArgoCD usage

## 🎯 Best Practices

### Deployment
- Use GitOps workflow for all changes
- Test Helm charts locally before deployment
- Monitor application health after deployment
- Use resource limits and requests

### Security
- Regularly update base images
- Monitor security advisories
- Use minimal required permissions
- Implement network policies

### Monitoring
- Set up alerts for failed deployments
- Monitor resource utilization
- Track application performance
- Regular backup of configurations 