output "instance_id" {
  value = aws_instance.ec2-nginx.id
}

output "ami_id" {
  value = aws_ami_from_instance.example.id
}
