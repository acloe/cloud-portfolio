# -----------------------------
# EC2 Instances
# -----------------------------
#Play around with Amazon Linux 2023
resource "aws_instance" "Alan-AmznLinux" {
  ami                         = "ami-0d902a8756c37e690"
  associate_public_ip_address = false
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.no_inbound_all_outbound.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = { Name = "Alan-AmznLinux" }
}

#Play around with Rhel 10
resource "aws_instance" "Alan-Rhel10" {
  ami                         = "ami-0f7153f6999a5ef60"
  associate_public_ip_address = false
  instance_type               = "t3.large"
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.no_inbound_all_outbound.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  #Install SSM agent onto Rhel10 instance
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF

  tags = { Name = "Alan-Rhel10" }
}


# -----------------------------
# Security Groups
# -----------------------------
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