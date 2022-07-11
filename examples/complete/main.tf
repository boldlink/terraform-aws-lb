module "vpc" {
  source               = "git::https://github.com/boldlink/terraform-aws-vpc.git?ref=2.0.3"
  cidr_block           = local.cidr_block
  name                 = local.name
  enable_dns_support   = true
  enable_dns_hostnames = true
  account              = data.aws_caller_identity.current.account_id
  region               = data.aws_region.current.name

  ## public Subnets
  public_subnets          = local.public_subnets
  availability_zones      = local.azs
  map_public_ip_on_launch = true
  tag_env                 = local.tag_env
}

module "complete" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  source                     = "../../"
  name                       = "complete-example-alb"
  internal                   = false
  subnets                    = flatten(module.vpc.public_subnet_id)
  vpc_id                     = module.vpc.id
  enable_deletion_protection = false
  create_ssl_certificate     = true

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
