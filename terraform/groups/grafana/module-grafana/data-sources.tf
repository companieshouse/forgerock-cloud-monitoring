resource "grafana_data_source" "forgerock-prometheus" {
    type = "prometheus"
    name = "Prometheus"

    url = var.prometheus_instances[var.environment]
}

resource "grafana_data_source" "cloudwatch" {
    type = "cloudwatch"
    name = "CloudWatch"

    json_data {
      custom_metrics_namespaces = "CloudWatchSynthetics"
    }
}