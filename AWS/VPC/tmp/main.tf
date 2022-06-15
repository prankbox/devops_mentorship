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


resource "aws_vpc" "main" {
    for_each = var.vpcs
    cidr_block = each.value["cidr"]
    instance_tenancy = each.value["tenancy"]
    tags = each.value["tags"]
  
}

resource "aws_internet_gateway" "main" {
    for_each = aws_vpc.main
    vpc_id = each.value.id
    tags = {
      "Name" = "${each.key}-IGW"
    }
  
}

resource "aws_subnet" "public" {

  
}

