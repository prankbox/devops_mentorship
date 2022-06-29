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

resource "aws_key_pair" "ssh_key" {
  key_name   = "Server-key"
  public_key = file(var.mykey)

}