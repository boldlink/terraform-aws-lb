provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

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
  source = "../"

  name               = "${random_string.random.id}-alb"
  load_balancer_type = "application"
  internal           = true
  subnets            = data.aws_subnets.default.ids
  security_groups    = [data.aws_security_group.default.id]

  target_group_health_check = {
    enabled             = true
    healthy_threshold   = 10
    interval            = 10
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 7
  }

  target_group_name_prefix = "h1"
  target_group_port        = 80
  target_group_protocol    = "HTTP"
  target_group_stickiness = {
    cookie_duration = 300
    cookie_name     = "test-session-cookie"
    type            = "lb_cookie"
  }
  target_group_tags = {
    Name        = "test-target-group"
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
