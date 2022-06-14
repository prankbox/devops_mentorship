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

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_B
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "UZ-Public-B"
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

resource "aws_route_table" "public_rt_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_internet_gateway.main.id

  }

  tags = {
    Name = "Public-RT-B"
  }

}
########## Public Subnets Associations ##################
resource "aws_route_table_association" "public_rt_a_acn" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt_a.id

}

resource "aws_route_table_association" "public_rt_b_acn" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt_b.id

}
######### GET Elastic IPs ###########################
resource "aws_eip" "public_eip_a" {
  vpc = true
  tags = {
    Name = "Public-EIP-A"
  }
}

resource "aws_eip" "public_eip_b" {
  vpc = true

  tags = {
    Name = "Public-EIP-B"
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

resource "aws_nat_gateway" "nat_gw_public_b" {
  allocation_id = aws_eip.public_eip_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "NAT-GW-Public-B"
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

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_B
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    "Name" = "UZ-Private-B"
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

resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_nat_gateway.nat_gw_public_b.id
  }

  tags = {
    "Name" = "Private-RT-B"
  }

}

########### Private Subnet Associations #########
resource "aws_route_table_association" "private_rt_a_acn" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt_a.id

}

resource "aws_route_table_association" "private_rt_b_acn" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt_b.id

}

############ DB Subnets #############
resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_cidr_A
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    "Name" = "UZ-DB-A"
  }

}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_cidr_B
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    "Name" = "UZ-DB-B"
  }

}

############ DB Route Tables ################
resource "aws_route_table" "db_rt_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "DB-RT-A"
  }

}

resource "aws_route_table" "db_rt_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "DB-RT-B"
  }

}

########## DB Subnet and DB RT associations
resource "aws_route_table_association" "db_rt_a_acn" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.db_rt_a.id

}

resource "aws_route_table_association" "db_rt_b_acn" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.db_rt_b.id

}