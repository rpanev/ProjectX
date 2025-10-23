terraform {
  source = "../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment = "stage"
  region      = "eu-west-1"
}

inputs = {
  name   = "vpc-${local.environment}"
  region = local.region
  
  vpc_cidr             = "10.1.0.0/16"
  azs                  = ["${local.region}a", "${local.region}b"]
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
  
  flow_log_bucket_arn = ""
}
