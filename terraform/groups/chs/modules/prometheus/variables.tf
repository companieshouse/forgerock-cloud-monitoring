variable "service_name" {
  type = string
}

variable "vpc_id" {
  type = string
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

variable "api_key_id" {
  type = string
}

variable "api_key_secret" {
  type = string
}

variable "fidc_domain" {
  type = string
}

variable "grafana_ip" {
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

variable "tags" {
  type = object({
    Environment    = string
    Service        = string
    ServiceSubType = string
    Team           = string
  })
}