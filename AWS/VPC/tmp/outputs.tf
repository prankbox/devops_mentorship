output "vpcs" {
  value = {
    for k,v in aws_vpc.main: k => v.id
  }
}