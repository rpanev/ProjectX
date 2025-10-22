output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_lock.arn
}

output "vpc_flow_logs_bucket_name" {
  description = "Name of the S3 bucket for VPC flow logs"
  value       = aws_s3_bucket.vpc_flow_logs.id
}

output "vpc_flow_logs_bucket_arn" {
  description = "ARN of the S3 bucket for VPC flow logs"
  value       = aws_s3_bucket.vpc_flow_logs.arn
}

output "backend_config" {
  description = "Backend configuration to use in main Terraform code"
  value = <<-EOT
    backend "s3" {
      bucket         = "${aws_s3_bucket.terraform_state.id}"
      key            = "ec2-nginx/terraform.tfstate"
      region         = "${var.aws_region}"
      encrypt        = true
      dynamodb_table = "${aws_dynamodb_table.terraform_lock.name}"
    }
  EOT
}
