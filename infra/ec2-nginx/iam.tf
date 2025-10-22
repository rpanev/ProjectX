# IAM Module
module "iam" {
  source = "../modules/iam"

  name           = var.project_name
  s3_bucket_arns = var.s3_bucket_arns
}