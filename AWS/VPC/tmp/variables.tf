variable "vpcs" {
    type = map(object({
        cidr = string
        tags = map(string)
        tenancy = string
    }))
    default = {
      "RU" = {
        cidr = "10.0.0.0/16"
        tags = {
          "Name" = "RU-VPC"
        }
        tenancy = "default"
      }
      "UZ" = {
        cidr = "192.168.0.0/16"
        tags = {
          "Name" = "UZ-VPC"
        }
        tenancy = "default"
      }
    }
  
}

variable "subnets" {
    type = map(object({
        cidr = string
        az = string
        tags = map(string)
    }))
    default = {
      "Public-A" = {
        az = "us-east-1a"
        cidr = "10.0.1.0/24"
        tags = {
          "Name" = "Public-A"
        }
      }
      "Public-B" = {
        az = "us-east-1b"
        cidr = "10.0.2.0/24"
        tags = {
          "Name" = "Public-B"
        }
      }
    }
  
}