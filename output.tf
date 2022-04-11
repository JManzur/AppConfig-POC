# Print EC2 Module Outputs
output "ec2_ssh_command" {
  value       = module.ec2.ec2_ssh_command
  description = "Full SSH command to access the EC2 instance"
}

output "ec2_api_url" {
  value       = module.ec2.ec2_api_url
  description = "URL to access the API running on EC2"
}

# Print Lambda Module Output
output "api-gw_invoke_url" {
  value       = module.lambda.api-gw_invoke_url
  description = "URL to access the API running on Lambda"
}

# Print ECS Module Output
output "fastapi-alb-dns" {
  value       = module.ecs.fastapi-alb-dns
  description = "URL to access the API running on ECS"
}