output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[0].id
}


output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}