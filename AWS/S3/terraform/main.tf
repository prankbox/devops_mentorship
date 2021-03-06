terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

#Region
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

