locals {
  tags            = merge({ "Name" = var.name }, var.tags)
  private_subnets = flatten(local.private_subnet_id)
  vpc_id          = data.aws_vpc.supporting.id
  vpc_cidr        = data.aws_vpc.supporting.cidr_block
  private_sub_azs = flatten(local.subnet_azs)

  private_subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]

  subnet_azs = [
    for i in data.aws_subnet.private : i.availability_zone
  ]
}
