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
  type = string
  description = "ForgeRock Identity Cloud loggin API key ID"
}

variable "fidc_api_key_secret" {
  type = string
  description = "ForgeRock Identity Cloud loggin API key secret"
}
