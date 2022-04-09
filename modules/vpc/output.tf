output "vpc_id" {
  value       = aws_vpc.poc_vpc.id
  description = "VPC ID"
}

output "public_subnet" {
  value       = aws_subnet.poc_public.id
  description = "Public Subnet ID"
}

output "private_subnet" {
  value       = aws_subnet.poc_private.id
  description = "Private Subnet ID"
}