resource "aws_cloudwatch_event_rule" "invoker" {
    name = "invoke_restart_${var.ecs_service_name}"
    description = "Trigger restart of ${var.ecs_service_name} svc on ECS cluster ${var.ecs_cluster_arn}"
    schedule_expression = var.restart_frequency_schedule
}

resource "aws_cloudwatch_event_target" "lambda" {
    rule = aws_cloudwatch_event_rule.invoker.name
    target_id = "InvokeLambda"
    arn = aws_lambda_function.restart_function.arn
}