module "ec2_instances" {
  source            = "boldlink/ec2/aws"
  version           = "2.0.4"
  count             = 1
  name              = "${var.name}-${count.index}"
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t3.small"
  monitoring        = true
  ebs_optimized     = true
  vpc_id            = local.vpc_id
  availability_zone = local.private_sub_azs[count.index % length(local.private_sub_azs)]
  subnet_id         = local.private_subnets[count.index % length(local.private_subnets)]
  tags              = merge({ "Name" = "${var.name}-${count.index}" }, var.tags)
  root_block_device = var.root_block_device
  extra_script      = templatefile("${path.module}/httpd.sh", {})
  install_ssm_agent = true

  security_group_ingress = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = [module.complete.sg_id]
    }
  ]

  security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

}

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
  source                           = "../../"
  name                             = var.name
  internal                         = var.internal
  subnets                          = local.public_subnets
  vpc_id                           = local.vpc_id
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = true
  create_ssl_certificate           = var.create_ssl_certificate
  tags                             = local.tags
  listeners                        = var.listeners_configuration

  target_groups = [
    {
      name     = "tcp-${var.name}1"
      port     = 80
      protocol = "HTTP"

      stickiness = {
        cookie_duration = 3600
        enabled         = true
        type            = "lb_cookie"
      }

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

      #targets
      target_id         = module.ec2_instances[0].id
      target_type       = "instance"
      create_attachment = true
    }
  ]

  timeouts = {
    create = "7m"
    update = "7m"
    delete = "7m"
  }

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
  vpc_id                     = local.vpc_id
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = local.tags
  subnets                    = local.public_subnets

  # We recommend you use `var.subnets` as a best practice.
  subnet_mappings = [
    {
      subnet_id = local.public_subnets[0]
    },
    {
      subnet_id = local.public_subnets[1]
      #private_ipv4_address = "10.0.2.15" # not supported for application load balancer
    }
  ]

  listeners = [
    {
      port     = "80"
      protocol = "HTTP"

      default_actions = [
        {
          type = "redirect"

          redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }
        }
      ]
    },
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
            user_pool_domain    = local.domain
          }
        },
        {
          type     = "forward"
          tg_index = 0
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
}

module "authenticate_oidc" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_2: "Ensure ALB protocol is HTTPS"
  source                     = "../../"
  name                       = "${var.name}-oidc"
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
          type = "authenticate-oidc"

          authenticate_oidc = {
            authorization_endpoint = "https://${local.domain}.auth.${local.region}.amazoncognito.com/oauth2/authorize"
            client_id              = aws_cognito_user_pool_client.client.id
            client_secret          = aws_cognito_user_pool_client.client.client_secret
            issuer                 = "https://${aws_cognito_user_pool.pool.endpoint}"
            token_endpoint         = "https://${local.domain}.auth.${local.region}.amazoncognito.com/oauth2/token"
            user_info_endpoint     = "https://${local.domain}.auth.${local.region}.amazoncognito.com/oauth2/userInfo"
          }
        },
        {
          type     = "forward"
          tg_index = 0
        }
      ]
    }
  ]

  target_groups = [
    {
      name     = "oidc-${var.name}"
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
}
