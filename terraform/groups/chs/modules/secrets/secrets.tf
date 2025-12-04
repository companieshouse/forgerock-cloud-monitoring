resource "aws_ssm_parameter" "secret_parameters" {
  for_each    = var.secrets
  name        = "/${var.name_prefix}/${each.key}"
  description = each.key
  type        = "SecureString"
  overwrite   = "true"
  value       = each.value
}
