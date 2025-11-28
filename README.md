# HNG13 DevOps Stage6 Task - Containerized Microservices with Infrastructure Automation

This repository contains a fully containerized microservices TODO application with complete infrastructure automation, CI/CD pipelines, and security features.

## 🏗️ Architecture Overview

The application consists of 5 microservices with Traefik reverse proxy and SSL termination:

1. **[Frontend](/frontend)** - Vue.js UI application
2. **[Auth API](/auth-api)** - Go-based authentication service (JWT tokens)
3. **[TODOs API](/todos-api)** - Node.js CRUD API with Redis logging
4. **[Users API](/users-api)** - Java Spring Boot user profiles service
5. **[Log Message Processor](/log-message-processor)** - Python Redis queue processor
6. **Redis Queue** - Message broker for logging
7. **Traefik** - Reverse proxy with automatic HTTPS

![microservice-app-example](https://user-images.githubusercontent.com/1905821/34918427-a931d84e-f952-11e7-85a0-ace34a2e8edb.png)

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured
- Terraform >= 1.5.0
- Docker & Docker Compose
- Domain name (get free subdomain from [freedns.afraid.org](https://freedns.afraid.org))

### Single Command Deployment

1. **Configure your domain and credentials:**
   ```bash
   cd infra/terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your AWS credentials, domain, and SSH key
   ```

2. **Deploy everything:**
   ```bash
   ./deploy.sh
   ```

This single script will:
- ✅ Build Java application
- ✅ Provision AWS infrastructure
- ✅ Configure security groups
- ✅ Install Docker and dependencies
- ✅ Deploy application with SSL
- ✅ Configure Traefik reverse proxy

### Local Development

```bash
# Build and start all services locally
./build.sh

# Or manually:
docker-compose up -d --build
```

## 🌐 Application Endpoints

Once deployed, access your application at:

- **Frontend:** `https://your-domain.com`
- **Auth API:** `https://your-domain.com/api/auth` (returns "Not Found")
- **Todos API:** `https://your-domain.com/api/todos` (returns "Invalid Token")
- **Users API:** `https://your-domain.com/api/users` (returns "Missing Authorization header")

## 🔐 Login Credentials

| Username | Password |
|----------|----------|
| admin    | Admin123 |
| hng      | HngTech  |
| user     | Password |

## 🏗️ Infrastructure Features

### Terraform (Idempotent Infrastructure)
- ✅ AWS EC2 provisioning
- ✅ Security group configuration
- ✅ Remote state management
- ✅ Dynamic Ansible inventory generation
- ✅ Automatic Ansible execution

### Ansible (Configuration Management)
- ✅ Docker installation
- ✅ Application deployment
- ✅ SSL certificate management
- ✅ Idempotent operations

### CI/CD Pipeline
- ✅ **Drift Detection** with email alerts
- ✅ **Manual Approval** for infrastructure changes
- ✅ **Automatic Deployment** when no drift
- ✅ Separate workflows for infra and app changes

### Security & SSL
- ✅ **Automatic HTTPS** via Let's Encrypt
- ✅ **HTTP → HTTPS** redirection
- ✅ **Traefik** reverse proxy
- ✅ **Security groups** with minimal required ports

## 📁 Project Structure

```
.
├── frontend/              # Vue.js application
├── auth-api/              # Go authentication service
├── todos-api/             # Node.js CRUD API
├── users-api/             # Java Spring Boot service
├── log-message-processor/ # Python queue processor
├── infra/                 # Infrastructure automation
│   ├── terraform/         # AWS infrastructure
│   ├── ansible/           # Server configuration
│   └── README.md          # Detailed infra docs
├── .github/workflows/     # CI/CD pipelines
├── docker-compose.yml     # Multi-service container setup
├── deploy.sh              # Single-command deployment
└── build.sh               # Local development script
```

## 🔄 CI/CD Workflows

### Infrastructure Workflow
Triggers on changes to `infra/terraform/**` or `infra/ansible/**`:
1. **Terraform Plan** - Detect infrastructure drift
2. **Email Alert** - Notify on drift detection
3. **Manual Approval** - Required for infrastructure changes
4. **Terraform Apply** - Deploy approved changes

### Application Workflow
Triggers on changes to service code or docker-compose.yml:
1. **Build Services** - Containerize applications
2. **Deploy** - Update running services
3. **Health Check** - Verify deployment success

## 🛠️ Development

### Local Testing
```bash
# Start services locally
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Infrastructure Testing
```bash
cd infra/terraform
terraform plan  # Preview changes
terraform apply # Apply changes
```

## 📧 Drift Detection

The system automatically:
1. **Detects** infrastructure drift on every change
2. **Emails** notifications when drift is found
3. **Pauses** for manual approval
4. **Proceeds** automatically if no drift exists

## 🔧 Troubleshooting

### Common Issues
1. **Domain not accessible:** Check DNS points to server IP
2. **SSL certificate issues:** Verify domain ownership and email
3. **Services not starting:** Check `docker-compose logs`
4. **Terraform errors:** Run `terraform refresh` and retry

### Health Checks
```bash
# Check service status
docker-compose ps

# View application logs
docker-compose logs frontend
docker-compose logs auth-api

# Test connectivity
curl -k https://your-domain.com
```

## 📋 Submission Checklist

- ✅ Repository forked and infra/ directory created
- ✅ All services containerized with Dockerfiles
- ✅ Docker Compose with Traefik and SSL
- ✅ Terraform infrastructure automation
- ✅ Ansible configuration management
- ✅ CI/CD pipelines with drift detection
- ✅ Single command deployment: `terraform apply -auto-approve`
- ✅ HTTPS domain with automatic certificates
- ✅ Email notifications for infrastructure drift

## 📄 License

MIT
