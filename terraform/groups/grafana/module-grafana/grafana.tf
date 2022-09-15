provider "grafana" {
    url = "https://${aws_lb.grafana.dns_name}"
    auth = "${var.grafana_service_user}:${var.grafana_service_password}"
}