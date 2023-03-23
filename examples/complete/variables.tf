variable "name" {
  type        = string
  description = "Name of the stack"
  default     = "complete-alb-example"
}

variable "supporting_resources_name" {
  type        = string
  description = "Name of the supporting resources"
  default     = "terraform-aws-lb"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default = {
    Environment        = "examples"
    "user::CostCenter" = "terraform-registry"
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}

variable "force_destroy" {
  type        = bool
  description = "Whether to force deletion of the s3 bucket"
  default     = true
}

variable "internal" {
  type        = bool
  description = "Whether the created LB is internal or not"
  default     = false
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether to protect LB from deletion"
  default     = false
}

variable "access_logs_enabled" {
  type        = bool
  description = "Whether access logs are enabled for the load balancer"
  default     = true
}

variable "https_ingress" {
  type        = any
  description = "The ingress configuration for lb security group https rule"
  default = {
    description = "allow tls"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "http_ingress" {
  type        = any
  description = "The ingress configuration for lb security group http rule"
  default = {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "egress_rules" {
  type        = any
  description = "The egress configuration for outgoing lb traffic"
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "create_ssl_certificate" {
  type        = bool
  description = "Whether to create ssl certificate with the module"
  default     = true
}

variable "target_group_configuration" {
  type        = any
  description = "Configuration block for target group"
  default = [
    {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
      stickiness = {
        cookie_duration = 3600
        enabled         = true
        type            = "lb_cookie"
      }
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
    }
  ]
}

variable "listeners_configuration" {
  type        = any
  description = "Configuration block for listeners"
  default = [
    {
      port     = 443
      protocol = "HTTPS"
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
      default_action = {
        type     = "forward"
        tg_index = 0
      }
      port     = 80
      protocol = "HTTP"
    }
  ]
}
