variable "region" {
  type = string
}
variable "task_name" {
  type = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "ecs_task_security_group_id" {
  type = string
}

variable "container_image_version" {
  type = string
}

variable "ecr_url" {
  type = string
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "tags" {
  type = object({
    Environment    = string
    Service        = string
    ServiceSubType = string
    Team           = string
  })
}

variable "service_name" {
  type = string
}

variable "log_prefix" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "cloudwatch_namespace" {
  type = string
}

variable "cloudwatch_publish_timeout" {
  type = string
}

variable "prometheus_scrape_interval" {
  type = string
}

variable "prometheus_scrape_url" {
  type = string
}

variable "fidc_api_key_id" {
  type        = string
  description = "ForgeRock Identity Cloud API key ID"
}

variable "fidc_api_key_secret" {
  type        = string
  description = "ForgeRock Identity Cloud API key secret"
}


