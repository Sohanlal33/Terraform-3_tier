# Create S3 Bucket for Terraform backend or application artifacts
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.backend_s3_bucket  # use variable from variables.tf
  acl    = "private"

  tags = merge(var.tags, {
    Name = "3tier-app-bucket"
  })
}

# Enable versioning (optional but recommended for Terraform state)
resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_sse" {
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional: Block public access
resource "aws_s3_bucket_public_access_block" "app_bucket_block" {
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}i

