resource "aws_cloudwatch_log_group" "monitoring" {
  name = var.service_name
}
