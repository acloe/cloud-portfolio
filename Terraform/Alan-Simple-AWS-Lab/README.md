This is my Terraform "home lab" to experiment with.

1.  Adds VPC
2.  Adds public/private subnet in VPC
3.  Creates public/private route tables
4.  Creates IGW for public compute and NAT GW for private compute
5.  Creates Amazon Linux 2023 and RHEL 10 EC2 instance
6.  Creates IAM role with permissions set for SSM use, attaches to EC2 instance
7.  Creates Security Group for EC2 to allow all outbound traffic and no inbound traffic for private subnet

