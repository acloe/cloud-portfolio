# Terraform AWS Infrastructure

This project builds a foundational AWS environment using Terraform.  
It’s designed as a starting point for automating cloud infrastructure in a reusable, modular way.

## 🧱 What It Builds

- **VPC** with public and private subnets  
- **Internet Gateway** for public outbound access  
- **NAT Gateway** for private subnet internet access  
- **Route Tables** and associations  
- **IAM Role & Instance Profile** for EC2 SSM access  
- **EC2 Instance** RHEL 10 with SSM Agent installed via `user_data` and Amazon Linux 2023
- **Security Group** allowing no inbound traffic and all outbound traffic

## 🧩 How to Use

1. Clone this repo:
   ```bash
   git clone https://github.com/acloe/cloud-portfolio.git
   cd cloud-portfolio/Terraform
   ```

2. Initialize and plan:
   ```bash
   terraform init
   terraform plan
   ```

3. Apply changes:
   ```bash
   terraform apply
   ```

4. To destroy:
   ```bash
   terraform destroy
   ```

## ⚙️ Requirements

- Terraform ≥ 1.7.0  
- AWS CLI configured with valid credentials  
- AWS account with permissions to create VPC, EC2, and IAM resources

## 📂 File Overview

| File | Description |
|------|--------------|
| `main.tf` | (Terraform resources and providers) |
| `compute.tf` | EC2 instances and security groups |
| `network.tf` | VPC, subnets, route tables, IGW and Nat GW |
| `iam.tf` | Role for SSM use |
| `variables.tf` | Input variables |
| `outputs.tf` | Outputs such as VPC and instance IDs |
| `.gitignore` | Excludes Terraform state files |

## 🚀 Next Steps

- Add Terraform **modules** for VPC, EC2, and IAM  
- Integrate with **remote backend** (S3 + DynamoDB) for state management  
- Add a **CI/CD workflow** to run `terraform plan` on each pull request  

---

> _Built as part of my DevOps learning journey — demonstrating AWS infrastructure automation using Terraform._
