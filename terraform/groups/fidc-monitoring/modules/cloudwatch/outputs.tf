output "canary_artifact_bucket" {
  value = aws_s3_bucket.canary_artifacts.id
}

output "canary_role_arn" {
  value = aws_iam_role.canary_role.arn
}