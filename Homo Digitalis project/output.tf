output "nat_gateway_ip" {
  value = aws_eip.nat_gateway_eip.public_ip
  
}