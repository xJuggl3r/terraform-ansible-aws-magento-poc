output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "elastic_public_ip" {
  description = "Public EIP address of the EC2 instance"
  value       = aws_eip.example.public_ip
}
