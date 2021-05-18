variable "service_name" {
  type = string
}

variable "alerting_email_address" {
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