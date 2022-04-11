##########################################
### Target Group
##########################################

resource "aws_lb_target_group" "main" {
  connection_termination = var.connection_termination
  deregistration_delay   = var.deregistration_delay

  ## Max 1 Block
  dynamic "health_check" {
    for_each = length(keys(var.health_check)) == 0 ? [] : [var.health_check]
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
  load_balancing_algorithm_type      = var.load_balancing_algorithm_type
  name_prefix                        = var.name == null ? var.name_prefix : null
  name                               = var.name
  port                               = var.target_type == "lambda" ? null : var.port
  preserve_client_ip                 = var.protocol == "HTTP" ? null : var.preserve_client_ip
  protocol_version                   = var.protocol == "HTTP" || var.protocol == "HTTPS" ? var.protocol_version : null
  protocol                           = var.target_type == "lambda" ? null : var.protocol
  proxy_protocol_v2                  = var.proxy_protocol_v2
  slow_start                         = var.slow_start

  ## Max 1 block
  dynamic "stickiness" {
    for_each = length(keys(var.stickiness)) == 0 ? [] : [var.stickiness]
    content {
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      cookie_name     = lookup(stickiness.value, "cookie_name", null)
      enabled         = lookup(stickiness.value, "enabled", true)
      type            = stickiness.value.type
    }
  }

  tags        = var.tags
  target_type = var.target_type
  vpc_id      = var.target_type == "lambda" ? null : var.vpc_id
}

resource "aws_lb_listener" "main" {
  count             = length(var.listeners) > 0 ? length(var.listeners) : 0
  load_balancer_arn = lookup(var.listeners[count.index], "load_balancer_arn", null)
  port              = lookup(var.listeners[count.index], "port", null)
  protocol          = lookup(var.listeners[count.index], "protocol", null)
  alpn_policy       = lookup(var.listeners[count.index], "alpn_policy", null)
  certificate_arn   = lookup(var.listeners[count.index], "certificate_arn", null)
  ssl_policy        = lookup(var.listeners[count.index], "ssl_policy", null)
  tags              = lookup(var.listeners[count.index], "tags", {})
  dynamic "default_action" {
    for_each = length(keys(lookup(var.listeners[count.index], "default_action", {}))) == 0 ? [] : [lookup(var.listeners[count.index], "default_action", {})]

    content {
      type             = lookup(default_action.value, "type", "forward")
      target_group_arn = contains([null, "", "forward"], lookup(default_action.value, "type", "")) ? aws_lb_target_group.main.id : null

      dynamic "authenticate_oidc" {
        for_each = length(keys(lookup(default_action.value, "authenticate_oidc", {}))) == 0 ? [] : [lookup(default_action.value, "authenticate_oidc", {})]

        content {
          # Max 10 extra params
          authentication_request_extra_params = lookup(authenticate_oidc.value, "authentication_request_extra_params", null)
          authorization_endpoint              = authenticate_oidc.value["authorization_endpoint"]
          client_id                           = authenticate_oidc.value["client_id"]
          client_secret                       = authenticate_oidc.value["client_secret"]
          issuer                              = authenticate_oidc.value["issuer"]
          on_unauthenticated_request          = lookup(authenticate_oidc.value, "on_unauthenticated_request", null)
          scope                               = lookup(authenticate_oidc.value, "scope", null)
          session_cookie_name                 = lookup(authenticate_oidc.value, "session_cookie_name", null)
          session_timeout                     = lookup(authenticate_oidc.value, "session_timeout", null)
          token_endpoint                      = authenticate_oidc.value["token_endpoint"]
          user_info_endpoint                  = authenticate_oidc.value["user_info_endpoint"]
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

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
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
