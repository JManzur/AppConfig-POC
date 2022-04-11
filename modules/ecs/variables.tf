# Values come from provieder.tf
variable "ProjectTags" {}
variable "ecsNameTag" {}
variable "AWSRegion" {}
variable "AWSProfile" {}
variable "VPCID" {}
variable "PublicSubnet" {}
variable "PrivateSubnet" {}


### Task Definition Variables:
variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8082
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "health_check_path" {
  default = "/status"
}