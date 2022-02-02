variable "region" {
  type        = string
  description = "AWS region for deployment"
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC to be used for AWS resources"
}

variable "service_name" {
  type        = string
  description = "The service name to be used when creating AWS resources"
  default     = "forgerock-monitoring"
}

variable "ecr_url" {
  type = string
}

variable "container_image_version" {
  type        = string
  description = "Version of the docker image to deploy"
  default     = "latest"
}

variable "task_cpu" {
  type        = number
  description = "The cpu unit limit for the ECS task"
}
variable "task_memory" {
  type        = number
  description = "The memory limit for the ECS task"
}

variable "fidc_url" {
  type = string
}

variable "fidc_api_key_id" {
  type        = string
  description = "ForgeRock Identity Cloud logging API key ID"
}

variable "fidc_api_key_secret" {
  type        = string
  description = "ForgeRock Identity Cloud logging API key secret"
}

variable "log_retention_in_days" {
  type        = number
  description = "CloudWatch Log Retention"
}

variable "release_bucket" {
  type = string
}

variable "health_check_rate" {
  type        = string
  description = "Schedule for health checks. Format: rate(number unit)"
}

variable "fidc_user" {
  type = string
}

variable "fidc_password" {
  type = string
}

variable "fidc_admin_client" {
  type = string
}

variable "fidc_admin_client_secret" {
  type = string
}

variable "fidc_connector_group" {
  type    = string
  default = "chs-group,ewf-group"
}

variable "fidc_mappings" {
  type    = string
  default = "chsMongoCompanyProfile_alphaOrg,webfilingAuthCode_alphaOrg" # managedAlpha_user_systemDsbackupAccount & alphaUser_webfilingUser disabled for now
  # ,webfilingUser_alphaUser
}

variable "monitored_connectors" {
  type    = string
  default = "CHSCompany,CHSRoles,CHSUser,DSBackup,WebfilingAuthCode,WebfilingUser"
}

variable "recon_duration" {
  type    = string
  description = "Time reconcilliation runs for before raising an alarm"
}

variable "alerting_email_address" {
  type        = string
  description = "Email address for sending alert notifications"
}

variable "grafana_instance_type" {
  type        = string
  description = "Instance type to use for Grafana"
}

variable "prometheus_instance_type" {
  type        = string
  description = "Instance type to use for Prometheus"
}

variable "ami_account_id" {
  type        = string
  description = "AWS account ID for the AMI owner"
}

variable "route53_zone" {
  type        = string
  description = "The Route53 hosted zone to use for DNS records"
  default     = "N/A"
}

variable "create_route53_record" {
  type        = bool
  description = "Should a Route53 record be created"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the application"
}

variable "create_certificate" {
  type        = bool
  description = "Should a Amazon SSL certificate be created"
}

variable "certificate_domain" {
  type        = string
  description = "The domain used to look up existing certificates"
  default     = "N/A"
}
