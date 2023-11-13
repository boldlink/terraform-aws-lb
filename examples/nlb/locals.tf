locals {
  public_subnets = local.public_subnet_id
  vpc_id         = data.aws_vpc.supporting.id
  tags           = merge({ "Name" = var.name }, var.tags)

  public_subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]
}
