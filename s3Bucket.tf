resource "random_uuid" "bucket_name" {}

resource "aws_s3_bucket" "attachments" {
  bucket        = random_uuid.bucket_name.result
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
      kms_master_key_id = data.aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Apply lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.attachments.id

  rule {
    id     = "transition-to-IA"
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