# ## SG Rule: Internet > ALB
# resource "aws_security_group" "fastapi-demo-sg" {
#   name        = "FastApi-demo-sg"
#   description = "Allow public access to the ALB"
#   vpc_id      = aws_vpc.poc_vpc.id

#   tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-toalb-sg" }, )

#   ingress {
#     protocol    = "tcp"
#     from_port   = 8082
#     to_port     = 8082
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Internet to ALB"
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# ## SG Rule: ALB > ECS
# resource "aws_security_group" "ecs_tasks" {
#   name        = "fastapi_demo-ecs-tasks-security-group"
#   description = "Allow ALB to ECS ONLY"
#   vpc_id      = aws_vpc.poc_vpc.id

#   tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-to-ecs-sg" }, )

#   ingress {
#     protocol        = "tcp"
#     from_port       = 8082
#     to_port         = 8082
#     security_groups = [aws_security_group.fastapi-demo-sg.id]
#     description     = "FastApi ALB to ECS"
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }