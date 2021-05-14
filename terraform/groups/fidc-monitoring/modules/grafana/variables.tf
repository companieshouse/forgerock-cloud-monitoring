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

variable "ami_account_id" {
  type = string
}
