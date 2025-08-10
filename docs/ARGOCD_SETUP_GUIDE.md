# ArgoCD Application Setup Guide

## 🚀 Step-by-Step ArgoCD Application Creation

### Prerequisites
- ✅ ArgoCD is running and accessible
- ✅ You have the admin password
- ✅ Your GitHub repository is accessible

---

## 📱 **Step 1: Access ArgoCD UI**

```bash
# On your EC2 instance, port forward ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access in your browser: https://localhost:8080
# Username: admin
# Password: (from setup script output)
```

---

## 🆕 **Step 2: Create New Application**

### 2.1 Click "New App" Button
- Look for the **"New App"** button in the top-right corner
- It's usually a blue button with a plus icon (+)

### 2.2 Fill General Information
```
┌─────────────────────────────────────┐
│ General                             │
├─────────────────────────────────────┤
│ Application Name: tms-application   │
│ Project: default                    │
│ Description: TMS Ticket Management  │
└─────────────────────────────────────┘
```

---

## 🔗 **Step 3: Configure Source**

### 3.1 Repository Details
```
┌─────────────────────────────────────┐
│ Source                              │
├─────────────────────────────────────┤
│ Repository URL:                     │
│ https://github.com/emlycool/       │
│ gitops-k8s.git                     │
│                                     │
│ Revision: HEAD                      │
│ Path: helm-chart                    │
└─────────────────────────────────────┘
```

**Important Notes:**
- **Repository URL**: Must be the exact GitHub URL
- **Revision**: Leave as `HEAD` for latest commit
- **Path**: Points to your Helm chart directory

---

## 🎯 **Step 4: Configure Destination**

### 4.1 Cluster and Namespace
```
┌─────────────────────────────────────┐
│ Destination                         │
├─────────────────────────────────────┤
│ Cluster URL:                        │
│ https://kubernetes.default.svc      │
│                                     │
│ Namespace: tms                      │
└─────────────────────────────────────┘
```

**Important Notes:**
- **Cluster URL**: This is your k3s cluster
- **Namespace**: Will be created automatically if it doesn't exist

---

## ⚙️ **Step 5: Advanced Settings (Optional)**

### 5.1 Directory and Helm Options
```
┌─────────────────────────────────────┐
│ Advanced Settings                   │
├─────────────────────────────────────┤
│ ☑ Directory Recurse                │
│ ☑ Helm Values (leave empty)        │
│ ☑ Plugin (leave empty)             │
└─────────────────────────────────────┘
```

---

## 🔄 **Step 6: Sync Policy**

### 6.1 Automation Settings
```
┌─────────────────────────────────────┐
│ Sync Policy                         │
├─────────────────────────────────────┤
│ ☑ Enable Auto-Sync                 │
│ ☑ Self Heal                        │
│ ☑ Prune Resources                   │
│                                     │
│ Sync Options:                       │
│ ☑ Create Namespace                  │
│ ☑ Prune Propagation Policy          │
└─────────────────────────────────────┘
```

**What These Do:**
- **Auto-Sync**: Automatically deploys changes
- **Self Heal**: Fixes drift automatically
- **Prune**: Removes old resources
- **Create Namespace**: Creates namespace if missing

---

## ✅ **Step 7: Create Application**

### 7.1 Final Review
- Double-check all settings
- Ensure repository URL is correct
- Verify namespace is `tms`

### 7.2 Click Create
- Click the **"Create"** button
- Wait for the application to be created

---

## 📊 **Step 8: Monitor Application**

### 8.1 Check Status
After creation, you'll see:
- **Application Status**: Syncing, Healthy, or Error
- **Sync Status**: Out of Sync, Synced, or Error
- **Health Status**: Healthy, Degraded, or Missing

### 8.2 Common Statuses
```
🟢 Healthy + Synced = Application running correctly
🟡 Out of Sync = Changes detected, syncing in progress
🔴 Error = Something went wrong, check logs
```

---

## 🚨 **Troubleshooting Common Issues**

### Issue 1: Repository Not Found
```
Error: repository not found
```
**Solution:**
```bash
# Check if repository is accessible
argocd repo list

# Add repository manually
argocd repo add https://github.com/emlycool/gitops-k8s.git \
  --username YOUR_GITHUB_USERNAME \
  --password YOUR_GITHUB_TOKEN
```

### Issue 2: Namespace Creation Failed
```
Error: namespaces "tms" not found
```
**Solution:**
```bash
# Create namespace manually
kubectl create namespace tms

# Or check if ArgoCD has permissions
kubectl get clusterrolebinding | grep argocd
```

### Issue 3: Helm Chart Not Found
```
Error: path 'helm-chart' not found
```
**Solution:**
- Verify the path in your repository
- Check if the directory exists
- Ensure it contains valid Helm chart files

### Issue 4: Permission Denied
```
Error: permission denied
```
**Solution:**
```bash
# Check ArgoCD service account permissions
kubectl get clusterrolebinding | grep argocd-application-controller

# Verify namespace permissions
kubectl auth can-i create deployments --namespace tms
```

---

## 🔍 **Verification Commands**

### Check Application Status
```bash
# Via kubectl
kubectl get applications -n argocd
kubectl describe application tms-application -n argocd

# Via ArgoCD CLI
argocd app get tms-application
argocd app list
```

### Check Deployed Resources
```bash
# Check all resources in tms namespace
kubectl get all -n tms

# Check specific resources
kubectl get pods -n tms
kubectl get services -n tms
kubectl get deployments -n tms
```

### Check Logs
```bash
# ArgoCD application controller logs
kubectl logs -f deployment/argocd-application-controller -n argocd

# ArgoCD server logs
kubectl logs -f deployment/argocd-server -n argocd
```

---

## 🎉 **Success Indicators**

When everything is working correctly, you should see:

1. **Application Status**: `Healthy`
2. **Sync Status**: `Synced`
3. **Resources**: All resources deployed successfully
4. **Pods**: All pods in `Running` state
5. **Services**: Services accessible and endpoints ready

---

## 📞 **Need Help?**

If you encounter issues:

1. **Check ArgoCD logs** for detailed error messages
2. **Verify repository access** and permissions
3. **Check namespace existence** and permissions
4. **Review Helm chart structure** and values
5. **Consult the main DEPLOYMENT.md** for additional troubleshooting

---

## 🚀 **Next Steps After Success**

Once your application is deployed:

1. **Test the application** by accessing it
2. **Monitor logs** for any runtime issues
3. **Make a code change** to test GitOps pipeline
4. **Watch ArgoCD** automatically sync changes
5. **Scale your application** if needed 