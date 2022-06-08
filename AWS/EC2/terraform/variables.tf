variable "prefix" {
  default = "Eprank"
}

variable "vpc_cider" {
  default = "10.77.0.0/16"
}


variable "subnet_1_cider" {
  default = "10.77.1.0/24"
}

variable "subnet_2_cider" {
  default = "10.77.2.0/24"
}

variable "subnet_3_cider" {
  default = "10.77.3.0/24"
}

variable "region" {
  default = "us-east-1"
}

variable "inet_cidr" {
  default = "0.0.0.0/0"
}


variable "instance_type" {
  default = "t2.micro"
}

variable "the_key" {
  default = "terra-stok"
}

variable "mykey" {
  default = "/Users/sergey/.ssh/aws_rsa.pub"

}

variable "name" {
  default = "random"
}