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
    ARTIFACT_BUCKET          = "s3://${var.artifact_bucket}/"
    HANDLER                  = var.handler
    S3_BUCKET                = var.release_bucket
    S3_KEY                   = "${var.service_name}/${var.environment}/${var.service_name}-${var.release_version}.zip"
    S3_VERSION               = aws_s3_bucket_object.source_code.version_id
    ROLE_ARN                 = var.role_arn
    CANARY_NAME              = var.canary_name
    FIDC_URL                 = var.fidc_url
    FIDC_USER                = var.fidc_user
    FIDC_PASSWORD            = var.fidc_password
    FIDC_ADMIN_CLIENT        = var.fidc_admin_client
    FIDC_ADMIN_CLIENT_SECRET = var.fidc_admin_client_secret
    FIDC_CONNECTOR_GROUP     = var.fidc_connector_group
    RUNTIME                  = var.runtime_version
    HEALTH_CHECK_RATE        = var.rate_in_seconds
  }

  template_body = <<STACK
Parameters:
  ARTIFACT_BUCKET:
    Type: String
  HANDLER:
    Type: String
  S3_BUCKET:
    Type: String
  S3_KEY:
    Type: String
  S3_VERSION:
    Type: String
  ROLE_ARN:
    Type: String
  CANARY_NAME:
    Type: String
  FIDC_URL:
    Type: String
  FIDC_USER:
    Type: String
  FIDC_PASSWORD:
    Type: String
  FIDC_ADMIN_CLIENT:
    Type: String
  FIDC_ADMIN_CLIENT_SECRET:
    Type: String
  FIDC_CONNECTOR_GROUP:
    Type: String
  HEALTH_CHECK_RATE:
    Type: String
Resources
  canary:
    Type: AWS::Synthetics::Canary
    Properties: 
      ArtifactS3Location: !Ref ARTIFACT_BUCKET
      Code: 
        Handler: !Ref HANDLER
        S3Bucket: !Ref S3_BUCKET
        S3Key: !Ref S3_KEY
        S3ObjectVersion: !Ref S3_VERSION
      ExecutionRoleArn: !Ref ROLE_ARN
      Name: !Ref CANARY_NAME
      RunConfig: 
        EnvironmentVariables:
          FIDC_URL: !Ref FIDC_URL
          USER: !Ref FIDC_USER
          PASSWORD: !Ref FIDC_PASSWORD
          ADMIN_CLIENT: !Ref FIDC_ADMIN_CLIENT
          ADMIN_CLIENT_SECRET: !Ref FIDC_ADMIN_CLIENT_SECRET
          CONNECTOR_GROUP: !Ref FIDC_CONNECTOR_GROUP
      RuntimeVersion: !Ref RUNTIME
      Schedule: 
        DurationInSeconds: !Ref HEALTH_CHECK_RATE
      StartCanaryAfterCreation: true
STACK
}
