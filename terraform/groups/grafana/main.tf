terraform {
  required_version = ">= 0.13.0, < 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0, < 4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "grafana" {
  source = "./module-grafana"

  admin_prefix_list_id          = data.aws_ec2_managed_prefix_list.admin_cidrs.id
  ami_owner_id                  = var.ami_owner_id
  ami_version_pattern           = var.grafana_ami_version_pattern
  certificate_arn               = local.certificate_arn
  dns_zone_name                 = local.dns_zone_name
  environment                   = var.environment
  instance_count                = var.grafana_instance_count
  instance_type                 = var.grafana_instance_type
  grafana_cidrs                 = local.concourse_worker_cidrs
  grafana_service_group         = var.grafana_service_group
  grafana_service_user          = var.grafana_service_user
  grafana_admin_password        = local.grafana_admin_password
  ldap_auth_host                = local.ldap_auth_host
  ldap_auth_port                = local.ldap_auth_port
  ldap_auth_use_ssl             = var.ldap_auth_use_ssl
  ldap_auth_start_tls           = var.ldap_auth_start_tls
  ldap_auth_ssl_skip_verify     = var.ldap_auth_ssl_skip_verify
  ldap_auth_bind_dn             = local.ldap_auth_bind_dn
  ldap_auth_bind_password       = local.ldap_auth_bind_password
  ldap_auth_search_filter       = local.ldap_auth_search_filter
  ldap_auth_search_base_dns     = local.ldap_auth_search_base_dns
  ldap_grafana_admin_group_dn   = local.ldap_grafana_admin_group_dn
  ldap_grafana_viewer_group_dn  = local.ldap_grafana_viewer_group_dn
  lvm_block_devices             = var.grafana_lvm_block_devices
  placement_subnet_ids          = data.aws_subnet_ids.placement.ids
  region                        = var.region
  root_volume_size              = var.grafana_root_volume_size
  route53_available             = local.route53_available
  service                       = var.service
  ssh_keyname                   = local.ssh_keyname
  subnet_ids                    = local.placement_subnet_ids_by_availability_zone
  user_data_merge_strategy      = var.user_data_merge_strategy
  vpc_id                        = data.aws_vpc.vpc.id
}
