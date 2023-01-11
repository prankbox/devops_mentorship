terraform {
  backend "s3" {
    bucket         = "demo-terraform-states-backend"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-terraform-states-backend"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
     }
    null = {
      source = "hashicorp/null"
      version = "~>0.3"
    }
  }

  required_version = ">= 1.2.0"
}

#Region
provider "aws" {
  region = var.region
}

# Using module myip to secure ssh access
module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Latest amazon linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}-server-key"
  public_key = file(var.mykey)

}

# Main VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cider
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-VPC"
  }
}

#Gateway 1
resource "aws_internet_gateway" "dev_gw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "${var.prefix}-GW"
  }
}

#Subnet 1
resource "aws_subnet" "dev_subnet_1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.subnet_1_cider
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-Subnet-1"
  }
}

#Routing table 1
resource "aws_route_table" "dev_route_table_1" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_internet_gateway.dev_gw.id
  }
  tags = {
    Name = "${var.prefix}-RT-1"
  }
}

# RT association 1
resource "aws_route_table_association" "dev_rt_asc_1" {
  subnet_id      = aws_subnet.dev_subnet_1.id
  route_table_id = aws_route_table.dev_route_table_1.id
}

resource "aws_security_group" "dev_ec2_sg" {
  name   = "dev-sg-EC2"
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${module.myip.address}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.inet_cidr]
  }



  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.inet_cidr]
    prefix_list_ids = []
  }
  tags = {
    "Name" = "${var.prefix}-SG"
  }
}
resource "aws_instance" "prank-amazon-control" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.dev_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.dev_ec2_sg.id]
  availability_zone           = data.aws_availability_zones.available.names[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name
  user_data                   = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Deployed with Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF


  tags = {
    Name = "${var.prefix}-Control-Plane"
  }
}

resource "null_resource" "index" {
  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/www/html/index.html ]; do sleep 5;done",
      "sudo sh -c \"echo '<p> The ip address is: ${aws_instance.prank-amazon-control.public_ip} </p>' >> /var/www/html/index.html\"",
      "sudo sh -c \"echo '<p> The hostname is: ${aws_instance.prank-amazon-control.public_dns} </p>' >> /var/www/html/index.html\""
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.prank-amazon-control.public_ip
      private_key = file(var.ssh_key)
    }


  }
  depends_on = [aws_instance.prank-amazon-control]
}