# tf-aws-infra

# Terraform AWS Infrastructure

This repository contains Terraform configuration for AWS networking infrastructure.

## Prerequisites

- AWS CLI installed and configured with dev/demo profiles
- Terraform installed
- Git

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/[your-organization]/tf-aws-infra.git
   cd tf-aws-infra
   ```

2. Create `terraform.tfvars` (do not commit this file):
   ```hcl
   aws_region     = "us-east-1"  # Change to your region
   profile        = "dev"        # or "demo"
   vpc_name       = "my-vpc"
   vpc_cidr       = "10.0.0.0/16"
   public_subnet_cidrs = [
     "10.0.1.0/24",
     "10.0.2.0/24",
     "10.0.3.0/24"
   ]
   private_subnet_cidrs = [
     "10.0.4.0/24",
     "10.0.5.0/24",
     "10.0.6.0/24"
   ]
   ```

3. Deploy and destroy:
   ```bash
   terraform init
   terraform plan
   terraform apply
   
   # When finished
   terraform destroy
   ```

## Multiple VPCs

To create multiple VPCs in the same account/region:

1. Create separate variable files (e.g., `vpc2.tfvars`) with different values
2. Apply with the specific variable file:
   ```bash
   terraform apply -var-file=vpc2.tfvars
   ```

## Infrastructure Details

Creates:
- VPC
- 3 public subnets in different AZs
- 3 private subnets in different AZs
- Internet Gateway
- Public route table with internet access
- Private route table
- Subnet associations

## Best Practices

- Never commit AWS credentials or sensitive data
- Use variables instead of hardcoded values
- Use workspaces or variable files for multiple environments
- Follow the principle of least privilege for IAM permissions