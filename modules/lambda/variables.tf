# Values come from provieder.tf
variable "ProjectTags" {}
variable "lambdaNameTag" {}
variable "AWSRegion" {}

variable "api_stage_name" {
  type    = string
  default = "POC"
}