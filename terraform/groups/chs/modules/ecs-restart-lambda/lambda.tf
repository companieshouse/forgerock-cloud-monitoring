locals {
    zip_file_path = "${path.module}/ecs_service_restart.zip"
}

data "archive_file" "lambda_code" {
    type = "zip"
    source_dir = "lambda_code"
    output_path = local.zip_file_path
}

resource "aws_lambda_function" "restart_function" {
    filename = local.zip_file_path
    function_name = "ecs_service_restart_${var.ecs_service_name}"
    role = aws_iam_role.execution_role.arn
    handler = "index.main"

    source_code_hash = filebase64sha256(local.zip_file_path)
    runtime = "nodejs12.x"

    environment {
        variables = {
            ecs_cluster_arn = var.ecs_cluster_arn
            ecs_service_name = var.ecs_service_name
        }
    }

    depends_on = [
        data.archive_file.lambda_code
    ]
}