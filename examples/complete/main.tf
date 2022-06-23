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

module "complete" {
  source          = "../.."
  name            = "complete-example-alb"
  internal        = false
  subnets         = data.aws_subnets.default.ids
  security_groups = [data.aws_security_group.default.id]
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
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "test-target-group"
    Environment = "dev"
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
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "custom-target-group"
    Environment = "dev"
  }
}