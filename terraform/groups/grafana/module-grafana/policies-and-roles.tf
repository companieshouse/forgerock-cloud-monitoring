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
  name = "${var.service}-${var.environment}-grafana"
  role = aws_iam_role.grafana_discovery_execution.name
}

resource "aws_iam_role" "grafana_discovery_execution" {
  name               = "${var.service}-${var.environment}-grafana"
  assume_role_policy = data.aws_iam_policy_document.grafana_discovery_trust.json
}

resource "aws_iam_role_policy_attachment" "grafana_discovery_execution" {
  role       = aws_iam_role.grafana_discovery_execution.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
