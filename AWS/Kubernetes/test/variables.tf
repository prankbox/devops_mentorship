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


variable "private_cidr_A" {
  type    = string
  default = "10.0.11.0/24"

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

variable "ports" {
  type = map(number)
  default = {
    "http"  = "80"
    "https" = "443"
    "tcp"   = "6443"
  }
}

variable "inst_count" {
  type    = number
  default = 2
}

