terraform {
  required_version = ">= 0.14.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.2.0"
    }
  }
}
