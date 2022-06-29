############# VPC ###################
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = "UZ-VPC"
  }
}
############ Internet Gateway #################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "UZ-IGW"
  }


}
############# Public Subnets ####################
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_A
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "UZ-Public-A"
  }

}

############## Public Route Tables ##############
resource "aws_route_table" "public_rt_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_internet_gateway.main.id

  }

  tags = {
    Name = "Public-RT-A"
  }

}


########## Public Subnets Associations ##################
resource "aws_route_table_association" "public_rt_a_acn" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt_a.id

}


######### GET Elastic IPs ###########################
resource "aws_eip" "public_eip_a" {
  vpc = true
  tags = {
    Name = "Public-EIP-A"
  }
}


############## NAT Gateways #########################
resource "aws_nat_gateway" "nat_gw_public_a" {
  allocation_id = aws_eip.public_eip_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "NAT-GW-Public-A"
  }

}


########## Private Subnets #######################
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_A
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    "Name" = "UZ-Private-A"
  }

}


############# Private Route Tables ###################
resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_nat_gateway.nat_gw_public_a.id
  }

  tags = {
    "Name" = "Private-RT-A"
  }

}



########### Private Subnet Associations #########
resource "aws_route_table_association" "private_rt_a_acn" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt_a.id

}

############# Public SG ####################
resource "aws_security_group" "public_sg" {
  name   = "UZ-Public-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    "Name" = "UZ-Public-SG"
  }
}