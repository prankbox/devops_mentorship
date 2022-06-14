terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_availability_zones" "available" {
  state = "available"
}
module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}