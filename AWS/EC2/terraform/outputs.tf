output "ec2_instance" {
  value = aws_instance.prank-amazon-control.public_ip
}