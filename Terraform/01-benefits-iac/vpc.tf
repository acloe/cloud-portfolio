#Template for creating a simple VPC, 2 subnets public/private, route table and IGW.

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
      region = "us-west-1"
    }

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "demo_vpc" {
      cidr_block = "10.0.0.0/16"

      tags = {
        Name = "Terraform VPC"
      }
    }

# -----------------------------
# Subnets
# -----------------------------
resource "aws_subnet" "public_subnet" {
      vpc_id     = aws_vpc.demo_vpc.id
      cidr_block = "10.0.0.0/24"
    }

resource "aws_subnet" "private_subnet" {
      vpc_id     = aws_vpc.demo_vpc.id
      cidr_block = "10.0.1.0/24"
    }

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
      vpc_id = aws_vpc.demo_vpc.id
    }

# -----------------------------
# Elastic IP (for NAT)
# -----------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# -----------------------------
# NAT Gateway
# -----------------------------
resource "aws_nat_gateway" "nat_demo" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
  connectivity_type = "public"
}

# -----------------------------
# Public Route Table
# -----------------------------
resource "aws_route_table" "public_rtb" {
      vpc_id = aws_vpc.demo_vpc.id

      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
      }
    }

# -----------------------------
# Private Route Table
# -----------------------------
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_demo.id
  }

  tags = { Name = "Private Route Table" }
}

resource "aws_route_table_association" "public_subnet" {
      subnet_id      = aws_subnet.public_subnet.id
      route_table_id = aws_route_table.public_rtb.id
    }

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}

