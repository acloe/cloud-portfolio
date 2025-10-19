# -----------------------------
# Outputs
# -----------------------------
#Output the EC2 instance IDs for use with SSM connect

output "Alan_EC2_Instance_IDs" {
  value = {
    AmznLinux = aws_instance.Alan-AmznLinux.id
    RHEL10    = aws_instance.Alan-Rhel10.id
  }
}
