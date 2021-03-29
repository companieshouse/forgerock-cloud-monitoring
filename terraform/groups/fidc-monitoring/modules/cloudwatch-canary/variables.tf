variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name" {
  type = string
}

variable "canary_name" {
  type = string
}

variable "release_version" {
  type = string
}

variable "source_code_path" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime_version" {
  type = string
}

variable "release_bucket" {
  type = string
}

variable "artifact_bucket" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "health_check_rate" {
  type = string
}

variable "fidc_url" {
  type = string
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
variable "fidc_monitored_component" {
  type = string
}
