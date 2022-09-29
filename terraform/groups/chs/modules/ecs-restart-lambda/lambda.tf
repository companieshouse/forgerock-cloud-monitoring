resource "aws_lambda_function" "restart_function" {
    filename = "ecs_service_restart.zip"
    function_name = "ecs_service_restart_${var.ecs_cluster_name}_${var.ecs_service_name}"
    role = aws_iam_role.execution_role
    handler = "index.main"

    source_code_hash = filebase64sha256("ecs_service_restart.zip")
    runtime = "nodejs12.x"

    environment {
        variables = {
            ecs_cluster_arn = var.ecs_cluster_arn
            ecs_service_name = var.ecs_service_name
        }
    }
}