# #Application Load Balancer (ALB): Internet > fastapi-Demo ECS
# resource "aws_lb" "fastapi-demo-alb" {
#   name               = "fastapi-demo-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.fastapi-demo-sg.id]
#   subnets            = [var.PublicSubnetID]

#   tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-alb" }, )
# }

# #ALB Target
# resource "aws_lb_target_group" "fastapi-demo-tg" {
#   name        = "fastapi-demo-tg"
#   port        = 8082
#   protocol    = "HTTP"
#   vpc_id      = var.VPCID
#   target_type = "ip"

#   tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-tg" }, )

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
# resource "aws_lb_listener" "fastapi-demo-front_end" {
#   load_balancer_arn = aws_lb.fastapi-demo-alb.id
#   port              = 8082
#   protocol          = "HTTP"

#   tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-listener" }, )

#   default_action {
#     target_group_arn = aws_lb_target_group.fastapi-demo-tg.id
#     type             = "forward"
#   }
# }