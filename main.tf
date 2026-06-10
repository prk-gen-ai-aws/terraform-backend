# ============================================================
# Shared Terraform Backend
# Creates ONE S3 bucket + ONE DynamoDB table
# Used across ALL Gen AI portfolio projects
# ============================================================

provider "aws" {
  region = var.aws_region
}

# ── S3 bucket for remote state storage ──
resource "aws_s3_bucket" "terraform_state" {
  bucket = "prk-terraform-state-${var.aws_account_id}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "prk-terraform-state"
    Purpose = "Terraform remote state - all Gen AI portfolio projects"
    Owner   = "prk"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── DynamoDB table for state locking ──
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "prk-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "prk-terraform-state-lock"
    Purpose = "Terraform state locking - all Gen AI portfolio projects"
    Owner   = "prk"
  }
}
