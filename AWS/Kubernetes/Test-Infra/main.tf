terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_availability_zones" "available" {}

resource "aws_key_pair" "ssh_key" {
  key_name   = "Server-key"
  public_key = file(var.AWS_SSH_KEY_NAME)

}


data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"] # Debian-10
}

data "template_file" "inventory" {
  template = file("${path.module}/templates/inventory.tpl")

  vars = {
    public_ip_address_bastion = join("\n", formatlist("bastion ansible_host=%s", aws_instance.bastion-server.*.public_ip))
    bastion_ip                = join("\n", aws_instance.bastion-server.*.public_ip)
    connection_strings_master = join("\n", formatlist("%s ansible_host=%s", aws_instance.k8s-master.*.private_dns, aws_instance.k8s-master.*.private_ip))
    connection_strings_node   = join("\n", formatlist("%s ansible_host=%s", aws_instance.k8s-worker.*.private_dns, aws_instance.k8s-worker.*.private_ip))
    list_master               = join("\n", aws_instance.k8s-master.*.private_dns)
    list_node                 = join("\n", aws_instance.k8s-worker.*.private_dns)
    connection_strings_etcd   = join("\n", formatlist("%s ansible_host=%s", aws_instance.k8s-etcd.*.private_dns, aws_instance.k8s-etcd.*.private_ip))
    list_etcd                 = join("\n", ((var.aws_etcd_num > 0) ? (aws_instance.k8s-etcd.*.private_dns) : (aws_instance.k8s-master.*.private_dns)))
    nlb_api_fqdn              = "apiserver_loadbalancer_domain_name=\"${module.aws-nlb.aws_nlb_api_fqdn}\""
  }
}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ${var.inventory_file}"
  }

  triggers = {
    template = data.template_file.inventory.rendered
  }
}