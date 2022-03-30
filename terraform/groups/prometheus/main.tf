provider "aws" {
  region  = var.region
  version = "~> 2.0"
}

terraform {
  backend "s3" {}
}

module "prometheus" {
  source = "./module-prometheus"

  ami_owner_id                  = var.ami_owner_id
  ami_version_pattern           = var.prometheus_ami_version_pattern
  certificate_arn               = local.certificate_arn
  discovery_availability_zones  = local.discovery_availability_zones
  dns_zone_name                 = local.dns_zone_name
  environment                   = var.environment
  instance_count                = var.prometheus_instance_count
  instance_type                 = var.prometheus_instance_type
  prometheus_cidrs              = local.prometheus_cidrs
  prometheus_service_group      = var.prometheus_service_group
  prometheus_service_user       = var.prometheus_service_user
  lvm_block_devices             = var.prometheus_lvm_block_devices
  placement_subnet_ids          = data.aws_subnet_ids.placement.ids
  prometheus_metrics_port       = var.prometheus_metrics_port
  region                        = var.region
  root_volume_size              = var.prometheus_root_volume_size
  route53_available             = local.route53_available
  service                       = var.service
  ssh_cidrs                     = local.administration_cidrs
  ssh_keyname                   = local.ssh_keyname
  subnet_ids                    = local.placement_subnet_ids_by_availability_zone
  user_data_merge_strategy      = var.user_data_merge_strategy
  vpc_id                        = data.aws_vpc.vpc.id
  api_key_id                    = var.fidc_api_key_id
  api_key_secret                = var.fidc_api_key_secret
  fidc_domain                   = replace(var.fidc_url, "https://", "")
}
