<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ../modules/acm | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ../modules/alb | n/a |
| <a name="module_asg"></a> [asg](#module\_asg) | ../modules/asg | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../modules/iam | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | ../modules/security-groups | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instances.asg_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN of ACM certificate for HTTPS (optional, leave empty to create new certificate) | `string` | `""` | no |
| <a name="input_alb_request_count_target_value"></a> [alb\_request\_count\_target\_value](#input\_alb\_request\_count\_target\_value) | Target request count per target | `number` | `1000` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID created by Packer | `string` | n/a | yes |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | Desired number of instances in ASG | `number` | `2` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Maximum number of instances in ASG | `number` | `4` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Minimum number of instances in ASG | `number` | `2` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability zones | `list(string)` | <pre>[<br/>  "us-east-1a",<br/>  "us-east-1b"<br/>]</pre> | no |
| <a name="input_cpu_target_value"></a> [cpu\_target\_value](#input\_cpu\_target\_value) | Target CPU utilization for auto scaling | `number` | `70` | no |
| <a name="input_custom_message"></a> [custom\_message](#input\_custom\_message) | Custom message to pass via userdata | `string` | `"Welcome to Nginx!"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Primary domain name for ACM certificate (e.g., example.com) | `string` | `""` | no |
| <a name="input_enable_acm_certificate"></a> [enable\_acm\_certificate](#input\_enable\_acm\_certificate) | Enable automatic ACM certificate creation with Route53 validation | `bool` | `false` | no |
| <a name="input_enable_alb_deletion_protection"></a> [enable\_alb\_deletion\_protection](#input\_enable\_alb\_deletion\_protection) | Enable deletion protection for ALB | `bool` | `false` | no |
| <a name="input_enable_alb_request_count_scaling"></a> [enable\_alb\_request\_count\_scaling](#input\_enable\_alb\_request\_count\_scaling) | Enable auto scaling based on ALB request count | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"production"` | no |
| <a name="input_flow_log_bucket_arn"></a> [flow\_log\_bucket\_arn](#input\_flow\_log\_bucket\_arn) | S3 bucket ARN for VPC flow logs (from backend-setup output) | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 key pair name for SSH access (optional, leave empty to use SSM Session Manager) | `string` | `""` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | CIDR blocks for private subnets | `list(string)` | <pre>[<br/>  "10.0.11.0/24",<br/>  "10.0.12.0/24"<br/>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name prefix | `string` | `"nginx-app"` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR blocks for public subnets | `list(string)` | <pre>[<br/>  "10.0.1.0/24",<br/>  "10.0.2.0/24"<br/>]</pre> | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 hosted zone ID for DNS validation | `string` | `""` | no |
| <a name="input_s3_bucket_arns"></a> [s3\_bucket\_arns](#input\_s3\_bucket\_arns) | List of S3 bucket ARNs for IAM policy | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_ssh_cidr_blocks"></a> [ssh\_cidr\_blocks](#input\_ssh\_cidr\_blocks) | CIDR blocks allowed for SSH access (use [] to disable SSH, recommended: use SSM Session Manager instead) | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Additional domain names for ACM certificate (e.g., ['www.example.com', '*.example.com']) | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | ARN of the ACM certificate (if created) |
| <a name="output_acm_certificate_domain"></a> [acm\_certificate\_domain](#output\_acm\_certificate\_domain) | Domain name of the ACM certificate (if created) |
| <a name="output_acm_certificate_status"></a> [acm\_certificate\_status](#output\_acm\_certificate\_status) | Status of the ACM certificate (if created) |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the Application Load Balancer |
| <a name="output_alb_https_url"></a> [alb\_https\_url](#output\_alb\_https\_url) | HTTPS URL to access the application (if certificate is configured) |
| <a name="output_alb_url"></a> [alb\_url](#output\_alb\_url) | URL to access the application |
| <a name="output_autoscaling_group_name"></a> [autoscaling\_group\_name](#output\_autoscaling\_group\_name) | Name of the Auto Scaling Group |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the IAM role for EC2 instances |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | IDs of running EC2 instances in the ASG |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | Private IP addresses of running EC2 instances |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | IDs of public subnets |
| <a name="output_security_group_alb_id"></a> [security\_group\_alb\_id](#output\_security\_group\_alb\_id) | ID of the ALB security group |
| <a name="output_security_group_ec2_id"></a> [security\_group\_ec2\_id](#output\_security\_group\_ec2\_id) | ID of the EC2 security group |
| <a name="output_ssm_connect_command"></a> [ssm\_connect\_command](#output\_ssm\_connect\_command) | AWS SSM command to connect to instances |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the target group |
| <a name="output_vpc_endpoint_ec2messages_id"></a> [vpc\_endpoint\_ec2messages\_id](#output\_vpc\_endpoint\_ec2messages\_id) | ID of the EC2 Messages VPC Interface Endpoint |
| <a name="output_vpc_endpoint_s3_id"></a> [vpc\_endpoint\_s3\_id](#output\_vpc\_endpoint\_s3\_id) | ID of the S3 VPC Gateway Endpoint |
| <a name="output_vpc_endpoint_ssm_id"></a> [vpc\_endpoint\_ssm\_id](#output\_vpc\_endpoint\_ssm\_id) | ID of the SSM VPC Interface Endpoint |
| <a name="output_vpc_endpoint_ssmmessages_id"></a> [vpc\_endpoint\_ssmmessages\_id](#output\_vpc\_endpoint\_ssmmessages\_id) | ID of the SSM Messages VPC Interface Endpoint |
| <a name="output_vpc_endpoints_security_group_id"></a> [vpc\_endpoints\_security\_group\_id](#output\_vpc\_endpoints\_security\_group\_id) | ID of the security group for VPC endpoints |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END_TF_DOCS -->