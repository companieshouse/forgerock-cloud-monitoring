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

# Using CloudFormation as canary environment variables
# are not currently support by terraform
resource "aws_cloudformation_stack" "canary" {
  name = "${var.service_name}-${var.canary_name}"

  parameters = {
    artifactBucket        = "s3://${var.artifact_bucket}/"
    handler               = var.handler
    s3Bucket              = var.release_bucket
    s3Key                 = "${var.service_name}/${var.environment}/${var.service_name}-${var.release_version}.zip"
    s3Version             = aws_s3_bucket_object.source_code.version_id
    roleArn               = var.role_arn
    canaryName            = var.canary_name
    fidcUrl               = var.fidc_url
    fidcUser              = var.fidc_user
    fidcPassword          = var.fidc_password
    fidcAdminClient       = var.fidc_admin_client
    fidcAdminClientSecret = var.fidc_admin_client_secret
    fidcConnectorGroup    = var.fidc_connector_group
    runtime               = var.runtime_version
    healthCheckRate       = var.rate_in_seconds
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
  fidcConnectorGroup:
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
          CONNECTOR_GROUP: !Ref fidcConnectorGroup
      RuntimeVersion: !Ref runtime
      Schedule: 
        DurationInSeconds: !Ref healthCheckRate
      StartCanaryAfterCreation: true
STACK
}
