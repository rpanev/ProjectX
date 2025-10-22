variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "terraform-state-nginx-app"
}

variable "static_files_bucket_name" {
  description = "Name of the S3 bucket for static files"
  type        = string
  default     = "nginx-app-static-files"
}

variable "vpc_flow_logs_bucket_name" {
  description = "Name of the S3 bucket for VPC flow logs"
  type        = string
  default     = "nginx-app-vpc-flow-logs"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"
}
