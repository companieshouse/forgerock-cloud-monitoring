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

variable "fidc_url" {
  type = string
}

variable "fidc_api_key_id" {
  type = string
}

variable "tags" {
  type = object({
    Environment    = string
    Service        = string
    ServiceSubType = string
    Team           = string
  })
}

variable "fidc_api_key_secret" {
  type = string
}

variable "service_name" {
  type = string
}

variable "log_prefix" {
  type = string
}

variable "log_source" {
  type = string
}

variable "log_frequency" {
  type = number
  description = "Rate, in seconds, at which logs should be retrieved from FIDC"
  default = 10
}

variable "restart_frequency_schedule" {
  type = string
  description = "Cron schedule on which to execute the restart"
}