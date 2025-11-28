#!/bin/bash

set -e

echo "🚀 Starting deployment of microservices application..."

# Check if terraform.tfvars exists
if [ ! -f "infra/terraform/terraform.tfvars" ]; then
    echo "❌ terraform.tfvars not found. Please create it from terraform.tfvars.example"
    exit 1
fi

# Build Java application first
echo "🔨 Building Java application..."
cd users-api
./mvnw clean package -DskipTests
cd ..

# Deploy infrastructure
echo "🏗️  Deploying infrastructure..."
cd infra/terraform
terraform init
terraform apply -auto-approve
cd ../..

echo "✅ Deployment completed successfully!"
echo "🌐 Your application should be available at your configured domain"
echo "📊 Check service status with: docker-compose ps"