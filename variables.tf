variable "frontend_bucket_name" {
  description = "Name of the S3 bucket for the frontend"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name for the resume site"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  sensitive   = true
}

variable "frontend_repo" {
  description = "Front repository"
  type        = string
}

variable "backend_repo" {
  description = "Backend repository"
  type        = string
}
