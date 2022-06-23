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

resource "aws_security_group" "lb" {
  name        = "${local.name}-security-group"
  description = "Allow inbound traffic from ${local.name} network"
  vpc_id      = module.vpc.id

  ingress {
    description = "allow tls"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow custom http"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-security-group"
  }
}

module "complete" {
  source          = "../.."
  name            = "complete-example-alb"
  internal        = false
  subnets         = flatten(module.vpc.public_subnet_id)
  security_groups = [aws_security_group.lb.id]
}

module "target_group1" {
  source = "../../modules/target-group"
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

  create_ssl_certificate = true

  listeners = [
    {
      load_balancer_arn = module.complete.lb_arn
      port              = 80
      protocol          = "HTTP"
      default_action = {
        type = "fixed-response"

        fixed_response = {
          content_type = "text/plain"
          message_body = "Fixed message"
          status_code  = "200"
        }
      }
    },
    {
      load_balancer_arn = module.complete.lb_arn
      port              = 443
      protocol          = "HTTPS"
      default_action = {
        type = "fixed-response"

        fixed_response = {
          content_type = "text/plain"
          message_body = "Fixed message"
          status_code  = "200"
        }
      }
    }
  ]

  name_prefix = "h1"
  port        = 80
  protocol    = "HTTP"
  stickiness = {
    cookie_duration = 300
    cookie_name     = "test-session-cookie"
    type            = "lb_cookie"
  }

  target_type = "ip"
  vpc_id      = module.vpc.id

  tags = {
    Name        = "${local.name}-target-group"
    Environment = "Dev"
  }
}

module "custom" {
  source = "../../modules/target-group"
  health_check = {
    enabled             = true
    healthy_threshold   = 10
    interval            = 10
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 7
  }

  name_prefix = "h1"
  port        = 8080
  protocol    = "HTTP"
  stickiness = {
    cookie_duration = 300
    cookie_name     = "test-session-cookie"
    type            = "lb_cookie"
  }

  target_type = "ip"
  vpc_id      = module.vpc.id

  tags = {
    Name        = "custom-target-group"
    Environment = "dev"
  }
}
