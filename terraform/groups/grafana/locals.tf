data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.repository_name}"
}

locals {
  secrets = data.vault_generic_secret.secrets.data

  certificate_arn = contains(keys(local.secrets), "certificate_arn") ? local.secrets.certificate_arn : null
  concourse_worker_cidrs = jsondecode(local.secrets.concourse_worker_cidrs)
  dns_zone_name = local.secrets.dns_zone_name
  grafana_admin_password = local.secrets.grafana_admin_password
  internal_cidrs = values(data.terraform_remote_state.networking.outputs.internal_cidrs)
  ldap_auth_bind_dn = local.secrets.ldap_auth_bind_dn
  ldap_auth_bind_password = local.secrets.ldap_auth_bind_password
  ldap_auth_host = local.secrets.ldap_auth_host
  ldap_auth_port = local.secrets.ldap_auth_port
  ldap_auth_search_base_dns = local.secrets.ldap_auth_search_base_dns
  ldap_auth_search_filter = local.secrets.ldap_auth_search_filter
  ldap_grafana_admin_group_dn = local.secrets.ldap_grafana_admin_group_dn
  ldap_grafana_viewer_group_dn = local.secrets.ldap_grafana_viewer_group_dn
  placement_subnet_availability_zones = [for subnet in values(data.aws_subnet.placement) : lookup(subnet, "availability_zone")]
  placement_subnet_name_patterns = jsondecode(local.secrets.placement_subnet_name_patterns)
  route53_available = local.secrets.route53_available
  ssh_keyname = "${var.service}-${var.environment}.pem"
  vpc_id = data.aws_vpc.vpc.id
  vpc_name = local.secrets.vpc_name
  vpn_cidrs = values(data.terraform_remote_state.networking.outputs.vpn_cidrs)

  administration_cidrs = concat(local.internal_cidrs, local.vpn_cidrs)
  placement_subnet_ids = [for subnet in values(data.aws_subnet.placement) : lookup(subnet, "id")]
  placement_subnet_ids_by_availability_zone = values(zipmap(local.placement_subnet_availability_zones, local.placement_subnet_ids))

  grafana_cidrs = concat(local.administration_cidrs, local.concourse_worker_cidrs)
}
