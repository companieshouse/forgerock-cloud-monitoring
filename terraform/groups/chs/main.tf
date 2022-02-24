###
# Data lookups
###
data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["*-applications-*"]
  }
}

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

module "alerting" {
  source                 = "./modules/sns"
  service_name           = var.service_name
  alerting_email_address = var.alerting_email_address
  tags                   = local.common_tags
}

module "ecs" {
  source       = "./modules/ecs"
  service_name = var.service_name
  vpc_id       = data.aws_vpc.vpc.id
  tags         = local.common_tags
}

module "idm_logging" {
  source                     = "./modules/ecs-task"
  depends_on                 = [module.cloudwatch]
  region                     = var.region
  task_name                  = "idm_logging"
  subnet_ids                 = data.aws_subnet_ids.subnets.ids
  ecs_cluster_id             = module.ecs.cluster_id
  ecs_task_role_arn          = module.ecs.task_role_arn
  ecs_task_security_group_id = module.ecs.task_security_group_id
  container_image_version    = "logging-${var.container_image_version}"
  ecr_url                    = var.ecr_url
  task_cpu                   = var.task_cpu
  task_memory                = var.task_memory
  fidc_url                   = var.fidc_url
  fidc_api_key_id            = var.fidc_api_key_id
  fidc_api_key_secret        = var.fidc_api_key_secret
  log_group_name             = var.service_name
  log_prefix                 = "idm_logging"
  tags                       = local.common_tags
}

module "rcs_monitoring" {
  source                   = "./modules/cloudwatch-canary"
  region                   = var.region
  environment              = var.environment
  service_name             = var.service_name
  canary_name              = "fr-rcs"
  release_version          = var.container_image_version
  handler                  = "index.handler"
  runtime_version          = "syn-nodejs-puppeteer-3.3"
  release_bucket           = var.release_bucket
  source_code_path         = "${path.module}/scripts/rcs-monitoring"
  artifact_bucket          = module.cloudwatch.canary_artifact_bucket
  role_arn                 = module.cloudwatch.canary_role_arn
  health_check_rate        = var.health_check_rate
  fidc_url                 = var.fidc_url
  fidc_user                = var.fidc_user
  fidc_password            = var.fidc_password
  fidc_admin_client        = var.fidc_admin_client
  fidc_admin_client_secret = var.fidc_admin_client_secret
  fidc_monitored_component = var.fidc_connector_group
  recon_duration           = var.recon_duration
  cancel_recon_after       = var.cancel_recon_after
  sns_topic_arn            = module.alerting.sns_topic_arn
  tags                     = local.common_tags
}

module "mappings_monitoring" {
  source                   = "./modules/cloudwatch-canary"
  region                   = var.region
  environment              = var.environment
  service_name             = var.service_name
  canary_name              = "fr-mappings"
  release_version          = var.container_image_version
  source_code_path         = "${path.module}/scripts/mappings-monitoring"
  handler                  = "index.handler"
  runtime_version          = "syn-nodejs-puppeteer-3.3"
  release_bucket           = var.release_bucket
  artifact_bucket          = module.cloudwatch.canary_artifact_bucket
  role_arn                 = module.cloudwatch.canary_role_arn
  health_check_rate        = var.health_check_rate
  fidc_url                 = var.fidc_url
  fidc_user                = var.fidc_user
  fidc_password            = var.fidc_password
  fidc_admin_client        = var.fidc_admin_client
  fidc_admin_client_secret = var.fidc_admin_client_secret
  fidc_monitored_component = var.fidc_mappings
  recon_duration           = var.recon_duration
  cancel_recon_after       = var.cancel_recon_after
  sns_topic_arn            = module.alerting.sns_topic_arn
  tags                     = local.common_tags
}

module "connectors_monitoring" {
  source                   = "./modules/cloudwatch-canary"
  region                   = var.region
  environment              = var.environment
  service_name             = var.service_name
  canary_name              = "fr-connectors"
  release_version          = var.container_image_version
  source_code_path         = "${path.module}/scripts/mappings-monitoring"
  handler                  = "index.handler"
  runtime_version          = "syn-nodejs-puppeteer-3.3"
  release_bucket           = var.release_bucket
  artifact_bucket          = module.cloudwatch.canary_artifact_bucket
  role_arn                 = module.cloudwatch.canary_role_arn
  health_check_rate        = var.health_check_rate
  fidc_url                 = var.fidc_url
  fidc_user                = var.fidc_user
  fidc_password            = var.fidc_password
  fidc_admin_client        = var.fidc_admin_client
  fidc_admin_client_secret = var.fidc_admin_client_secret
  fidc_monitored_component = var.monitored_connectors
  recon_duration           = var.recon_duration
  cancel_recon_after       = var.cancel_recon_after
  sns_topic_arn            = module.alerting.sns_topic_arn
  tags                     = local.common_tags
}

module "reconDuration" {
  source                   = "./modules/cloudwatch-canary"
  region                   = var.region
  environment              = var.environment
  service_name             = var.service_name
  canary_name              = "fr-recon-duration"
  release_version          = var.container_image_version
  source_code_path         = "${path.module}/scripts/mappings-monitoring"
  handler                  = "index.handler"
  runtime_version          = "syn-nodejs-puppeteer-3.3"
  release_bucket           = var.release_bucket
  artifact_bucket          = module.cloudwatch.canary_artifact_bucket
  role_arn                 = module.cloudwatch.canary_role_arn
  health_check_rate        = var.health_check_rate
  fidc_url                 = var.fidc_url
  fidc_user                = var.fidc_user
  fidc_password            = var.fidc_password
  fidc_admin_client        = var.fidc_admin_client
  fidc_admin_client_secret = var.fidc_admin_client_secret
  fidc_monitored_component = var.fidc_mappings
  recon_duration           = var.recon_duration
  cancel_recon_after       = var.cancel_recon_after
  sns_topic_arn            = module.alerting.sns_topic_arn
  tags                     = local.common_tags
}

module "cancelRecon" {
  source                   = "./modules/cloudwatch-canary"
  region                   = var.region
  environment              = var.environment
  service_name             = var.service_name
  canary_name              = "fr-cancel-recon-after"
  release_version          = var.container_image_version
  source_code_path         = "${path.module}/scripts/mappings-monitoring"
  handler                  = "index.handler"
  runtime_version          = "syn-nodejs-puppeteer-3.3"
  release_bucket           = var.release_bucket
  artifact_bucket          = module.cloudwatch.canary_artifact_bucket
  role_arn                 = module.cloudwatch.canary_role_arn
  health_check_rate        = var.health_check_rate
  fidc_url                 = var.fidc_url
  fidc_user                = var.fidc_user
  fidc_password            = var.fidc_password
  fidc_admin_client        = var.fidc_admin_client
  fidc_admin_client_secret = var.fidc_admin_client_secret
  fidc_monitored_component = var.fidc_mappings
  recon_duration           = var.recon_duration
  cancel_recon_after       = var.cancel_recon_after
  sns_topic_arn            = module.alerting.sns_topic_arn
  tags                     = local.common_tags
}

module "grafana" {
  source                = "./modules/grafana"
  service_name          = "forgerock"
  region                = var.region
  vpc_id                = data.aws_vpc.vpc.id
  subnet_ids            = data.aws_subnet_ids.subnets.ids
  instance_type         = var.grafana_instance_type
  vpn_cidrs             = values(data.terraform_remote_state.networking.outputs.vpn_cidrs)
  ami_account_id        = var.ami_account_id
  domain_name           = var.domain_name
  create_route53_record = var.create_route53_record
  route53_zone          = var.route53_zone
  create_certificate    = var.create_certificate
  certificate_domain    = var.certificate_domain
  aws_access_key        = var.aws_access_key
  aws_secret_access_key = var.aws_secret_access_key
  # grafana_auth          = var.grafana_auth
  tags = local.common_tags
}

module "prometheus" {
  source                = "./modules/prometheus"
  service_name          = "forgerock"
  vpc_id                = data.aws_vpc.vpc.id
  subnet_ids            = data.aws_subnet_ids.subnets.ids
  instance_type         = var.prometheus_instance_type
  vpn_cidrs             = values(data.terraform_remote_state.networking.outputs.vpn_cidrs)
  api_key_id            = var.fidc_api_key_id
  api_key_secret        = var.fidc_api_key_secret
  fidc_domain           = replace(var.fidc_url, "https://", "")
  grafana_ip            = module.grafana.private_ip
  ami_account_id        = var.ami_account_id
  domain_name           = var.domain_name
  create_route53_record = var.create_route53_record
  route53_zone          = var.route53_zone
  create_certificate    = var.create_certificate
  certificate_domain    = var.certificate_domain
  tags                  = local.common_tags
}

