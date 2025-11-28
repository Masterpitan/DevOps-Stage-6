# Deployment Guide

## Step-by-Step Deployment Instructions

### 1. Prerequisites Setup

1. **AWS Account Setup:**
   - Create AWS account
   - Create IAM user with EC2, VPC permissions
   - Generate access keys

2. **Domain Setup:**
   - Get free subdomain from [freedns.afraid.org](https://freedns.afraid.org)
   - Example: `yourapp.mooo.com`

3. **SSH Key Setup:**
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/microservices_key
   ```

### 2. Configuration

1. **Configure Terraform:**
   ```bash
   cd infra/terraform
   cp terraform.tfvars.example terraform.tfvars
   ```

   Edit `terraform.tfvars`:
   ```hcl
   aws_region    = "us-east-1"
   instance_type = "t3.medium"
   public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... your-public-key"
   domain        = "yourapp.mooo.com"
   acme_email    = "your-email@example.com"
   ```

2. **Update S3 Backend:**
   Edit `infra/terraform/main.tf` backend configuration:
   ```hcl
   backend "s3" {
     bucket = "your-unique-terraform-state-bucket"
     key    = "microservices-app/terraform.tfstate"
     region = "us-east-1"
   }
   ```

3. **Update Repository URL:**
   Edit `infra/ansible/site.yml`:
   ```yaml
   vars:
     app_repo: "https://github.com/YOUR_USERNAME/DevOps-Stage-6.git"
   ```

### 3. Single Command Deployment

```bash
# Make scripts executable
chmod +x deploy.sh build.sh

# Deploy everything
./deploy.sh
```

### 4. Verification

1. **Check Infrastructure:**
   ```bash
   cd infra/terraform
   terraform output
   ```

2. **Check Application:**
   - Visit `https://your-domain.com`
   - Login with provided credentials
   - Test API endpoints

3. **Check Services:**
   ```bash
   ssh -i ~/.ssh/microservices_key ubuntu@<server-ip>
   docker-compose ps
   ```

### 5. CI/CD Setup (Optional)

1. **GitHub Secrets:**
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `EMAIL_USERNAME`
   - `EMAIL_PASSWORD`
   - `NOTIFICATION_EMAIL`

2. **Environment Protection:**
   - Go to Settings > Environments
   - Create "production" environment
   - Add required reviewers

## Expected Behavior

### Successful Login Flow
1. Visit `https://your-domain.com`
2. See login page
3. Login with: `admin` / `Admin123`
4. Redirected to TODO dashboard
5. Can create/view/delete todos

### API Security
- `https://your-domain.com/api/auth` → "Not Found"
- `https://your-domain.com/api/todos` → "Invalid Token"
- `https://your-domain.com/api/users` → "Missing Authorization header"

### Infrastructure Idempotency
- Re-running `terraform apply` → "No changes"
- Only applies changes when drift detected
- Email notifications for drift

## Troubleshooting

### Common Issues

1. **Domain not resolving:**
   - Check DNS propagation
   - Verify A record points to server IP

2. **SSL certificate issues:**
   - Check domain ownership
   - Verify email is accessible
   - Wait for Let's Encrypt validation

3. **Services not starting:**
   ```bash
   docker-compose logs
   docker-compose restart <service>
   ```

4. **Terraform state issues:**
   ```bash
   terraform refresh
   terraform import <resource> <id>
   ```

### Health Checks

```bash
# Check all services
curl -k https://your-domain.com/health

# Check individual services
docker-compose exec frontend curl localhost
docker-compose exec auth-api curl localhost:8081/health
docker-compose exec todos-api curl localhost:8082/health
docker-compose exec users-api curl localhost:8083/health
```

## Screenshots Required for Submission

1. Login page on your domain
2. TODO dashboard after login
3. Successful Terraform apply output
4. Terraform "No changes" output
5. Drift detection email alert
6. Ansible deployment output