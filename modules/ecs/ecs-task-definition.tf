# # Get Docker Image URI using a local scritp
# data "external" "get_image_uri" {
#   program = [coalesce("${path.module}/scripts/get_image_uri.sh")]
# }

# #Load the task definition template from a json.tpl file
# data "template_file" "fastapi-demo-tpl" {
#   template = file("${path.module}/templates/fastapi-demo.json.tpl")

#   vars = {
#     app_image     = "${data.external.get_image_uri.result["URI"]}"
#     aws_region    = var.AWSRegion
#     app_port      = 8082
#     app_cw_group  = "/FastAPI_Logs"
#     app_cw_stream = "FastAPI_Stream"
#   }
# }

# #Task definition
# resource "aws_ecs_task_definition" "fastapi-demo-td" {
#   family                   = "fastapi-demo-td"
#   task_role_arn            = aws_iam_role.ecs_policy_role.arn
#   execution_role_arn       = aws_iam_role.ecs_policy_role.arn
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 1024
#   memory                   = 2048
#   container_definitions    = data.template_file.fastapi-demo-tpl.rendered

#   tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-task-definition" }, )
# }

# #Service definition
# resource "aws_ecs_service" "fastapi-demo-service" {
#   name                   = "fastapi-demo-service"
#   cluster                = aws_ecs_cluster.demo-cluster.id
#   task_definition        = aws_ecs_task_definition.fastapi-demo-td.arn
#   desired_count          = 2
#   launch_type            = "FARGATE"
#   enable_execute_command = true

#   tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-fastapi-srv" }, )

#   network_configuration {
#     security_groups  = [aws_security_group.ecs_tasks.id]
#     subnets          = [var.PrivateSubnetID]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_alb_target_group.fastapi-demo-tg.id
#     container_name   = "fastapi-demo"
#     container_port   = 8082
#   }

#   depends_on = [aws_alb_listener.fastapi-demo-front_end]
# }