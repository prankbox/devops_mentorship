resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cider
  enable_dns_hostnames = true
  tags = {
    "Name" = "Main-VPC"
  }

}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "Main-GW"
  }

}
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    "Name" = "Public-Subnet-A"
  }

}

resource "aws_route_table" "public_rt_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    "Name" = "Public-RT-A"
  }

}

resource "aws_route_table_association" "pub_rt_a_acnx" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt_a.id

}

resource "aws_security_group" "public_a_sg" {
  name   = "Public-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh access"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Public-SG"
  }

}