# Values come from provieder.tf
variable "ProjectTags" {}
variable "ec2NameTag" {}
variable "PublicSubnetID" {}
variable "VPCID" {}

/* EC2 Instance type */
#Use: instance_type = var.instance_type["type1"]
variable "instance_type" {
  type = map(string)
  default = {
    "type1" = "t2.micro"
    "type2" = "t2.small"
    "type3" = "t2.medium"
  }
}

# SSH Key-Pair 
variable "key_name" {
  type    = string
  default = "AppConfig_POC"
}

# Local Key-Pair 
variable "local_ssh_key" {
  type    = string
  default = "~/.ssh/AppConfig_POC.pem"
}