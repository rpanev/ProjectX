# Data source to get instance IDs from ASG
data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [module.asg.autoscaling_group_name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.asg]
}