data "archive_file" "source_code" {
  type        = "zip"
  source_dir  = var.source_code_path
  output_path = "${path.module}/${var.service_name}.zip"
}

resource "aws_s3_bucket_object" "source_code" {
  bucket = var.release_bucket
  key    = "${var.service_name}/${var.environment}/${var.service_name}-${var.release_version}.zip"
  source = "${path.module}/${var.service_name}.zip"
  etag   = data.archive_file.source_code.output_md5
}

resource "aws_synthetics_canary" "canary" {
  name                 = var.canary_name
  artifact_s3_location = "s3://${var.artifact_bucket}/"
  execution_role_arn   = var.role_arn
  handler              = var.handler
  runtime_version      = var.runtime_version
  s3_bucket            = var.release_bucket
  s3_key               = "${var.service_name}/${var.environment}/${var.service_name}-${var.release_version}.zip"
  s3_version           = aws_s3_bucket_object.source_code.version_id

  schedule {
    expression = "rate(${var.rate_in_minutes} minute)"
  }
}
