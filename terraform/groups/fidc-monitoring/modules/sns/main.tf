resource "aws_sns_topic" "alerting" {
  name = var.service_name
}

resource "aws_sns_topic_subscription" "alerting" {
  topic_arn = aws_sns_topic.alerting.arn
  protocol  = "email"
  endpoint  = var.alerting_email_address
}