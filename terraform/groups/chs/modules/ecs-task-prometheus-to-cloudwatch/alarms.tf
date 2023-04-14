data "aws_sns_topic" "forgerock_monitoring" {
  name = "forgerock-monitoring"
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "${var.service_name}-AWS-ECS-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  treat_missing_data  = "notBreaching"
  alarm_actions       = [data.aws_sns_topic.forgerock_monitoring.arn]
  actions_enabled     = true

  dimensions = {
    ClusterName = var.service_name
    ServiceName = var.task_name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_memory" {
  alarm_name          = "${var.service_name}-AWS-ECS-High-Memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  treat_missing_data  = "notBreaching"
  alarm_actions       = [data.aws_sns_topic.forgerock_monitoring.arn]
  actions_enabled     = true

  dimensions = {
    ClusterName = var.service_name
    ServiceName = var.task_name
  }
}