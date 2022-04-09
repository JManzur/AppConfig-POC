# AWS Region: North of Virginia
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# AWS Region: North of Virginia
variable "aws_profile" {
  type    = string
  default = "CTesting"
}

/* Tags Variables */
#Use: tags = merge(var.project-tags, { Name = "${var.resourceNameTag}-place-holder" }, )
variable "ProjectTags" {
  type = map(string)
  default = {
    service     = "AppConfig",
    environment = "POC"
    DeployedBy  = "example@mail.com"
  }
}

variable "appconfigNameTag" {
  type    = string
  default = "POC-AppConfig"
}

variable "ec2NameTag" {
  type    = string
  default = "POC-EC2"
}

variable "ecsNameTag" {
  type    = string
  default = "POC-ECS"
}

variable "lambdaNameTag" {
  type    = string
  default = "POC-Lambda"
}

variable "vpcNameTag" {
  type    = string
  default = "POC-VPC"
}

