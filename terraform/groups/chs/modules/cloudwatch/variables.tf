variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name" {
  type = string
}

variable "retention_in_days" {
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