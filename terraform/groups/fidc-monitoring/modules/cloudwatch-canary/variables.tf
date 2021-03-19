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

variable "version" {
  type = string
}

variable "source_code_path" {
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

variable "rate_in_minutes" {
  type = number
}
