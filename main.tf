#####################################
### Load Balancer
#####################################

resource "aws_lb" "main" {
  name                             = var.name
  name_prefix                      = var.name_prefix
  internal                         = var.internal
  load_balancer_type               = var.load_balancer_type
  security_groups                  = var.security_groups
  subnets                          = var.subnets
  enable_deletion_protection       = var.enable_deletion_protection
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  customer_owned_ipv4_pool         = var.customer_owned_ipv4_pool
  ip_address_type                  = var.ip_address_type

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", lookup(access_logs.value, "bucket", null) != null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags = merge(
    {
      "Name"        = var.name
      "Environment" = var.environment
    },
    var.other_tags,
  )
}

##########################################
### Target Group
##########################################

resource "aws_lb_target_group" "main" {
  connection_termination = var.target_group_connection_termination
  deregistration_delay   = var.target_group_deregistration_delay

  ## Max 1 Block
  dynamic "health_check" {
    for_each = length(keys(var.target_group_health_check)) == 0 ? [] : [var.target_group_health_check]
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      interval            = lookup(health_check.value, "interval", null)
      matcher             = lookup(health_check.value, "matcher", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
    }
  }

  lambda_multi_value_headers_enabled = var.target_type == "lambda" ? var.lambda_multi_value_headers_enabled : null
  load_balancing_algorithm_type      = var.target_group_load_balancing_algorithm_type
  name_prefix                        = var.target_group_name == null ? var.target_group_name_prefix : null
  name                               = var.target_group_name
  port                               = var.target_type == "lambda" ? null : var.target_group_port
  preserve_client_ip                 = var.target_group_protocol == "HTTP" ? null : var.target_group_preserve_client_ip
  protocol_version                   = var.target_group_protocol == "HTTP" || var.target_group_protocol == "HTTPS" ? var.target_group_protocol_version : null
  protocol                           = var.target_type == "lambda" ? null : var.target_group_protocol
  proxy_protocol_v2                  = var.target_group_proxy_protocol_v2
  slow_start                         = var.target_group_slow_start

  ## Max 1 block
  dynamic "stickiness" {
    for_each = length(keys(var.target_group_stickiness)) == 0 ? [] : [var.target_group_stickiness]
    content {
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      cookie_name     = lookup(stickiness.value, "cookie_name", null)
      enabled         = lookup(stickiness.value, "enabled", true)
      type            = stickiness.value.type
    }
  }

  tags        = var.target_group_tags
  target_type = var.target_type
  vpc_id      = var.target_type == "lambda" ? null : var.vpc_id
}
