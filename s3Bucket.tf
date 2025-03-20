resource "random_uuid" "bucket_name" {}

resource "aws_s3_bucket" "attachments" {
  bucket = random_uuid.bucket_name.result
  force_destroy = true
  tags = {
    Name = "Attachments-Bucket"
  }
}

# Enable default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.attachments.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Apply lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.attachments.id

  rule {
    id = "transition-to-IA"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

# Restrict public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.attachments.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}