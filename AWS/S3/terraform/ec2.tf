
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}-server-key"
  public_key = file(var.mykey)

}

data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}




resource "aws_instance" "control_plane" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.dev_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.dev_ec2_sg.id]
  availability_zone           = data.aws_availability_zones.available.names[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name
#   user_data                   = <<EOF
#     #!/bin/bash
#     sudo yum update -y
#     sudo yum install httpd -y
#     sudo systemctl start httpd
#     sudo systemctl enable httpd
#     echo "<h1>Deployed with Terraform</h1>" | sudo tee /var/www/html/index.html
#   EOF


  tags = {
    Name = "${var.prefix}-Control-Plane"
  }
}

resource "null_resource" "check_connection" {

  provisioner "remote-exec" {
 
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.control_plane.public_ip
      private_key = file(var.ssh_key)
    }


  }
  depends_on = [aws_instance.control_plane]
}