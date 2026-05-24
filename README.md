# 🚀 3-Tier AWS Architecture Deployment Guide

This repository includes a Terraform-based implementation of a production-style 3-tier AWS architecture.

## 📁 Repository Structure

```
3-tier-aws-terraform/
├── backend/
├── frontend/
├── terraform/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── igw.tf
│   ├── nat.tf
│   ├── route_tables.tf
│   ├── security-groups.tf
│   ├── ec2.tf
│   ├── rds.tf
│   ├── outputs.tf
│   └── user_data/
│       ├── bastion.sh
│       ├── web.sh.tpl
│       └── app.sh.tpl
├── screenshots/
└── README.md
```

## ⚙️ Terraform Deployment

### Prerequisites
- AWS CLI configured with the right credentials
- Terraform >= 1.5
- SSH public key available locally

### Deploy Infrastructure

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### Important Outputs
After apply, Terraform prints:
- `web_public_ip`
- `bastion_public_ip`
- `app_private_ip`
- `db_endpoint`

## 🏗️ Architecture Overview

The deployment creates:
1. **Public Web Tier**: Nginx reverse proxy in the public subnet.
2. **Private App Tier**: Node.js backend in a private subnet.
3. **Private DB Tier**: RDS MySQL instance in an isolated DB subnet.
4. **Bastion Host**: secure SSH access into the VPC.
5. **Networking**: VPC, public/private/DB subnets, Internet Gateway, NAT Gateway, route tables.

## 🔐 Security Model

- **Bastion SG**: SSH from the admin CIDR.
- **Web SG**: HTTP from the internet + SSH from the admin CIDR.
- **App SG**: Node.js traffic from the web tier + SSH from bastion.
- **DB SG**: MySQL access only from the app tier.

## 🧩 How It Works

- The web server serves the static frontend and proxies `/api` requests to the private app server.
- The app server runs a Node.js Express backend that connects to RDS MySQL.
- The database is only reachable from inside the VPC.

## 📝 Notes

- Update `terraform/variables.tf` before applying if you want to change region, SSH key path, or DB credentials.
- The app server user data deploys a Node.js service under `/home/ubuntu/backend`.
- The web server user data deploys the frontend and Nginx configuration automatically.

## 🚀 Next Steps
- Run `terraform destroy` to remove the infrastructure.
- For production, replace the default database password and tighten `admin_cidr`.
