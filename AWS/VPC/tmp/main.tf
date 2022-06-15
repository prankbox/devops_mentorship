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

locals {

  flat_subnets = merge([
        for vpck, vpcv in var.vpcs: {
          for subnetk, subnetv in var.subnets[vpck]: 
            "${vpck}-${subnetk}" => {
                vpc_key = vpck
                subnet = subnetv
            }
          }
      ]...)

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
    for_each = local.flat_subnets
    
    vpc_id     = aws_vpc.main[each.value.vpc_key].id
    cidr_block = each.value.subnet.cidr
    availability_zone = each.value.subnet.az
    
    tags = each.value.subnet.tags
}

