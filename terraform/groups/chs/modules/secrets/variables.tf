# Secrets
variable "name_prefix" {
  type        = string
  description = "The name prefix to be used for parameter name spacing."
}

variable "secrets" {
  type        = map(any)
  description = "The secrets to be added to Parameter Store."
}
