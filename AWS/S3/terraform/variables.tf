variable "prefix" {
  default = "S3-EC2-IAM"
}

variable "vpc_cider" {
  default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.20.2.0/24"
}

variable "region" {
  default = "us-east-1"
}

variable "mykey" {
  type = string

}

variable "ssh_key" {
  type = string

}

variable "s3_bucket" {
  type    = string
  default = "pranktool"
}

variable "instance_type" {
  default = "t2.micro"
}