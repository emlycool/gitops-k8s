# TMS - Ticket Management System

A modern ticket management system built with Django and deployed using GitOps principles.

## 🏗️ Project Structure

```
TMS/
├── 📁 app/                    # Application source code
│   ├── tms/                  # Django project settings
│   ├── tickets/              # Tickets application
│   ├── templates/            # HTML templates
│   ├── static/               # Static files (CSS, JS, images)
│   ├── media/                # User uploaded files
│   ├── manage.py             # Django management script
│   ├── requirements.txt      # Python dependencies
│   ├── Dockerfile            # Production Docker image
│   ├── DockerfileDev         # Development Docker image
│   └── env.example           # Environment variables template
│
├── 📁 infrastructure/         # Infrastructure and deployment
│   ├── helm-chart/           # Kubernetes Helm charts
│   ├── argocd-app.yaml       # ArgoCD application manifest
│   ├── setup-ec2-k3s.sh      # EC2 setup script
│   └── quick-start.sh        # Quick deployment script
│
├── 📁 docs/                   # Documentation
│   ├── README.md             # Application documentation
│   ├── DEPLOYMENT.md         # Deployment guide
│   ├── ARGOCD_SETUP_GUIDE.md # ArgoCD setup guide
│   ├── ARGOCD_QUICK_REFERENCE.md # Quick reference
│   └── MODELS.md             # Data models documentation
│
├── 📁 scripts/                # Utility scripts
│   ├── create_superuser.py   # Create admin user
│   ├── create_roles.py       # Setup user roles
│   ├── add_user_role.py      # Add roles to users
│   ├── add_faq_categories.py # Setup FAQ categories
│   ├── check_faq_data.py     # Verify FAQ data
│   ├── fix_action_table.py   # Database fixes
│   ├── fix_actions.py        # Action fixes
│   ├── fix_database.py       # Database fixes
│   └── create_sample_data.py # Create sample data
│
├── 📁 .github/                # GitHub Actions workflows
│   └── workflows/             # CI/CD pipelines
├── Makefile                   # Build and deployment commands
└── .gitignore                # Git ignore patterns
```

## 🚀 Quick Start

### 1. Development Setup
```bash
cd app
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### 2. Production Deployment
```bash
# Setup EC2 with k3s
cd infrastructure
chmod +x setup-ec2-k3s.sh
sudo ./setup-ec2-k3s.sh

# Deploy application
chmod +x quick-start.sh
./quick-start.sh
```

## 📚 Documentation

- **[Application Guide](docs/README.md)** - How to use the TMS application
- **[Deployment Guide](docs/DEPLOYMENT.md)** - Complete deployment instructions
- **[ArgoCD Setup](docs/ARGOCD_SETUP_GUIDE.md)** - ArgoCD application setup
- **[Quick Reference](docs/ARGOCD_QUICK_REFERENCE.md)** - ArgoCD commands reference
- **[Data Models](docs/MODELS.md)** - Database schema and models

## 🏗️ Architecture

### Application Layer
- **Django 4.2.7** - Web framework
- **MySQL** - Database backend
- **Jazzmin** - Admin interface theme
- **Gunicorn** - WSGI server

### Infrastructure Layer
- **k3s** - Lightweight Kubernetes
- **ArgoCD** - GitOps continuous deployment
- **Helm** - Kubernetes package manager
- **Docker** - Containerization

### CI/CD Pipeline
- **GitHub Actions** - Continuous integration
- **Docker Hub** - Container registry
- **ArgoCD** - Continuous deployment

## 🔧 Development

### Prerequisites
- Python 3.13+
- MySQL 8.0+
- Docker
- Git

### Local Development
```bash
cd app
cp env.example .env
# Edit .env with your database settings
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### Testing
```bash
cd app
python manage.py test
```

## 🚀 Deployment

### Prerequisites
- EC2 instance with Ubuntu 20.04+
- GitHub repository with your code
- Docker Hub account

### Automated Deployment
1. Push code to GitHub (triggers CI/CD)
2. GitHub Actions builds and pushes Docker image
3. ArgoCD automatically deploys to k3s cluster
4. Application is available on your EC2 instance

## 📊 Monitoring

- **ArgoCD Dashboard** - Application deployment status
- **Kubernetes Dashboard** - Resource monitoring
- **Application Logs** - Runtime debugging

## 🔒 Security

- **Non-root containers** - Security best practices
- **Environment variables** - Configuration management
- **RBAC** - Role-based access control
- **Network policies** - Pod communication control

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
1. Check the documentation in the `docs/` folder
2. Review ArgoCD and application logs
3. Check GitHub Actions workflow logs
4. Consult the troubleshooting guides

## 🎯 Project Goals

- **GitOps First** - Infrastructure as code with Git
- **Automated Deployment** - Zero-downtime deployments
- **Scalable Architecture** - Kubernetes-native design
- **Developer Experience** - Simple development workflow
- **Production Ready** - Security and monitoring built-in 