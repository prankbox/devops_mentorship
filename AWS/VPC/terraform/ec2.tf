data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "Bastion-server-key"
  public_key = file(var.mykey)

}

resource "aws_security_group" "public_sg" {
  name   = "UZ-Public-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "bastion_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name

  tags = {
    "Name" = "UZ-Bastion"
  }
}

resource "aws_instance" "private_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_a.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = aws_key_pair.ssh_key.key_name

  tags = {
    "Name" = "UZ-Private-A-Server"
  }
}

resource "aws_instance" "db_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.db_b.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = aws_key_pair.ssh_key.key_name

  tags = {
    "Name" = "UZ-DB-B-Server"
  }
}