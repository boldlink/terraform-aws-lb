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
      security_groups = [aws_security_group.nlb.id]
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

module "nlb" {
  #checkov:skip=CKV_AWS_150 #"Ensure that Load Balancer has deletion protection enabled"
  source                           = "../../"
  name                             = var.name
  load_balancer_type               = "network"
  internal                         = false
  subnets                          = local.public_subnets
  enable_deletion_protection       = var.enable_deletion_protection
  security_groups                  = [aws_security_group.nlb.id]
  idle_timeout                     = 60
  enable_cross_zone_load_balancing = true
  ip_address_type                  = "ipv4"
  vpc_id                           = local.vpc_id

  listeners = [
    {
      default_actions = [
        {
          type     = "forward"
          tg_index = 0
        }
      ]

      port     = 53
      protocol = "UDP"
    },
    {
      port     = 80
      protocol = "TCP"

      default_actions = [
        {
          type     = "forward"
          tg_index = 1
        }
      ]
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

      #targets
      target_id         = module.ec2_instances[0].id
      target_type       = "instance"
      create_attachment = true

      preserve_client_ip = true
      protocol_version   = "HTTP1"
      tags               = local.tags
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
