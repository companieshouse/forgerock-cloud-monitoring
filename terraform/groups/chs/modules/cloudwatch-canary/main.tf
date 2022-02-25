data "aws_s3_bucket_object" "source_code" {
  bucket = var.release_bucket
  key    = "${var.service_name}/${var.environment}/${var.canary_name}-${var.release_version}.zip"
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
    s3Version              = data.aws_s3_bucket_object.source_code.version_id
    roleArn                = var.role_arn
    canaryName             = var.canary_name
    fidcUrl                = var.fidc_url
    fidcUser               = var.fidc_user
    fidcPassword           = var.fidc_password
    fidcAdminClient        = var.fidc_admin_client
    fidcAdminClientSecret  = var.fidc_admin_client_secret
    fidcMonitoredComponent = var.fidc_monitored_component
    reconduration          = var.recon_duration
    cancelReconAfter       = var.cancel_recon_after
    runtime                = var.runtime_version
    healthCheckRate        = var.health_check_rate
    tagEnvironment         = var.tags["Environment"]
    tagService             = var.tags["Service"]
    tagServiceSubType      = var.tags["ServiceSubType"]
    tagTeam                = var.tags["Team"]
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
  reconduration:
    Type: String
  cancelReconAfter:
    Type: String
  runtime:
    Type: String
  healthCheckRate:
    Type: String
  tagEnvironment:
    Type: String
  tagService:
    Type: String
  tagServiceSubType:
    Type: String
  tagTeam:
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
          RECON_DURATION: !Ref reconduration
          CANCEL_RECON_AFTER: !Ref cancelReconAfter
      RuntimeVersion: !Ref runtime
      Schedule:
        Expression: !Ref healthCheckRate
      StartCanaryAfterCreation: true
      Tags:
        - Key: Environment
          Value: !Ref tagEnvironment
        - Key: Service
          Value: !Ref tagService
        - Key: ServiceSubType
          Value: !Ref tagServiceSubType
        - Key: Team
          Value: !Ref tagTeam
STACK

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "canary-alerting" {
  depends_on = [
    aws_cloudformation_stack.canary
  ]
  alarm_name          = "${var.environment}-${var.canary_name}"
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

  tags = var.tags
}
