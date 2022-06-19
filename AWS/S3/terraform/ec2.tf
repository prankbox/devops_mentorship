
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
  subnet_id                   = aws_subnet.public_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.public_a_sg.id]
  availability_zone           = data.aws_availability_zones.available.names[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "${var.prefix}-Control-Plane"
  }
  depends_on = [
    aws_s3_bucket.bucket
  ]
}

resource "null_resource" "check_connection" {

  provisioner "remote-exec" {
    inline = [
      "echo \"Checking connection...\"",
      "sudo amazon-linux-extras install epel -y",
      "sudo yum update -y",
      "sudo yum install s3fs-fuse nginx -y",
      "sudo chown -R nginx /var/log/nginx",
      "sudo echo \"s3fs#${local.s3_bucket_name} /var/log/nginx fuse _netdev,iam_role=S3Full,noatime,sync,allow_other,umask=227,uid=995,gid=993,use_cache=/tmp/cache 0 0\" |sudo tee -a /etc/fstab",
      #"sudo s3fs ${local.s3_bucket_name} /var/log/nginx -o iam_role=S3Full -o allow_other -o use_cache=/tmp/cache",
      "sudo mount -a",
      "sudo systemctl enable nginx --now"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.control_plane.public_ip
      private_key = file(var.ssh_key)
    }


  }
  depends_on = [aws_instance.control_plane]
}