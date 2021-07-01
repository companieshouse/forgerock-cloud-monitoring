variable "region" {
  type        = string
  description = "AWS region for deployment"
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "service_name" {
  type        = string
  description = "The service name to be used when creating AWS resources"
  default     = "forgerock-monitoring"
}

variable "log_retention_in_days" {
  type        = number
  description = "CloudWatch Log Retention"
}
