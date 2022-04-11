# AWS provider version definition
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Create an AppConfig Project
module "appconfig" {
  source           = "./modules/appconfig"
  ProjectTags      = var.ProjectTags
  appconfigNameTag = var.appconfigNameTag
}

# Create an API running on an EC2 instance
module "ec2" {
  source       = "./modules/ec2"
  ProjectTags  = var.ProjectTags
  ec2NameTag   = var.ec2NameTag
  VPCID        = module.vpc.vpc_id
  PublicSubnet = module.vpc.public_subnet

  depends_on = [module.appconfig.aws_appconfig_application]
}

# Create an API running on an ECS Cluster
module "ecs" {
  source        = "./modules/ecs"
  ProjectTags   = var.ProjectTags
  ecsNameTag    = var.ecsNameTag
  AWSRegion     = var.aws_region
  AWSProfile    = var.aws_profile
  VPCID         = module.vpc.vpc_id
  PublicSubnet  = module.vpc.public_subnet
  PrivateSubnet = module.vpc.private_subnet

  depends_on = [module.appconfig.aws_appconfig_application]
}

# Create an API running on an Lambda Function
module "lambda" {
  source        = "./modules/lambda"
  ProjectTags   = var.ProjectTags
  lambdaNameTag = var.lambdaNameTag
  AWSRegion     = var.aws_region

  depends_on = [module.appconfig.aws_appconfig_application]
}

# Create a VPC
module "vpc" {
  source      = "./modules/vpc"
  ProjectTags = var.ProjectTags
  vpcNameTag  = var.vpcNameTag
  AWSRegion   = var.aws_region
}