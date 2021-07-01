data "template_cloudinit_config" "grafana" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/bootstrap-commands.yml.tpl", {
      root_volume_device_node = data.aws_ami.grafana.root_device_name
    })
  }
}
