# Print EC2 Module Outputs
output "ec2_ssh_command" {
  value       = module.ec2.ec2_ssh_command
  description = "Full SSH command to access the instance"
}

output "ec2_api_url" {
  value       = module.ec2.ec2_api_url
  description = "Public IP + Port to access the API running on the EC2"
}

# Print Lambda Module Outputs
output "api-gw_invoke_url" {
  value       = module.lambda.api-gw_invoke_url
  description = "API Gateway Invoke URL"
}