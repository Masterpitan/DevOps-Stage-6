# Deployment Steps

## 1. Deploy Infrastructure (gets IP)
```bash
cd infra/terraform
terraform init
terraform apply
```

## 2. Get the server IP
```bash
terraform output server_public_ip
```

## 3. Update DNS at freedns.afraid.org
- Login to freedns.afraid.org
- Update your subdomain (dia.mooo.com) to point to the server IP

## 4. Wait for DNS propagation (5-10 minutes)
```bash
nslookup dia.mooo.com
```

## 5. Re-run Ansible to configure SSL
```bash
cd ../ansible
ansible-playbook -i inventory.ini site.yml
```

## 6. Test the application
- https://dia.mooo.com
- Login with: admin / Admin123