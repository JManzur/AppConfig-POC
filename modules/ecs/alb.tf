# #Application Load Balancer (ALB): Internet > fastapi-Demo ECS
# resource "aws_alb" "fastapi-demo-alb" {
#   name               = "fastapi-demo-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.fastapi-demo-sg.id]
#   subnets            = [aws_subnet.poc_public.id]

#   tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-alb" }, )
# }

# #ALB Target
# resource "aws_alb_target_group" "fastapi-demo-tg" {
#   name        = "fastapi-demo-tg"
#   port        = 8082
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.poc_vpc.id
#   target_type = "ip"

#   tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-tg" }, )

#   health_check {
#     healthy_threshold   = "3"
#     interval            = "30"
#     protocol            = "HTTP"
#     matcher             = "200"
#     timeout             = "3"
#     path                = "/status"
#     unhealthy_threshold = "2"
#   }
# }

# #ALB Listener
# resource "aws_alb_listener" "fastapi-demo-front_end" {
#   load_balancer_arn = aws_alb.fastapi-demo-alb.id
#   port              = 8082
#   protocol          = "HTTP"

#   tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-listener" }, )

#   default_action {
#     target_group_arn = aws_alb_target_group.fastapi-demo-tg.id
#     type             = "forward"
#   }
# }