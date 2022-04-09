/* EC2 IAM Role: Allow EC2 to perform AppConfig operations */

# EC2 IAM Policy Document
data "aws_iam_policy_document" "ec2_policy_source" {
  statement {
    sid    = "EC2GetAppConfig"
    effect = "Allow"
    actions = [
      "appconfig:GetConfiguration",
      "appconfig:StartConfigurationSession",
      "appconfig:GetLatestConfiguration"
    ]
    resources = ["*"]
  }
}

# EC2 IAM Role Policy Document
data "aws_iam_policy_document" "ec2_role_source" {
  statement {
    sid    = "EC2AssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# EC2 IAM Policy
resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy"
  path        = "/"
  description = "Get AppConfig Configurations"
  policy      = data.aws_iam_policy_document.ec2_policy_source.json
  tags        = merge(var.ProjectTags, { Name = "${var.ec2NameTag}-ec2-policy" }, )
}

# EC2 IAM Role
resource "aws_iam_role" "ec2_policy_role" {
  name               = "EC2PolicyRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_role_source.json
  tags               = merge(var.ProjectTags, { Name = "${var.ec2NameTag}-ec2-role" }, )
}

# Attach EC2 Role and EC2 Policy
resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.ec2_policy_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}