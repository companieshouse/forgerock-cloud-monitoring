data "template_cloudinit_config" "grafana" {
  count         = var.instance_count
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/system-config.yml.tpl", {
      instance_fqdn = "${var.service}-${var.environment}-grafana-${count.index + 1}.${var.dns_zone_name}"
    })
  }

  part {
    content_type = "text/cloud-config"
    # TODO There is a potential Terraform bug here—it should not be necessary to dynamically
    # lookup the map key for use as an index into the secret.data map itself. The secret.data
    # map contains a single JSON map, so ideally would
    # be used as the map itself however this does not currently appear to be possible
    content = templatefile("${path.module}/cloud-init/templates/ldap.toml.tpl",
    {
      grafana_service_group         = var.grafana_service_group
      grafana_service_user          = var.grafana_service_user
      ldap_auth_host                  = var.ldap_auth_host
      ldap_auth_port                  = var.ldap_auth_port
      ldap_auth_use_ssl               = var.ldap_auth_use_ssl
      ldap_auth_start_tls             = var.ldap_auth_start_tls
      ldap_auth_ssl_skip_verify       = var.ldap_auth_ssl_skip_verify
      ldap_auth_bind_dn               = var.ldap_auth_bind_dn
      ldap_auth_bind_password         = var.ldap_auth_bind_password
      ldap_auth_search_filter         = var.ldap_auth_search_filter
      ldap_auth_search_base_dns       = var.ldap_auth_search_base_dns
      ldap_grafana_admin_group_dn     = var.ldap_grafana_admin_group_dn
      ldap_grafana_viewer_group_dn    = var.ldap_grafana_viewer_group_dn
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/templates/grafana.ini.tpl",{
      grafana_admin_password        = var.grafana_admin_password
      grafana_service_group         = var.grafana_service_group
      grafana_service_user          = var.grafana_service_user
    })
    merge_type   = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
      lvm_block_devices       = var.lvm_block_devices
      root_volume_device_node = data.aws_ami.grafana.root_device_name
    })
  }
}
