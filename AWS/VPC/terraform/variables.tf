variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"

}

variable "region" {
  type    = string
  default = "us-east-1"

}

variable "public_cidr_A" {
  type    = string
  default = "10.0.1.0/24"

}

variable "public_cidr_B" {
  type    = string
  default = "10.0.2.0/24"

}

variable "private_cidr_A" {
  type    = string
  default = "10.0.11.0/24"

}

variable "private_cidr_B" {
  type    = string
  default = "10.0.12.0/24"

}

variable "db_cidr_A" {
  type    = string
  default = "10.0.21.0/24"

}

variable "db_cidr_B" {
  type    = string
  default = "10.0.22.0/24"

}

variable "inet_cidr" {
  type    = string
  default = "0.0.0.0/0"

}
variable "mykey" {
  type = string

}

variable "ssh_key" {
  type = string

}
