# In this demo no quota_settings neither throttle_settings are set up
# More info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan

# Capture the AWS Account ID:
data "aws_caller_identity" "current" {}

# API Gateway definition:
resource "aws_api_gateway_rest_api" "appconfig_poc_api_gw" {
  name        = "AppConfigPOCAPIGW"
  description = "AppConfig POC API Gateway"
  endpoint_configuration {
    types = ["EDGE"]
  }

  depends_on = [
    aws_lambda_function.lambda_app_config_poc
  ]
}

# ---------------------------------------------------
# API Resources definition:
# ---------------------------------------------------

# /get Resource
resource "aws_api_gateway_resource" "get" {
  rest_api_id = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  parent_id   = aws_api_gateway_rest_api.appconfig_poc_api_gw.root_resource_id
  path_part   = "get"
}

# API Model Schema definition:
resource "aws_api_gateway_model" "json_schema" {
  rest_api_id  = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  name         = "passthrough"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = file("${path.module}/templates/passthrough.template")
}

# ---------------------------------------------------
# GET Method:
# ---------------------------------------------------

# GET Request method:
resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  resource_id   = aws_api_gateway_resource.get.id
  http_method   = "GET"
  authorization = "NONE"
}

# GET Request integration:
resource "aws_api_gateway_integration" "integration-get" {
  rest_api_id             = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  resource_id             = aws_api_gateway_resource.get.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST" // Lambda function only accepts POST
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_app_config_poc.invoke_arn

  request_templates = {
    "application/json" = "${file("${path.module}/templates/GET.template")}"
  }
}

# GET Method Response
resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# GET Integration Response
resource "aws_api_gateway_integration_response" "get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.get_response_200.status_code

  response_templates = {
    "application/json" = "${file("${path.module}/templates/lambda-response.template")}"
  }

  depends_on = [
    aws_api_gateway_integration.integration-get
  ]
}

# ---------------------------------------------------
# Stages, API-Key and Usage Plan
# ---------------------------------------------------

# Stage PROD definition:
resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.appconfig_poc_api.id
  rest_api_id   = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
  stage_name    = "v1"
}

# Usage plan definition:
resource "aws_api_gateway_usage_plan" "appconfig_pi_usage_plan" {
  name = "appconfig_api_usage_plan"
  tags = merge(var.ProjectTags, { Name = "${var.lambdaNameTag}-usage_plan" })

  api_stages {
    api_id = aws_api_gateway_rest_api.appconfig_poc_api_gw.id
    stage  = aws_api_gateway_stage.v1.stage_name
  }
}

# ---------------------------------------------------
# Lambda Triggers:
# ---------------------------------------------------

# GET Trigger:
resource "aws_lambda_permission" "lambda_get_permission" {
  statement_id  = "InvokeGETAppConfigAPI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_app_config_poc.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.AWSRegion}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.appconfig_poc_api_gw.id}/*/${aws_api_gateway_method.get.http_method}/${aws_api_gateway_resource.get.path_part}"

  depends_on = [
    aws_lambda_function.lambda_app_config_poc,
    aws_api_gateway_rest_api.appconfig_poc_api_gw
  ]
}

# ---------------------------------------------------
# Deploy the API
# ---------------------------------------------------
resource "aws_api_gateway_deployment" "appconfig_poc_api" {
  rest_api_id = aws_api_gateway_rest_api.appconfig_poc_api_gw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.appconfig_poc_api_gw.id,
      aws_api_gateway_method.get.id,
      aws_api_gateway_integration.integration-get.id,
    ]))
  }

  depends_on = [
    aws_api_gateway_method.get,
    aws_api_gateway_integration.integration-get,
  ]

  lifecycle {
    create_before_destroy = true
  }
}