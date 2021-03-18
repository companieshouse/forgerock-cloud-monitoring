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

variable "fidc_api_key_secret" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "log_prefix" {
  type = string
}
