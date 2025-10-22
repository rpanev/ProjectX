# VPC Module
module "vpc" {
  source = "../modules/vpc"

  name                 = var.project_name
  region               = var.aws_region
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  endpoint_sg_id       = ""  # Will be created by security groups module
  flow_log_bucket_arn  = var.flow_log_bucket_arn
}