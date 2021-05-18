resource "aws_cloudwatch_log_group" "monitoring" {
  name              = var.service_name
  retention_in_days = var.retention_in_days

  tags = var.tags
}

resource "aws_s3_bucket" "canary_artifacts" {
  bucket        = "${var.environment}-${var.region}.${var.service_name}.ch.gov.uk"
  force_destroy = true

  tags = var.tags
}

data "aws_iam_policy_document" "canary_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "canary_role" {
  name               = "${var.service_name}-canary"
  assume_role_policy = data.aws_iam_policy_document.canary_role.json

  tags = var.tags
}

resource "aws_iam_policy" "canary_role" {
  name = "${var.service_name}-canary"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.canary_artifacts.arn}/*"
      },
      {
        Action = [
          "s3:GetBucketLocation",
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.canary_artifacts.arn
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "s3:ListAllMyBuckets",
          "cloudwatch:PutMetricData",
        ]
        Effect   = "Allow"
        Resource = "*"
      },

    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "canary_role" {
  role       = aws_iam_role.canary_role.name
  policy_arn = aws_iam_policy.canary_role.arn
}
