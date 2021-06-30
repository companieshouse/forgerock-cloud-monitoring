###
# Modules
###
module "cloudwatch" {
  source            = "./modules/cloudwatch"
  region            = var.region
  environment       = var.environment
  service_name      = var.service_name
  retention_in_days = var.log_retention_in_days
  tags              = local.common_tags
}
