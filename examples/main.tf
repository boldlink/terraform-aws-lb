provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

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

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

module "alb" {
  source = "../"

  name               = "${random_string.random.id}-alb"
  load_balancer_type = "application"
  internal           = true
  subnets            = data.aws_subnets.default.ids
  security_groups    = [data.aws_security_group.default.id]
}
output "outputs" {
  value = [
    module.alb,
  ]
}


