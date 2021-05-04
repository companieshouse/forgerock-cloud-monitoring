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
  default = "aws-group"
}

variable "fidc_mappings" {
  type    = string
  default = "systemChsuserUsers_managedAlpha_user,systemChsrolesRoles_managedAlpha_role,systemChscompanyCompany_profile_managedCompany,systemChsauthcodeCompany_auth_codes_managedCompany"
}

variable "alerting_email_address" {
  type        = string
  description = "Email address for sending alert notifications"
}

variable "grafana_instance_type" {
  type    = string
  default = "Instance type to use for Grafana"
}
