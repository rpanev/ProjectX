variable "name" {
  description = "Name prefix for IAM resources"
  type        = string
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs that EC2 instances can access"
  type        = list(string)
  default     = ["*"]
}
