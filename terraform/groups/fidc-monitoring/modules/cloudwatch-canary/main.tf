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

# resource "aws_synthetics_canary" "canary" {
#   name                 = var.canary_name
#   artifact_s3_location = "s3://${var.artifact_bucket}/"
#   execution_role_arn   = var.role_arn
#   handler              = var.handler
#   runtime_version      = var.runtime_version
#   s3_bucket            = var.release_bucket
#   s3_key               = "${var.service_name}/${var.environment}/${var.service_name}-${var.release_version}.zip"
#   s3_version           = aws_s3_bucket_object.source_code.version_id

#   schedule {
#     expression = "rate(0 minute)"
#   }
# }

resource "aws_cloudformation_stack" "canary" {
  name = "${var.service_name}-${var.canary_name}"

  parameters = {
    VPCCidr = "10.0.0.0/16"
  }

  template_body = <<STACK
Type: AWS::Synthetics::Canary
Properties: 
  ArtifactS3Location: "s3://${var.artifact_bucket}/"
  Code: 
    Handler: "${var.handler}"
    S3Bucket: "${var.release_bucket}"
    S3Key: "${var.service_name}/${var.environment}/${var.service_name}-${var.release_version}.zip"
    S3ObjectVersion: "${aws_s3_bucket_object.source_code.version_id}"
  ExecutionRoleArn: "${var.role_arn}"
  Name: "${var.canary_name}"
  RunConfig: 
    EnvironmentVariables:
      FIDC_URL: "${var.fidc_url}"
      USER: "${var.fidc_user}"
      PASSWORD: "${var.fidc_password}"
      ADMIN_CLIENT: "${var.fidc_admin_client}"
      ADMIN_CLIENT_SECRET: "${var.fidc_admin_client_secret}"
      CONNECTOR_GROUP: "${var.fidc_connector_group}"
  RuntimeVersion: "${var.runtime_version}"
  Schedule: 
    DurationInSeconds: "${var.rate_in_seconds}"
  StartCanaryAfterCreation: true
STACK
}
