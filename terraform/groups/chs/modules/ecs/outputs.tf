output "cluster_id" {
  value = aws_ecs_cluster.monitoring.id
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "task_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}

output "cluster_name" {
  value = aws_ecs_cluster.monitoring.name
}