# AWS Configuration
aws_region   = "us-east-1"
environment  = "production"
project_name = "nginx-app"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# AMI Configuration
ami_id = "ami-04e415412e60004dc"  # Update with AMI ID from Packer build

# EC2 Configuration
instance_type = "t3.micro"
key_name      = "devxo-us"  # Optional: EC2 key pair name for SSH access (leave empty to use SSM)

# SSH Access
ssh_cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production

# Auto Scaling Configuration
asg_min_size         = 2
asg_max_size         = 4
asg_desired_capacity = 2

# Auto Scaling Policies
cpu_target_value                 = 70
enable_alb_request_count_scaling = false
alb_request_count_target_value   = 1000

# ALB Configuration
enable_alb_deletion_protection = false

# ============================================================================
# ACM Certificate for HTTPS (оption)
# ============================================================================

# enable_acm_certificate    = true
# domain_name               = "example.com"
# subject_alternative_names = ["www.example.com", "*.example.com"]
# route53_zone_id           = "Z1234567890ABC"


# Custom Configuration
custom_message = "Welcome to Nginx Web Server!"
