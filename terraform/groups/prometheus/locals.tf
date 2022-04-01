data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.repository_name}"
}

locals {
  secrets = data.vault_generic_secret.secrets.data

  certificate_arn = contains(keys(local.secrets), "certificate_arn") ? local.secrets.certificate_arn : null
  discovery_availability_zones = join(",", list("${var.region}a", "${var.region}b", "${var.region}c"))
  dns_zone_name = local.secrets.dns_zone_name
  internal_cidrs = values(data.terraform_remote_state.networking.outputs.internal_cidrs)
  placement_subnet_availability_zones = [for subnet in values(data.aws_subnet.placement) : lookup(subnet, "availability_zone")]
  placement_subnet_name_patterns = jsondecode(local.secrets.placement_subnet_name_patterns)
  route53_available = local.secrets.route53_available
  ssh_keyname = "${var.service}-${var.environment}.pem"
  vpc_id = data.aws_vpc.vpc.id
  vpc_name = local.secrets.vpc_name
  vpn_cidrs = values(data.terraform_remote_state.networking.outputs.vpn_cidrs)

  administration_cidrs = concat(local.internal_cidrs, local.vpn_cidrs)
  placement_subnet_ids = [for subnet in values(data.aws_subnet.placement) : subnet.id]
  placement_subnet_cidrs = [for subnet in values(data.aws_subnet.placement) : subnet.cidr_block]
  placement_subnet_ids_by_availability_zone = values(zipmap(local.placement_subnet_availability_zones, local.placement_subnet_ids))

  prometheus_cidrs = concat(local.administration_cidrs, local.placement_subnet_cidrs)
}
