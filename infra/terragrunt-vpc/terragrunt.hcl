# Terragrunt configuration for testing VPC module in isolation

terraform {
  source = "../modules/vpc"
}

# Generate backend configuration
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
EOF
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-west-1"
}
EOF
}

# Local variables
locals {
  project_name = "test-vpc"
  region       = "eu-west-1"
  vpc_cidr     = "10.0.0.0/16"
}

# Inputs for the VPC module
inputs = {
  name   = local.project_name
  region = local.region
  
  vpc_cidr             = local.vpc_cidr
  azs                  = ["eu-west-1a", "eu-west-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  
  # For testing, we'll create a temporary security group or leave empty
  endpoint_sg_id = ""
  
  # Optional: Flow logs bucket ARN (leave empty if not testing flow logs)
  flow_log_bucket_arn = ""
}
