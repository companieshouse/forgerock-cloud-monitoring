variable "service_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "aws_access_key" {
  type        = string
  description = "The AWS access key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "The AWS secret access key"
}

variable "vpn_cidrs" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(any)
}

variable "instance_type" {
  type = string
}

variable "ami_account_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "create_route53_record" {
  type = bool
}

variable "route53_zone" {
  type = string
}

variable "create_certificate" {
  type = bool
}

variable "certificate_domain" {
  type = string
}

variable "grafana_api_key" {
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
