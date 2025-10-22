# -----------------------------
# S3 bucket
# -----------------------------
#Create a bucket to play around with
resource "aws_s3_bucket" "acloe-bucket" {
  bucket = "acloe-intelligent-tiering-demo"

  tags = {
    Name        = "IntelligentTieringBucket"
    Environment = "Dev"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "acloe-bucket" {
  bucket = aws_s3_bucket.acloe-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Intelligent-Tiering configuration
resource "aws_s3_bucket_lifecycle_configuration" "acloe-bucket" {
  bucket = aws_s3_bucket.acloe-bucket.id

  rule {
    id     = "IntelligentTieringWithArchive"
    status = "Enabled"

    filter {
      prefix = ""
    }

    # Immediately move new objects into Intelligent-Tiering
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}