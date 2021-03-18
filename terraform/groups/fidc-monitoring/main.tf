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
  service_name      = var.service_name
  retention_in_days = var.log_retention_in_days
}

module "ecs" {
  source       = "./modules/ecs"
  service_name = var.service_name
  vpc_id       = data.aws_vpc.vpc.id
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
  container_image_version    = var.container_image_version
  ecr_url                    = var.ecr_url
  task_cpu                   = var.task_cpu
  task_memory                = var.task_memory
  fidc_url                   = var.fidc_url
  fidc_api_key_id            = var.fidc_api_key_id
  fidc_api_key_secret        = var.fidc_api_key_secret
  log_group_name             = var.service_name
  log_prefix                 = "idm_logging"
}
