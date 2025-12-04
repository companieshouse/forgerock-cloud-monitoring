data "vault_generic_secret" "secrets" {
  path = "applications/${var.environment}-${var.region}/chs/${var.service_name}"
}
