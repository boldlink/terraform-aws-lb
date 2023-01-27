module "access_logs_s3" {
  source        = "boldlink/s3/aws"
  bucket        = local.name
  bucket_policy = data.aws_iam_policy_document.s3.json
  force_destroy = true
  tags          = local.tags
}

module "minimum" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_2: "Ensure ALB protocol is HTTPS"
  source                     = "../../"
  name                       = local.name
  internal                   = false
  enable_deletion_protection = false
  vpc_id                     = local.vpc_id
  subnets                    = local.public_subnets

  access_logs = {
    bucket  = module.access_logs_s3.bucket
    enabled = true
  }

  ingress_rules = {
    https = {
      description = "allow tls"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    http = {
      description = "allow http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
