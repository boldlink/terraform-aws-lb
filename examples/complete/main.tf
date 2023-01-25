module "access_logs_s3" {
  source        = "boldlink/s3/aws"
  bucket        = local.name
  bucket_policy = data.aws_iam_policy_document.s3.json
  force_destroy = true
  tags          = local.tags
}

module "complete" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_2: "Ensure ALB protocol is HTTPS"
  source                     = "../../"
  name                       = local.name
  internal                   = false
  subnets                    = local.public_subnets
  vpc_id                     = local.vpc_id
  enable_deletion_protection = false
  create_ssl_certificate     = true
  tags                       = local.tags

  access_logs = {
    bucket  = module.access_logs_s3.bucket
    enabled = true
  }

  target_groups = [
    {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
      stickiness = {
        cookie_duration = 3600
        enabled         = true
        type            = "lb_cookie"

      }
      health_check = {
        enabled             = true
        healthy_threshold   = 10
        interval            = 10
        path                = "/"
        port                = 80
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 7
      }
    }
  ]

  listeners = [
    {
      port     = 443
      protocol = "HTTPS"
      default_action = {
        type = "fixed-response"

        fixed_response = {
          content_type = "text/plain"
          message_body = "Fixed message"
          status_code  = "200"
        }
      }
    }
    ,
    {
      default_action = {
        type     = "forward"
        tg_index = 0
      }
      port     = 80
      protocol = "HTTP"
    }

  ]
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
