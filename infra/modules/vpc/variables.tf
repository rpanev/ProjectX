variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "endpoint_sg_id" {
  type = string
}

variable "flow_log_bucket_arn" {
  description = "S3 bucket ARN for VPC flow logs"
  type        = string
  default     = ""
}
