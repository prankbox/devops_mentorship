output "ec2_instance_ip" {
  value = aws_instance.prank-amazon-control.public_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.prank-amazon-control.public_dns
}