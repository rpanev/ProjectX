# ============================================================================
# ACM Certificate (Optional - comment out if not needed)
# ============================================================================
module "acm" {
  count  = var.enable_acm_certificate ? 1 : 0
  source = "../modules/acm"

  name                      = var.project_name
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  route53_zone_id           = var.route53_zone_id

  tags = {
    Environment = var.environment
  }
}
