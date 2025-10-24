# -----------------------------
# EC2 Instances
# -----------------------------
#Play around with Amazon Linux 2023
resource "aws_instance" "Alan-AmznLinux" {
  #ami                         = "ami-0d902a8756c37e690"
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  associate_public_ip_address = false
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.app_efs_client_sg.id
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = { Name = "Alan-AmznLinux" }
}

locals {
  hosts = ["web01", "web02", "web03", "web04", "web05"]
}
#Play around with Rhel 9....add 5 instances on public subnet
resource "aws_instance" "Alan-Rhel9" {
  #ami                         = "ami-0f7153f6999a5ef60"
  for_each                    = toset(local.hosts)
  ami                         = data.aws_ami.rhel9_latest.id
  associate_public_ip_address = true
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.app_efs_client_sg.id
  ]
  key_name             = "Alan-KP"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  #Install SSM agent onto Rhel10 instance and run updates
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    dnf upgrade -y
  EOF

  tags = {
    Name = each.key
  }
}

# -----------------------------
# Security Groups
# -----------------------------

# EC2 SG
resource "aws_security_group" "app_efs_client_sg" {
  name   = "app_efs_client_sg"
  vpc_id = aws_vpc.alan_vpc.id
  tags = {
    Name = "app_efs_client_sg"
  }
}

# Allows only outbound traffic, no inbound.  Connect to EC2 via SSM
# resource "aws_security_group" "no_inbound_all_outbound" {
#   name        = "no-inbound-all-outbound"
#   description = "No inbound traffic; allow all outbound traffic"
#   vpc_id      = aws_vpc.alan_vpc.id

#   # No inbound rules at all — blocks all incoming traffic
#   ingress = []

#   # Allow all outbound traffic
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1" # all protocols
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "no-inbound-all-outbound"
#   }
# }

#EFS share to mount to EC2 instances
resource "aws_security_group" "efs_sg" {
  name   = "efs-sg"
  vpc_id = aws_vpc.alan_vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.app_efs_client_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "NFS Inbound"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH Inbound"
  vpc_id      = aws_vpc.alan_vpc.id

  # Allow SSH Inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Inbound"
  }
}