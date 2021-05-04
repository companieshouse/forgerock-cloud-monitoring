data "template_cloudinit_config" "prometheus" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/bootstrap-commands.yml.tpl", {
      API_KEY_ID     = var.api_key_id
      API_KEY_SECRET = var.api_key_secret
      TENANT_DOMAIN  = var.fidc_domain
    })
  }
}
