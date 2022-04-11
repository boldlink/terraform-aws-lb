provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

module "alb" {
  source             = "../../"
  name               = "${random_string.random.id}-alb"
  load_balancer_type = "application"
  internal           = true
  subnets            = data.aws_subnets.default.ids
  security_groups    = [data.aws_security_group.default.id]
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

  listeners = [
    {
      load_balancer_arn = module.alb.lb_arn
      port              = "80"
      protocol          = "HTTP"
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
  tags = {
    Name        = "test-target-group"
    Environment = "dev"
  }
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
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
  tags = {
    Name        = "custom-target-group"
    Environment = "dev"
  }
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}
output "outputs" {
  value = [
    module.alb,
  ]
}
