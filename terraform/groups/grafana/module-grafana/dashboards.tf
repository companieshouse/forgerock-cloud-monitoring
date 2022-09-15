// Create a dashboard for each json file found in the dashboards directory
resource "grafana_dashboard" "dashboard" {
    for_each = fileset(path.module, "dashboards/*.json")
    config_json = file("${path.module}/${each.key}")
}
