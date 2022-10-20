locals {
  name                      = "minimum-alb-example"
  public_subnets            = local.public_subnet_id
  supporting_resources_name = "terraform-aws-lb"
  vpc_id                    = data.aws_vpc.supporting.id

  public_subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]
}
