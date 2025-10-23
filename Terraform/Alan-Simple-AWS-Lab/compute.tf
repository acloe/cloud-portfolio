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
    aws_security_group.no_inbound_all_outbound.id,
    aws_security_group.app_efs_client_sg.id
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = { Name = "Alan-AmznLinux" }
}

#Play around with Rhel 10
resource "aws_instance" "Alan-Rhel10" {
  #ami                         = "ami-0f7153f6999a5ef60"
  ami                         = data.aws_ami.rhel.id
  associate_public_ip_address = false
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.no_inbound_all_outbound.id,
    aws_security_group.app_efs_client_sg.id
  ]
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

  tags = { Name = "Alan-Rhel10" }
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
resource "aws_security_group" "no_inbound_all_outbound" {
  name        = "no-inbound-all-outbound"
  description = "No inbound traffic; allow all outbound traffic"
  vpc_id      = aws_vpc.alan_vpc.id

  # No inbound rules at all — blocks all incoming traffic
  ingress = []

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # all protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "no-inbound-all-outbound"
  }
}

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
