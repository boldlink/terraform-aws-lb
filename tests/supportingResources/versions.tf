terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.30.0"
    }
  }
  required_version = ">= 0.14.11"
}