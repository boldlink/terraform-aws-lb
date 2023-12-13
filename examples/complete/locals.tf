locals {
  service_account = data.aws_elb_service_account.main.arn
  public_subnets  = local.public_subnet_id
  vpc_id          = data.aws_vpc.supporting.id
  region          = data.aws_region.current.name
  domain          = aws_cognito_user_pool_domain.domain.domain
  tags            = merge({ "Name" = var.name }, var.tags)

  public_subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]
}
