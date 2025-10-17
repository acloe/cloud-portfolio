# -----------------------------
# EC2 Instances
# -----------------------------
resource "aws_instance" "Alan-AmznLinux" {
  #Bitnami NGINX 1.29.2
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