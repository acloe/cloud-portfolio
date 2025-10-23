resource "aws_efs_file_system" "main" {
  creation_token   = "my-lab-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = {
    Name = "my-lab-efs"
  }
}

resource "aws_efs_mount_target" "efs_mnt" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.efs_sg.id]
}