variable ProjectTags {}
variable ecsNameTag {}

# # AWS Region: North of Virginia
# variable "aws_region" {
#   type    = string
#   default = "us-east-1"
# }

# # AWS Region: North of Virginia
# variable "aws_profile" {
#   type    = string
#   default = "CTesting"
# }

# # SSH Key-Pair 
# variable "key_name" {
#   type    = string
#   default = "AppConfig_POC"
# }

# # Local Key-Pair 
# variable "local_ssh_key" {
#   type    = string
#   default = "~/.ssh/AppConfig_POC.pem"
# }

# /* Tags Variables */
# #Use: tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-place-holder" }, )
# variable "project-tags" {
#   type = map(string)
#   default = {
#     service     = "AppConfig",
#     environment = "POC"
#     DeployedBy  = "example@mail.com"
#   }
# }

# variable "resource-name-tag" {
#   type    = string
#   default = "AppConfig-POC"
# }


# ### Path Variables:
# variable "source_path" {
#   type    = string
#   default = "docker-demo"
# }

# variable "scripts_path" {
#   type    = string
#   default = "scripts"
# }

# variable "templates_path" {
#   type    = string
#   default = "templates"
# }

# variable "policy_path" {
#   type    = string
#   default = "iam-policy"
# }

# ### Task Definition Variables:
# variable "app_count" {
#   description = "Number of docker containers to run"
#   default     = 3
# }

# variable "fargate_cpu" {
#   description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
#   default     = "1024"
# }

# variable "fargate_memory" {
#   description = "Fargate instance memory to provision (in MiB)"
#   default     = "2048"
# }

# variable "health_check_path" {
#   default = "/status"
# }

# variable "app_port" {
#   description = "Port exposed by the docker image to redirect traffic to"
#   default     = 5000
# }

# ###IMPORTANT: Update this value after running "terraform apply -target=null_resource.push"
# variable "app_image" {
#   description = "Docker image to run in the ECS cluster"
#   default     = "PLACE_HOLDER"
# }