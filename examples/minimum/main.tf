module "minimum" {
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  source                     = "../../"
  name                       = local.name
  internal                   = false
  enable_deletion_protection = false
  vpc_id                     = local.vpc_id
  subnets                    = local.public_subnets
  ingress_rules = {
    https = {
      description = "allow tls"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    http = {
      description = "allow http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
