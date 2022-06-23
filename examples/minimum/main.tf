data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

module "minimum" {
  source          = "../.."
  name            = "minimum-example-lb"
  internal        = false
  subnets         = data.aws_subnets.default.ids
  security_groups = [data.aws_security_group.default.id]
}
