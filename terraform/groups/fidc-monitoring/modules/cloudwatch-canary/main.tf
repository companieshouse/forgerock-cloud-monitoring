data "archive_file" "source_code" {
  type        = "zip"
  source_dir  = var.source_code_path
  output_path = "${path.module}/${var.canary_name}.zip"
}

resource "aws_s3_bucket_object" "source_code" {
  bucket = var.release_bucket
  key    = "${var.service_name}/${var.environment}/${var.canary_name}-${var.release_version}.zip"
  source = "${path.module}/${var.canary_name}.zip"
  etag   = data.archive_file.source_code.output_md5
}

# Using CloudFormation as canary environment variables
# are not currently support by terraform
resource "aws_cloudformation_stack" "canary" {
  name = "${var.service_name}-${var.canary_name}"

  parameters = {
    artifactBucket         = "s3://${var.artifact_bucket}/"
    handler                = var.handler
    s3Bucket               = var.release_bucket
    s3Key                  = "${var.service_name}/${var.environment}/${var.canary_name}-${var.release_version}.zip"
    s3Version              = aws_s3_bucket_object.source_code.version_id
    roleArn                = var.role_arn
    canaryName             = var.canary_name
    fidcUrl                = var.fidc_url
    fidcUser               = var.fidc_user
    fidcPassword           = var.fidc_password
    fidcAdminClient        = var.fidc_admin_client
    fidcAdminClientSecret  = var.fidc_admin_client_secret
    fidcMonitoredComponent = var.fidc_monitored_component
    runtime                = var.runtime_version
    healthCheckRate        = var.health_check_rate
  }

  template_body = <<STACK
Parameters:
  artifactBucket:
    Type: String
  handler:
    Type: String
  s3Bucket:
    Type: String
  s3Key:
    Type: String
  s3Version:
    Type: String
  roleArn:
    Type: String
  canaryName:
    Type: String
  fidcUrl:
    Type: String
  fidcUser:
    Type: String
  fidcPassword:
    Type: String
  fidcAdminClient:
    Type: String
  fidcAdminClientSecret:
    Type: String
  fidcMonitoredComponent:
    Type: String
  runtime:
    Type: String
  healthCheckRate:
    Type: String
Resources:
  Canary:
    Type: AWS::Synthetics::Canary
    Properties: 
      ArtifactS3Location: !Ref artifactBucket
      Code: 
        Handler: !Ref handler
        S3Bucket: !Ref s3Bucket
        S3Key: !Ref s3Key
        S3ObjectVersion: !Ref s3Version
      ExecutionRoleArn: !Ref roleArn
      Name: !Ref canaryName
      RunConfig: 
        EnvironmentVariables:
          FIDC_URL: !Ref fidcUrl
          USER: !Ref fidcUser
          PASSWORD: !Ref fidcPassword
          ADMIN_CLIENT: !Ref fidcAdminClient
          ADMIN_CLIENT_SECRET: !Ref fidcAdminClientSecret
          MONITORED_COMPONENT: !Ref fidcMonitoredComponent
      RuntimeVersion: !Ref runtime
      Schedule: 
        Expression: !Ref healthCheckRate
      StartCanaryAfterCreation: true
STACK
}

resource "aws_cloudwatch_metric_alarm" "canary-alerting" {
  depends_on = [
    aws_cloudformation_stack.canary
  ]
  alarm_name          = var.canary_name
  namespace           = "CloudWatchSynthetics"
  statistic           = "Average"
  metric_name         = "SuccessPercent"
  comparison_operator = "LessThanThreshold"
  threshold           = "100"
  evaluation_periods  = "1"
  period              = "300" # 5 minutes
  alarm_description   = "This metric monitors canary success percentage"
  treat_missing_data  = "ignore" # Persist alarm state if health check rate is greater than 5 minutes
  actions_enabled     = true
  alarm_actions       = [var.sns_topic_arn]
  dimensions = {
    CanaryName = var.canary_name
  }
}
