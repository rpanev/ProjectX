# Security Groups Module
module "security_groups" {
  source = "../modules/security-groups"

  name            = var.project_name
  vpc_id          = module.vpc.vpc_id
  ssh_cidr_blocks = var.ssh_cidr_blocks
}