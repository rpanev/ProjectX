output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "URL to access the application"
  value       = "http://${module.alb.alb_dns_name}"
}

output "alb_https_url" {
  description = "HTTPS URL to access the application (if certificate is configured)"
  value       = (var.enable_acm_certificate || var.acm_certificate_arn != "") ? "https://${module.alb.alb_dns_name}" : "N/A - No certificate configured"
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate (if created)"
  value       = var.enable_acm_certificate ? module.acm[0].certificate_arn : "N/A - Certificate not created"
}

output "acm_certificate_domain" {
  description = "Domain name of the ACM certificate (if created)"
  value       = var.enable_acm_certificate ? module.acm[0].certificate_domain_name : "N/A - Certificate not created"
}

output "acm_certificate_status" {
  description = "Status of the ACM certificate (if created)"
  value       = var.enable_acm_certificate ? module.acm[0].certificate_status : "N/A - Certificate not created"
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.autoscaling_group_name
}

output "instance_ids" {
  description = "IDs of running EC2 instances in the ASG"
  value       = data.aws_instances.asg_instances.ids
}

output "instance_private_ips" {
  description = "Private IP addresses of running EC2 instances"
  value       = data.aws_instances.asg_instances.private_ips
}

output "ssm_connect_command" {
  description = "AWS SSM command to connect to instances"
  value       = length(data.aws_instances.asg_instances.ids) > 0 ? "aws ssm start-session --target ${data.aws_instances.asg_instances.ids[0]}" : "No instances running"
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.alb.target_group_arn
}

output "iam_role_name" {
  description = "Name of the IAM role for EC2 instances"
  value       = module.iam.role_name
}

output "security_group_alb_id" {
  description = "ID of the ALB security group"
  value       = module.security_groups.alb_security_group_id
}

output "security_group_ec2_id" {
  description = "ID of the EC2 security group"
  value       = module.security_groups.ec2_security_group_id
}
