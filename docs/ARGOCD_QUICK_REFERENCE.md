# ArgoCD Quick Reference Card

## 🚀 **Essential Commands**

### Access ArgoCD
```bash
# Port forward to ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access: https://localhost:8080
# Username: admin
# Password: (from setup script)
```

### ArgoCD CLI Login
```bash
# Install CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

# Login
argocd login localhost:8080 --username admin --password YOUR_PASSWORD
```

---

## 📱 **UI Navigation**

### Main Dashboard
- **Applications**: View all deployed applications
- **Repositories**: Manage Git repositories
- **Projects**: Organize applications
- **Settings**: Configure ArgoCD

### Application View
- **Overview**: Application status and health
- **App Details**: Detailed resource information
- **Manifest**: View generated Kubernetes manifests
- **Events**: Application events and logs

---

## 🔧 **Application Management**

### Create Application (UI)
1. Click **"New App"** button
2. **General**: Name, Project, Description
3. **Source**: Repository URL, Path, Revision
4. **Destination**: Cluster, Namespace
5. **Sync Policy**: Auto-sync, Self-heal, Prune
6. Click **"Create"**

### Create Application (CLI)
```bash
argocd app create tms-application \
  --repo https://github.com/emlycool/gitops-k8s.git \
  --path helm-chart \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace tms \
  --sync-policy automated \
  --self-heal \
  --prune
```

### Sync Application
```bash
# Manual sync
argocd app sync tms-application

# Force sync (overwrite local changes)
argocd app sync tms-application --force

# Sync specific resources
argocd app sync tms-application --resource Deployment:tms-helm-chart
```

---

## 📊 **Monitoring & Status**

### Check Application Status
```bash
# List all applications
argocd app list

# Get specific application
argocd app get tms-application

# Check sync status
argocd app sync-status tms-application
```

### Common Statuses
- **🟢 Healthy + Synced**: Application running correctly
- **🟡 Out of Sync**: Changes detected, syncing needed
- **🔴 Error**: Something went wrong, check logs
- **⚪ Missing**: Application not found or deleted

### View Logs
```bash
# Application logs
argocd app logs tms-application

# Follow logs
argocd app logs tms-application --follow

# Resource-specific logs
argocd app logs tms-application --resource Deployment:tms-helm-chart
```

---

## 🗂️ **Repository Management**

### List Repositories
```bash
argocd repo list
```

### Add Repository
```bash
# Public repository
argocd repo add https://github.com/emlycool/gitops-k8s.git

# Private repository with credentials
argocd repo add https://github.com/emlycool/gitops-k8s.git \
  --username YOUR_USERNAME \
  --password YOUR_TOKEN
```

### Remove Repository
```bash
argocd repo rm https://github.com/emlycool/gitops-k8s.git
```

---

## 🔍 **Troubleshooting**

### Common Issues & Solutions

#### 1. Repository Access Error
```bash
# Check repository status
argocd repo list

# Re-add repository
argocd repo add https://github.com/emlycool/gitops-k8s.git
```

#### 2. Sync Failed
```bash
# Check application events
argocd app get tms-application --events

# Check resource status
kubectl get all -n tms
```

#### 3. Permission Denied
```bash
# Check ArgoCD permissions
kubectl get clusterrolebinding | grep argocd

# Verify namespace access
kubectl auth can-i create deployments --namespace tms
```

### Debug Commands
```bash
# Application details with events
argocd app get tms-application --events

# Resource tree
argocd app resources tms-application

# Manifest diff
argocd app diff tms-application
```

---

## 📋 **Quick Checks**

### Before Creating Application
- [ ] Repository is accessible
- [ ] Helm chart path is correct
- [ ] Namespace exists or can be created
- [ ] Cluster permissions are correct

### After Application Creation
- [ ] Application status is "Healthy"
- [ ] Sync status is "Synced"
- [ ] All resources are deployed
- [ ] Pods are in "Running" state

### Regular Monitoring
- [ ] Check application health daily
- [ ] Monitor sync status
- [ ] Review application events
- [ ] Check resource utilization

---

## 🎯 **Best Practices**

### Application Configuration
- Use descriptive application names
- Enable auto-sync for development
- Use self-heal for production stability
- Implement proper resource limits

### Security
- Use service accounts with minimal permissions
- Implement RBAC for team access
- Regular security updates
- Monitor access logs

### Monitoring
- Set up alerts for failed syncs
- Monitor resource usage
- Track deployment history
- Regular backup of configurations

---

## 🆘 **Emergency Commands**

### Force Sync (Overwrite Local Changes)
```bash
argocd app sync tms-application --force
```

### Rollback to Previous Version
```bash
argocd app rollback tms-application
```

### Delete Application
```bash
argocd app delete tms-application
```

### Restart Application
```bash
kubectl rollout restart deployment/tms-helm-chart -n tms
```

---

## 📚 **Additional Resources**

- **Official Docs**: https://argo-cd.readthedocs.io/
- **GitHub**: https://github.com/argoproj/argo-cd
- **Community**: https://argoproj.github.io/community/
- **Slack**: #argo-cd on CNCF Slack 