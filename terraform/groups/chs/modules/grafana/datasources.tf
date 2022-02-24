resource "grafana_data_source" "cloudwatch" {
 type = "cloudwatch"
 name = "${var.service_name}-cloudwatch"

 json_data {
  default_region = var.region
  auth_type = "keys"
 }

 secure_json_data {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_access_key
 }
}