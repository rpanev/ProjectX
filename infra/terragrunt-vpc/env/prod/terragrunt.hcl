terraform {
  source = "../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment = "prod"
  region      = "eu-west-1"
}

inputs = {
  name   = "vpc-${local.environment}"
  region = local.region
  
  vpc_cidr             = "10.2.0.0/16"
  azs                  = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  private_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]
  
  flow_log_bucket_arn = ""
}
