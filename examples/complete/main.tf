module "access_logs_s3" {
  source        = "boldlink/s3/aws"
  bucket        = var.name
  bucket_policy = data.aws_iam_policy_document.s3.json
  force_destroy = var.force_destroy
  tags          = local.tags
}

module "complete" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_2: "Ensure ALB protocol is HTTPS"
  source                     = "../../"
  name                       = var.name
  internal                   = var.internal
  subnets                    = local.public_subnets
  vpc_id                     = local.vpc_id
  enable_deletion_protection = var.enable_deletion_protection
  create_ssl_certificate     = var.create_ssl_certificate
  tags                       = local.tags
  target_groups              = var.target_group_configuration
  listeners                  = var.listeners_configuration

  # WAF association
  associate_with_waf = true
  web_acl_arn        = module.waf.arn

  access_logs = {
    bucket  = module.access_logs_s3.bucket
    enabled = var.access_logs_enabled
  }

  ingress_rules = {
    https = var.https_ingress
    http  = var.http_ingress
  }

  egress_rules = {
    default = var.egress_rules
  }
}

resource "aws_cognito_user_pool" "pool" {
  name = var.name
}

resource "aws_cognito_user_pool_client" "client" {
  name            = "${var.name}-client"
  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = true # This generates a client secret

  # Other client configuration options
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["https://boldlink-example.com/callback"]
  logout_urls                          = ["https://boldlink-example.com/logout"]
  supported_identity_providers         = ["COGNITO"]
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "main" {
  private_key_pem = tls_private_key.main.private_key_pem

  subject {
    common_name  = "boldlink.io"
    organization = "Boldlink-SIG"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "main" {
  private_key      = tls_private_key.main.private_key_pem
  certificate_body = tls_self_signed_cert.main.cert_pem
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "boldlink-example-domain"
  user_pool_id = aws_cognito_user_pool.pool.id
}

module "authenticate_cognito" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_2: "Ensure ALB protocol is HTTPS"
  source                     = "../../"
  name                       = "${var.name}-cognito"
  internal                   = var.internal
  subnets                    = local.public_subnets
  vpc_id                     = local.vpc_id
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = local.tags

  listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.main.arn

      default_actions = [
        {
          type = "authenticate-cognito"

          authenticate_cognito = {
            user_pool_arn       = aws_cognito_user_pool.pool.arn
            user_pool_client_id = aws_cognito_user_pool_client.client.id
            user_pool_domain    = aws_cognito_user_pool_domain.domain.domain
          }
        },
        {
          type     = "forward"
          tg_index = 0
        }
      ]
    },
    {
      port = 80

      default_actions = [
        {
          type  = "fixed-response"
          order = 1

          fixed_response = {
            content_type = "text/plain"
            message_body = "This is a fixed response."
            status_code  = "200"
          }
        }
      ]
    }
  ]

  target_groups = [
    {
      name     = "http-${var.name}"
      port     = 80
      protocol = "HTTP"

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
      tags = local.tags
    }
  ]

  ingress_rules = {
    https = var.https_ingress
    http  = var.http_ingress
  }

  egress_rules = {
    default = var.egress_rules
  }

  depends_on = [
    aws_cognito_user_pool.pool,
    aws_cognito_user_pool_client.client,
    aws_cognito_user_pool_domain.domain
  ]
}
