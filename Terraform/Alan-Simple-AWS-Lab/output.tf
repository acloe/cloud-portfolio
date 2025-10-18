# -----------------------------
# Outputs
# -----------------------------
#Output the EC2 instance IDs for use with SSM connect

output "Alan_Amzn_ID" {
  value = {
    AmznLinux = aws_instance.Alan-AmznLinux.id
    RHEL10    = aws_instance.Alan-Rhel10.id
  }
}
