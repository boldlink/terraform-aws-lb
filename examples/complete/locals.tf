locals {
  name           = "complete-alb-example"
  cidr_block     = "172.16.0.0/16"
  tag_env        = "Dev"
  public_subnets = cidrsubnets(local.cidr_block, 8, 8, 8)
  azs            = flatten(data.aws_availability_zones.available.names)
}
