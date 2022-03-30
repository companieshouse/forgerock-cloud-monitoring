data "template_cloudinit_config" "prometheus" {
  count         = var.instance_count

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/system-config.yml.tpl", {
      instance_fqdn = "${var.service}-${var.environment}-prometheus-${count.index + 1}.${var.dns_zone_name}"
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type              = "text/cloud-config"
    content                   = templatefile("${path.module}/cloud-init/templates/prometheus.yml.tpl", {
      environment             = var.environment
      prometheus_metrics_port = var.prometheus_metrics_port
      region                  = var.region
      api_key_id              = var.api_key_id
      api_key_secret          = var.api_key_secret
      fidc_domain             = var.fidc_domain
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type    = "text/cloud-config"
    content         =  templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
      lvm_block_devices       = var.lvm_block_devices
      root_volume_device_node = data.aws_ami.prometheus.root_device_name
    })
  }
}
