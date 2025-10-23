# ALB Module
module "alb" {
  source = "../modules/alb"

  name                       = var.project_name
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnets
  security_group_id          = module.security_groups.alb_security_group_id
  enable_deletion_protection = var.enable_alb_deletion_protection
  # Check if ACM certificate should be created by this module or use an existing one
  # If enable_acm_certificate is true, use the certificate ARN from the ACM module
  # Otherwise, use the externally provided certificate ARN from variables
  certificate_arn            = var.enable_acm_certificate ? module.acm[0].certificate_arn : var.acm_certificate_arn
}