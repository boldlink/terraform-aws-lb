### Load Balancer
resource "aws_lb" "main" {
  name                             = var.name
  name_prefix                      = var.name_prefix
  internal                         = var.internal
  load_balancer_type               = var.load_balancer_type
  security_groups                  = compact(concat(var.security_groups, [aws_security_group.main.id]))
  subnets                          = var.subnets
  enable_deletion_protection       = var.enable_deletion_protection
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  customer_owned_ipv4_pool         = var.customer_owned_ipv4_pool
  ip_address_type                  = var.ip_address_type
  desync_mitigation_mode           = var.desync_mitigation_mode

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) > 0 ? [var.access_logs] : []
    content {
      bucket  = access_logs.value.bucket
      enabled = lookup(access_logs.value, "enabled", null)
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
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

## WAF Association
resource "aws_wafv2_web_acl_association" "main" {
  count        = var.associate_with_waf ? 1 : 0
  resource_arn = aws_lb.main.arn
  web_acl_arn  = var.web_acl_arn
}

resource "aws_lb_target_group" "main" {
  count                  = length(var.target_groups) > 0 ? length(var.target_groups) : 0
  connection_termination = try(var.target_groups[count.index]["connection_termination"], null)
  deregistration_delay   = try(var.target_groups[count.index]["deregistration_delay"], null)

  dynamic "health_check" {
    for_each = try([var.target_groups[count.index]["health_check"]], [])
    content {
      enabled             = try(health_check.value.enabled, true)
      healthy_threshold   = try(health_check.value.healthy_threshold, 3)
      interval            = try(health_check.value.interval, 30)
      matcher             = try(health_check.value.matcher, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, "traffic-port")
      protocol            = try(health_check.value.protocol, )
      timeout             = try(health_check.value.timeout, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, 3)
    }
  }

  lambda_multi_value_headers_enabled = try(var.target_groups[count.index]["lambda_multi_value_headers_enabled"], null)
  load_balancing_algorithm_type      = try(var.target_groups[count.index]["load_balancing_algorithm_type"], null)
  name_prefix                        = try(var.target_groups[count.index]["name_prefix"], null)
  name                               = try(var.target_groups[count.index]["name"], null)
  port                               = try(var.target_groups[count.index]["port"], null)
  preserve_client_ip                 = try(var.target_groups[count.index]["preserve_client_ip"], null)
  protocol_version                   = try(var.target_groups[count.index]["protocol_version"], null)
  protocol                           = try(var.target_groups[count.index]["protocol"], null)
  vpc_id                             = var.vpc_id
  target_type                        = try(var.target_groups[count.index]["target_type"], null)
  ## Max 1 block
  dynamic "stickiness" {
    for_each = try([var.target_groups[count.index]["stickiness"]], [])
    content {
      cookie_duration = try(stickiness.value.cookie_duration, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
      enabled         = try(stickiness.value.enabled, true)
      type            = stickiness.value.type
    }
  }
  tags = try(var.target_groups[count.index]["tags"], null)
}

resource "aws_lb_target_group_attachment" "main" {
  for_each = { for k, v in var.target_groups : k => v if lookup(v, "create_attachment", false) }

  target_group_arn  = aws_lb_target_group.main[each.key].arn
  target_id         = each.value.target_id
  port              = try(each.value.port, null)
  availability_zone = try(each.value.availability_zone, null)
  depends_on        = [aws_lb_target_group.main]
}

# Listener
resource "aws_lb_listener" "main" {
  count             = length(var.listeners) > 0 ? length(var.listeners) : 0
  load_balancer_arn = aws_lb.main.arn
  port              = lookup(var.listeners[count.index], "port", null)
  protocol          = lookup(var.listeners[count.index], "protocol", null)
  alpn_policy       = lookup(var.listeners[count.index], "alpn_policy", null)
  certificate_arn   = lookup(var.listeners[count.index], "protocol", null) == "HTTPS" || lookup(var.listeners[count.index], "protocol", null) == "TLS" && var.create_ssl_certificate ? join("", aws_acm_certificate.main.*.arn) : lookup(var.listeners[count.index], "certificate_arn", null)
  ssl_policy        = lookup(var.listeners[count.index], "ssl_policy", null)
  tags              = lookup(var.listeners[count.index], "tags", {})
  dynamic "default_action" {
    for_each = length(lookup(var.listeners[count.index], "default_action")) == 0 ? [] : [lookup(var.listeners[count.index], "default_action", {})]

    content {
      type             = default_action.value.type
      target_group_arn = contains([null, "", "forward"], lookup(default_action.value, "type", "")) ? aws_lb_target_group.main[lookup(default_action.value, "tg_index", count.index)].id : null

      dynamic "authenticate_oidc" {
        for_each = length(lookup(default_action.value, "authenticate_oidc", {})) == 0 ? [] : [lookup(default_action.value, "authenticate_oidc", {})]

        content {
          # Max 10 extra params
          authentication_request_extra_params = lookup(authenticate_oidc.value, "authentication_request_extra_params", null)
          authorization_endpoint              = authenticate_oidc.value["authorization_endpoint"]
          client_id                           = authenticate_oidc.value["client_id"]
          client_secret                       = authenticate_oidc.value["client_secret"]
          issuer                              = authenticate_oidc.value["issuer"]
          token_endpoint                      = authenticate_oidc.value["token_endpoint"]
          user_info_endpoint                  = authenticate_oidc.value["user_info_endpoint"]
          on_unauthenticated_request          = lookup(authenticate_oidc.value, "on_unauthenticated_request", null)
          scope                               = lookup(authenticate_oidc.value, "scope", null)
          session_cookie_name                 = lookup(authenticate_oidc.value, "session_cookie_name", null)
          session_timeout                     = lookup(authenticate_oidc.value, "session_timeout", null)
        }
      }

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }

      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]

        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      ## For HTTPS listeners only
      dynamic "authenticate_cognito" {
        for_each = length(keys(lookup(default_action.value, "authenticate_cognito", {}))) == 0 ? [] : [lookup(default_action.value, "authenticate_cognito", {})]

        content {
          # Max 10 extra params
          authentication_request_extra_params = lookup(authenticate_cognito.value, "authentication_request_extra_params", null)
          on_unauthenticated_request          = lookup(authenticate_cognito.value, "on_authenticated_request", null)
          scope                               = lookup(authenticate_cognito.value, "scope", null)
          session_cookie_name                 = lookup(authenticate_cognito.value, "session_cookie_name", null)
          session_timeout                     = lookup(authenticate_cognito.value, "session_timeout", null)
          user_pool_arn                       = authenticate_cognito.value["user_pool_arn"]
          user_pool_client_id                 = authenticate_cognito.value["user_pool_client_id"]
          user_pool_domain                    = authenticate_cognito.value["user_pool_domain"]
        }
      }
    }
  }
}

#### Self Signed Certificate
resource "tls_private_key" "main" {
  count     = var.create_ssl_certificate ? 1 : 0
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "main" {
  count           = var.create_ssl_certificate ? 1 : 0
  private_key_pem = tls_private_key.main[0].private_key_pem

  subject {
    common_name  = var.cert_common_name
    organization = var.cert_organization
  }

  validity_period_hours = var.cert_validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "main" {
  count            = var.create_ssl_certificate ? 1 : 0
  private_key      = tls_private_key.main[0].private_key_pem
  certificate_body = tls_self_signed_cert.main[0].cert_pem
  lifecycle {
    create_before_destroy = true
  }
}


# Security group
resource "aws_security_group" "main" {
  name        = "${var.name}-security-group"
  vpc_id      = var.vpc_id
  description = "Load balancer security group"
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ingress" {
  for_each          = var.ingress_rules
  type              = "ingress"
  description       = "Allow custom inbound traffic from specific ports."
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  cidr_blocks       = lookup(each.value, "cidr_blocks", [])
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress" {
  for_each          = var.egress_rules
  type              = "egress"
  description       = "Allow custom egress traffic"
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")
  protocol          = "-1"
  cidr_blocks       = lookup(each.value, "cidr_blocks", [])
  security_group_id = aws_security_group.main.id
}
