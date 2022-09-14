provider "grafana" {
    url = "https://${aws_lb.grafana.dns_name}"
    auth = "${var.grafana_service_user}:${var.grafana_service_password}"
}

resource "grafana_dashboard" "dashboard" {
    for_each = fileset(path.module, "dashboards/*.json")
    config_json = file("${path.module}/${each.key}")
}
