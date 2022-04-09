output "ec2_ssh_command" {
  value = "sudo ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.poc-ec2.public_ip}"
}

output "ec2_api_url" {
  value = "http://${aws_instance.poc-ec2.public_ip}:8080/"
}