resource "aws_security_group" "alb" {
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
  name        = "${var.name}-external-security-group"
  description = "Allow lb inbound traffic"
  vpc_id      = local.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.alb.id
  description       = "Rule to allow all http traffic to the alb"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  security_group_id = aws_security_group.alb.id
  description       = "Rule to allow all http traffic to the alb"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Rule to allow all http traffic from the alb"
  ip_protocol       = "-1"
}
