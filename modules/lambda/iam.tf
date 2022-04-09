# /* Lambda IAM Role: Allow Lambda to perform AppConfig operations and send Logs to CloudWatch. */

# Lambda IAM Policy Document
data "aws_iam_policy_document" "lambda_policy_source" {
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "LambdaGetAppConfig"
    effect = "Allow"
    actions = [
      "appconfig:GetConfiguration",
      "appconfig:StartConfigurationSession",
      "appconfig:GetLatestConfiguration"
    ]
    resources = ["*"]
  }
}

# Lambda IAM Role Policy Document
data "aws_iam_policy_document" "lambda_role_source" {
  statement {
    sid    = "LambdaAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Lambda IAM Policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "AppConfig_Lambda_Policy"
  path        = "/"
  description = "AppConfig POC from Lambda"
  policy      = data.aws_iam_policy_document.lambda_policy_source.json
  tags        = merge(var.ProjectTags, { Name = "${var.lambdaNameTag}-policy" }, )
}

# Lambda IAM Role (Lambda execution role)
resource "aws_iam_role" "lambda_policy_role" {
  name               = "lambda_appconfig_policy_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_source.json
  tags               = merge(var.ProjectTags, { Name = "${var.lambdaNameTag}-role" }, )
}

# Attach Lambda Role and Policy
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_policy_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}