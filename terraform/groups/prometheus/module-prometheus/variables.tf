variable "ami_owner_id" {
  type        = string
  description = "The ID of the AMI owner"
}

variable "ami_version_pattern" {
  description = "The pattern with which to match AMIs"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the certificate we'll use"
  type        = string
}

variable "discovery_availability_zones" {
  description = "A list of availability zones in which to search for master nodes"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone we're using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "instance_count" {
  description = "The number of prometheus instances to provision"
  type        = number
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "lvm_block_devices" {
  description = "A list of objects representing LVM block devices; each LVM volume group is assumed to contain a single physical volume and each logical volume is assumed to belong to a single volume group; the filesystem for each logical volume will be expanded to use all available space within the volume group using the filesystem resize tool specified; block device configuration applies only on resource creation"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
}

variable "placement_subnet_ids" {
  description = "The ids of the subnets into which we'll place prometheus instances"
  type = list(string)
}

variable "prometheus_cidrs" {
  description = "A list of CIDR blocks to permit prometheus access from"
  type        = list(string)
}

variable "prometheus_metrics_port" {
  description = "The metrics port to be used"
  type = string
}

variable "prometheus_service_group" {
  description = "The Linux group name for association with prometheus configuration files"
  type        = string
}

variable "prometheus_service_user" {
  description = "The Linux username for ownership of prometheus configuration files"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be administered"
  type        = string
}

variable "root_volume_size" {
  description = "The size of the root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed"
  type        = number
}

variable "route53_available" {
  description = "A flag indicating whether Route53 is available"
  type        = bool
}

variable "service" {
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "ssh_cidrs" {
  description = "The SSH of the CIDR to be used"
  type = list(string)
}

variable "ssh_keyname" {
  description = "The SSH keypair name to use for remote connectivity"
  type        = string
}

variable "subnet_ids" {
  description = "The ids of the subnets into which we'll place instances"
  type        = list(string)
}

variable "user_data_merge_strategy" {
  description = "Merge strategy to apply to user-data sections for cloud-init"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID in which to create resources"
  type        = string
}
