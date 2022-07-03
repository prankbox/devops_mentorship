data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "control_plane" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.small"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name
  user_data                   = file("scripts/init.sh")

  tags = {
    "Name" = "UZ-Control-Plane-${count.index + 1}",
    "Role" = "Master"
  }
}

resource "aws_instance" "workers" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name
  user_data                   = file("scripts/init.sh")
  tags = {
    "Name" = "UZ-Worker-${count.index + 1}",
    "Role" = "Worker"
  }
}