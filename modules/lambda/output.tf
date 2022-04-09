output "api-gw_invoke_url" {
  value = "${aws_api_gateway_deployment.appconfig_poc_api.invoke_url}${aws_api_gateway_stage.v1.stage_name}/${aws_api_gateway_resource.get.path_part}"
}