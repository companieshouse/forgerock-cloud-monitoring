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