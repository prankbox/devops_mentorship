variable "cluster_name" {
  default = "demo"
}

variable "cluster_version" {
  default = "1.22"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cider" {
  type = string
  description = "main vpc cider block"
  default = "10.0.0.0/16"
}