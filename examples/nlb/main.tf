module "nlb" {
  #checkov:skip=CKV_AWS_150 #"Ensure that Load Balancer has deletion protection enabled"
  source                           = "../../"
  name                             = var.name
  load_balancer_type               = "network"
  internal                         = false
  subnets                          = local.public_subnets
  enable_deletion_protection       = var.enable_deletion_protection
  idle_timeout                     = 60
  enable_cross_zone_load_balancing = true
  ip_address_type                  = "ipv4"
  vpc_id                           = local.vpc_id

  listeners = [
    {
      default_action = {
        type     = "forward"
        tg_index = 0
      }
      port     = 53
      protocol = "UDP"
    },
    {
      port     = 443
      protocol = "TCP"
      default_action = {
        type     = "forward"
        tg_index = 1
      }
    }
  ]

  target_groups = [
    {
      name     = "udp-${var.name}"
      port     = 53
      protocol = "UDP"
    },
    {
      name     = "tcp-${var.name}"
      port     = 80
      protocol = "TCP"
      health_check = {
        enabled             = true
        healthy_threshold   = 3
        interval            = 30
        matcher             = "200-399"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 3
      }

      preserve_client_ip            = true
      protocol_version              = "HTTP1"
      tags                          = local.tags
    },
    {
      name     = "http-${var.name}"
      port     = 8080
      protocol = "HTTP"

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 10
        matcher             = "200"
        path                = "/health"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 3
        unhealthy_threshold = 2
      }

      load_balancing_algorithm_type = "round_robin"
      #preserve_client_ip            = false #A target group with HTTP protocol does not support the attribute preserve_client_ip
      protocol_version = "HTTP2"

      tags = local.tags
    }
  ]
}
