variable "service_name" {
  type = string
}

variable "vpc_id" {
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

variable "secret_arns" {
  description = "List of SSM Parameter ARNs the task needs to read"
  type        = list(string)
  default     = []
}
