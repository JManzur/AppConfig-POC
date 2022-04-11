output "fastapi-alb-dns" {
  value = "http://${aws_lb.fastapi-demo-alb.dns_name}:8082"
}