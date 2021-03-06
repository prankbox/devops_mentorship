## Notes
- `VPC` - CIDR blocks (can be many)
- `Public Subnet` - part of a VPC that has public IP Adresses
- `Private Subnet` -  part of a VPC that has no public IP, but still can access the internet through a NAT Gateway.
- `Database Subnet` - part of a VPC that has no public IP, no NAT Gateway and no access to the internet. Completely isolated and private.
- `Route Table` - attached to a Subnet.
- `Internet Gateway` - attached to a VPC to get access to the internet.
- `NAT Gateway` - service that instances in private subnets can use to connect to services in other VPCs, on-premises networks, or the internet.
- `Security Group` - A security group acts as a virtual firewall that controls the traffic for one or more instances. Statefull (in and out same rule).
- `Network Access Control List (NACL)` - is an optional layer of security for your VPC that acts as a firewall for controlling traffic in and out of one or more subnets. Stateless (in and out rules may be different). Can be used to deny hosts, ips.
- `Bastion Host` - or jump server. Used to get access to resources in private subnets.
- `VPC Flow Logs` - for logging VPC traffic
- `VPC Peering` - is a networking connection between two VPCs that enables you to route traffic between them privately. Instances in either VPC can communicate with each other as if they are within the same network. You can create a VPC peering connection between your own VPCs, with a VPC in another AWS account, or with a VPC in a different AWS Region.
- `VPN Gateway` - a virtual private gateway is the VPN concentrator on the Amazon side of the site-to-site VPN connection. You create a virtual private gateway and attach it to the VPC you want to use for the site-to-site VPN connection.