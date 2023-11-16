module "access_logs_s3" {
  source        = "boldlink/s3/aws"
  bucket        = var.name
  bucket_policy = data.aws_iam_policy_document.s3.json
  force_destroy = var.force_destroy
  tags          = local.tags
}

module "complete" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_2: "Ensure ALB protocol is HTTPS"
  source                     = "../../"
  name                       = var.name
  internal                   = var.internal
  subnets                    = local.public_subnets
  vpc_id                     = local.vpc_id
  enable_deletion_protection = var.enable_deletion_protection
  create_ssl_certificate     = var.create_ssl_certificate
  tags                       = local.tags
  target_groups              = var.target_group_configuration
  listeners                  = var.listeners_configuration

  # WAF association
  associate_with_waf = true
  web_acl_arn        = module.waf.arn

  access_logs = {
    bucket  = module.access_logs_s3.bucket
    enabled = var.access_logs_enabled
  }

  ingress_rules = {
    https = var.https_ingress
    http  = var.http_ingress
  }

  egress_rules = {
    default = var.egress_rules
  }
}
