# -----------------------------
# Outputs
# -----------------------------
#Output the EC2 instance IDs for use with SSM connect

output "Alan_EC2_Instance_IDs" {
  value = {
    AmznLinux = aws_instance.Alan-AmznLinux.id
    RHEL9     = [for instance in aws_instance.Alan-Rhel9 : instance.id]
  }
}

output "efs_id" {
  value = aws_efs_file_system.main.id
}
