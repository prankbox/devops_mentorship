variable "prefix" {
  type = string
  default = "Dev"
}

variable "vpc_cider" {
  type = string
  default = "10.77.0.0/16"
}


variable "subnet_1_cider" {
  type = string
  default = "10.77.1.0/24"
}

variable "subnet_2_cider" {
  type = string
  default = "10.77.2.0/24"
}

variable "subnet_3_cider" {
  type = string
  default = "10.77.3.0/24"
}

variable "region" {
  type = string
  default = "us-west-2"
}

variable "inet_cidr" {
  type = string
  default = "0.0.0.0/0"
}


variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "the_key" {
  type = string
  default = "terra-stok"
}

variable "mykey" {
  type = string

}

variable "ssh_key" {
  type = string

}

variable "name" {
  type = string
  default = "random"
}