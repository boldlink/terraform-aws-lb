locals {
  name                      = "minimum-alb-example"
  service_account           = data.aws_elb_service_account.main.arn
  public_subnets            = local.public_subnet_id
  supporting_resources_name = "terraform-aws-lb"
  vpc_id                    = data.aws_vpc.supporting.id

  public_subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  tags = {
    Environment        = "examples"
    "user::CostCenter" = "terraform-registry"
    department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}
