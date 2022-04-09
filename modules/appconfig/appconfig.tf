#AWS AppConfig - Application
resource "aws_appconfig_application" "poc-application" {
  name        = "POC-Application"
  description = "POC AppConfig Application"

  tags = merge(var.ProjectTags, { Name = "${var.appconfigNameTag}-application" }, )
}

#AWS AppConfig - Configuration Profile
resource "aws_appconfig_configuration_profile" "poc-config-profile" {
  application_id = aws_appconfig_application.poc-application.id
  description    = "POC Configuration Profile"
  name           = "UpdateAttribute"
  location_uri   = "hosted"

  validator {
    content = <<EOF
    {
        "$schema" : "http://json-schema.org/draft-04/schema#",
        "description" : "Sitcom API Validator",
        "type" : "object",
        "properties" : {
            "EnableLimit" : {
                "type" : "boolean"
                },
            "ResultLimit" : {
                "type" : "number"
                }
            },
        "minProperties" : 2,
        "required" : [
            "EnableLimit",
            "ResultLimit"
            ]
    }
    EOF
    type    = "JSON_SCHEMA"
  }

  tags = merge(var.ProjectTags, { Name = "${var.appconfigNameTag}-config-profile" }, )
}

#AWS AppConfig - Environment
resource "aws_appconfig_environment" "poc-dev" {
  name           = "POC-DEV"
  description    = "POC AppConfig Environment"
  application_id = aws_appconfig_application.poc-application.id

  #   monitor {
  #     alarm_arn      = aws_cloudwatch_metric_alarm.example.arn
  #     alarm_role_arn = aws_iam_role.example.arn
  #   }

  tags = merge(var.ProjectTags, { Name = "${var.appconfigNameTag}-environment" }, )
}


#AWS AppConfig - Hosted configuration
resource "aws_appconfig_hosted_configuration_version" "appconfig-hosted-config" {
  application_id           = aws_appconfig_application.poc-application.id
  configuration_profile_id = aws_appconfig_configuration_profile.poc-config-profile.configuration_profile_id
  description              = "POC Freeform Hosted Configuration Version"
  content_type             = "application/json"

  content = jsonencode({
    EnableLimit = true,
    ResultLimit = 5,
  })
}

#AWS AppConfig - Deployment Strategy
resource "aws_appconfig_deployment_strategy" "appconfig-strategy" {
  name                           = "poc-deployment-strategy"
  description                    = "POC Deployment Strategy"
  deployment_duration_in_minutes = 1   #Total amount of time for a deployment to last. 
  final_bake_time_in_minutes     = 1   #Amount of time AWS AppConfig monitors for alarms before considering the deployment to be complete and no longer eligible for rollback. 
  growth_factor                  = 100 #The percentage of targets to retrieve a deployed configuration during each interval.
  growth_type                    = "LINEAR"
  replicate_to                   = "NONE"

  tags = merge(var.ProjectTags, { Name = "${var.appconfigNameTag}-strategy" }, )
}

#AWS AppConfig - Deployment
resource "aws_appconfig_deployment" "poc_appconfig_deployment" {
  application_id           = aws_appconfig_application.poc-application.id
  configuration_profile_id = aws_appconfig_configuration_profile.poc-config-profile.configuration_profile_id
  configuration_version    = aws_appconfig_hosted_configuration_version.appconfig-hosted-config.version_number
  deployment_strategy_id   = aws_appconfig_deployment_strategy.appconfig-strategy.id
  description              = "POC AppConfig Deployment"
  environment_id           = aws_appconfig_environment.poc-dev.environment_id

  tags = merge(var.ProjectTags, { Name = "${var.appconfigNameTag}-deployment" }, )
}