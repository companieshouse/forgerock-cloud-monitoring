data "aws_iam_policy_document" "grafana_discovery_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}


resource "aws_iam_instance_profile" "grafana" {
  name = "${var.service_name}-grafana"
  role = aws_iam_role.grafana_discovery_execution.name

  tags = var.tags
}

resource "aws_iam_role" "grafana_discovery_execution" {
  name               = "${var.service_name}-grafana"
  assume_role_policy = data.aws_iam_policy_document.grafana_discovery_trust.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "grafana_ec2_permissions" {
  role       = aws_iam_role.grafana_discovery_execution.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "grafana_s3_permissions" {
  role       = aws_iam_role.grafana_discovery_execution.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
