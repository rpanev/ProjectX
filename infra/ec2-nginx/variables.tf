variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "nginx-app"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "flow_log_bucket_arn" {
  description = "S3 bucket ARN for VPC flow logs (from backend-setup output)"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI ID created by Packer"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access (optional, leave empty to use SSM Session Manager)"
  type        = string
  default     = ""
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access (use [] to disable SSH, recommended: use SSM Session Manager instead)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs for IAM policy"
  type        = list(string)
  default     = ["*"]
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "cpu_target_value" {
  description = "Target CPU utilization for auto scaling"
  type        = number
  default     = 70
}

variable "enable_alb_request_count_scaling" {
  description = "Enable auto scaling based on ALB request count"
  type        = bool
  default     = false
}

variable "alb_request_count_target_value" {
  description = "Target request count per target"
  type        = number
  default     = 1000
}

variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS (optional, leave empty to create new certificate)"
  type        = string
  default     = ""
}

# ACM Certificate Creation (Optional)
variable "enable_acm_certificate" {
  description = "Enable automatic ACM certificate creation with Route53 validation"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Primary domain name for ACM certificate (e.g., example.com)"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "Additional domain names for ACM certificate (e.g., ['www.example.com', '*.example.com'])"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS validation"
  type        = string
  default     = ""
}

variable "custom_message" {
  description = "Custom message to pass via userdata"
  type        = string
  default     = "Welcome to Nginx!"
}
