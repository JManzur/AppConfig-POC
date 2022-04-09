/* Lambda Function - AppConfig POC */

# Zip the lambda code
data "archive_file" "lambda_init" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/"
  output_path = "${path.module}/output_lambda/AppConfigPOCLambda.zip"
}

# Create lambda function
resource "aws_lambda_function" "lambda_app_config_poc" {
  filename      = data.archive_file.lambda_init.output_path
  function_name = "AppConfigPOCLambda"
  role          = aws_iam_role.lambda_policy_role.arn
  handler       = "main_handler.lambda_handler"
  description   = "AppConfig POC Lambda"
  tags          = merge(var.ProjectTags, { Name = "${var.lambdaNameTag}" })

  # Prevent lambda recreation
  source_code_hash = filebase64sha256(data.archive_file.lambda_init.output_path)

  runtime = "python3.9"
  timeout = "120"
}