terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "hng-state"
    key    = "microservices-app/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Security Group
resource "aws_security_group" "app_sg" {
  name_prefix = "microservices-app-"
  description = "Security group for microservices application"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "microservices-app-sg"
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    domain = var.domain
  }))

  tags = {
    Name = "microservices-app-server"
  }
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    server_ip = aws_instance.app_server.public_ip
    domain    = var.domain
  })
  filename = "${path.module}/../ansible/inventory.ini"
}

# Run Ansible after infrastructure is ready
resource "null_resource" "run_ansible" {
  depends_on = [aws_instance.app_server, local_file.ansible_inventory]

  triggers = {
    instance_id = aws_instance.app_server.id
  }

  provisioner "local-exec" {
    command = "Start-Sleep 60; Set-Location '${path.module}/../ansible'; ansible-playbook -i inventory.ini site.yml"
    interpreter = ["powershell", "-Command"]
  }
}
