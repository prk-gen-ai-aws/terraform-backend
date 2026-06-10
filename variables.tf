variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID — used in S3 bucket name to ensure uniqueness"
  type        = string
  sensitive   = true
}
