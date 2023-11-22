module "virtual_appliance" {
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
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [local.vpc_cidr]
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

module "gateway_lb" {
  #checkov:skip=CKV_AWS_150 #"Ensure that Load Balancer has deletion protection enabled"
  source                           = "../../"
  name                             = var.name
  load_balancer_type               = "gateway"
  internal                         = false
  subnets                          = local.private_subnets
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = true
  idle_timeout                     = 60
  ip_address_type                  = "ipv4"
  vpc_id                           = local.vpc_id

  # Listeners for Gateway Load Balancers listen for all IP packets across all ports. You cannot specify a protocol or port when you create a listener for a Gateway Load Balancer.
  listeners = [
    {
      default_action = {
        type     = "forward"
        tg_index = 0
      }
    }
  ]

  target_groups = [
    {
      name     = "geneve-${var.name}"
      port     = 6081
      protocol = "GENEVE"

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        port                = 80
        protocol            = "TCP"
        timeout             = 5
        unhealthy_threshold = 3
      }

      #targets
      target_id         = module.virtual_appliance[0].id
      target_type       = "instance"
      create_attachment = true
      tags              = local.tags
    }
  ]
}

resource "aws_vpc_endpoint_service" "endpointservice" {
  acceptance_required        = true
  gateway_load_balancer_arns = [module.gateway_lb.lb_id]
  depends_on                 = [module.gateway_lb]
  tags                       = local.tags
}

resource "aws_vpc_endpoint" "endpoint" {
  service_name      = aws_vpc_endpoint_service.endpointservice.service_name
  vpc_endpoint_type = aws_vpc_endpoint_service.endpointservice.service_type
  subnet_ids        = [local.private_subnets[0]]
  vpc_id            = local.vpc_id
  tags              = local.tags
}
