locals {
  service_account = data.aws_elb_service_account.main.arn
  public_subnets  = local.public_subnet_id
  private_subnets = flatten(local.private_subnet_id)
  vpc_id          = data.aws_vpc.supporting.id
  region          = data.aws_region.current.name
  domain          = aws_cognito_user_pool_domain.domain.domain
  tags            = merge({ "Name" = var.name }, var.tags)
  private_sub_azs = flatten(local.subnet_azs)

  public_subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  private_subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]

  subnet_azs = [
    for i in data.aws_subnet.private : i.availability_zone
  ]
}
