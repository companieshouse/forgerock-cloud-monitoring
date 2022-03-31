variable "account_name" {
  description = "The name of the AWS account we're using"
  type        = string
}

variable "ami_owner_id" {
  type        = string
  description = "The ID of the AMI owner"
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "prometheus_ami_version_pattern" {
  default     = "\\d.\\d.\\d"
  description = "The pattern with which to match prometheus AMIs"
  type        = string
}

variable "prometheus_instance_count" {
  default     = 1
  description = "The number of prometheus instances to provision"
  type        = number
}

variable "prometheus_instance_type" {
  default     = "t3.medium"
  description = "The instance type to use for prometheus instances"
  type        = string
}

variable "prometheus_lvm_block_devices" {
  description = "LVM block devices for prometheus nodes"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
}

variable "prometheus_metrics_port" {
  default = "9100"
  description = "The metrics port to be used"
  type = string
}

variable "prometheus_root_volume_size" {
  default     = 0
  description = "The size of the root volume for prometheus instances in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed"
  type        = number
}

variable "prometheus_service_group" {
  default     = "prometheus"
  description = "The Linux group name for association with prometheus configuration files"
  type        = string
}

variable "prometheus_service_user" {
  default     = "prometheus"
  description = "The Linux username for ownership of prometheus configuration files"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be administered"
  type        = string
}

variable "repository_name" {
  description = "The name of the repository in which we're operating"
  type        = string
}

variable "service" {
  default     = "forgerock"
  description = "The service name to be used when creating AWS resources"
  type        = string
}


variable "team" {
  description = "The team responsible for administering the instance"
  type        = string
}

variable "user_data_merge_strategy" {
  default     = "list(append)+dict(recurse_array)+str()"
  description = "Merge strategy to apply to user-data sections for cloud-init"
  type        = string
}

variable "fidc_api_key_id" {
  type        = string
  description = "ForgeRock Identity Cloud logging API key ID"
}

variable "fidc_api_key_secret" {
  type        = string
  description = "ForgeRock Identity Cloud logging API key secret"
}

variable "fidc_url" {
  type = string
}
