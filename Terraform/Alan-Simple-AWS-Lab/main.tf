# -----------------------------
# Terraform
# -----------------------------
terraform {
  required_version = ">= 1.7.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# -----------------------------
# Providers
# -----------------------------
provider "aws" {
  region = "us-west-1"
}

# -----------------------------
# AMI ID's, pullest latest image
# -----------------------------
data "aws_ami" "rhel9_latest" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat official AWS account ID

  filter {
    name   = "name"
    values = ["RHEL-9.*x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# data "aws_ami" "rhel" {
#   most_recent = true
#   owners      = ["309956199498"] # Red Hat's AWS account

#   filter {
#     name   = "name"
#     values = ["RHEL-10*-x86_64-*"]
#   }
# }

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}