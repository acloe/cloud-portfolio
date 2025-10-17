# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "alan_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Alan VPC"
  }
}

# -----------------------------
# Subnets
# -----------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.alan_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "Public Subnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.alan_vpc.id
  cidr_block = "10.0.1.0/24"
  tags       = { Name = "Private Subnet" }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.alan_vpc.id
  tags   = { Name = "Internet Gateway" }
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
resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnet.id
  connectivity_type = "public"
  tags              = { Name = "NAT Gateway" }
}

# -----------------------------
# Public Route Table
# -----------------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.alan_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Public Route Table" }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}

# -----------------------------
# Private Route Table
# -----------------------------
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.alan_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "Private Route Table" }
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}