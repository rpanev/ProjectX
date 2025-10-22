# ASG Module
module "asg" {
  source = "../modules/asg"

  name                      = var.project_name
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  iam_instance_profile_name = module.iam.instance_profile_name
  security_group_id         = module.security_groups.ec2_security_group_id
  private_subnet_ids        = module.vpc.private_subnets
  target_group_arn          = module.alb.target_group_arn

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  user_data = templatefile("${path.module}/userdata.sh", {
    environment    = var.environment
    app_name       = var.project_name
    custom_message = var.custom_message
  })

  cpu_target_value                 = var.cpu_target_value
  enable_alb_request_count_scaling = var.enable_alb_request_count_scaling
  alb_request_count_target_value   = var.alb_request_count_target_value
  alb_arn_suffix                   = module.alb.alb_arn
  target_group_arn_suffix          = module.alb.target_group_arn
}