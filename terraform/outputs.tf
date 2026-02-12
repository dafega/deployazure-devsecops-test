# -----------------------------------------------------------------------------
# Key Vault
# -----------------------------------------------------------------------------
output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "URI del Key Vault"
  value       = module.keyvault.key_vault_uri
}

output "key_vault_test_secret_name" {
  description = "Nombre del secreto de prueba"
  value       = module.keyvault.test_secret_name
}

# -----------------------------------------------------------------------------
# ACR
# -----------------------------------------------------------------------------
output "acr_name" {
  description = "Nombre del Azure Container Registry"
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "Login server del ACR (para docker login y push)"
  value       = module.acr.acr_login_server
}

# -----------------------------------------------------------------------------
# Container App Environment
# -----------------------------------------------------------------------------
output "container_app_environment_name" {
  description = "Nombre del Container App Environment"
  value       = module.aca_environment.environment_name
}

# -----------------------------------------------------------------------------
# Container App (API)
# -----------------------------------------------------------------------------
output "api_container_app_name" {
  description = "Nombre del Container App (API)"
  value       = module.aca_api.container_app_name
}

output "api_url" {
  description = "URL pública de la API"
  value       = module.aca_api.url
}

output "api_fqdn" {
  description = "FQDN de la API"
  value       = module.aca_api.fqdn
}

# -----------------------------------------------------------------------------
# Container App Job
# -----------------------------------------------------------------------------
output "job_name" {
  description = "Nombre del Container App Job"
  value       = module.aca_job.job_name
}

# -----------------------------------------------------------------------------
# Resumen para CD / GitHub Actions
# -----------------------------------------------------------------------------
output "deploy_summary" {
  description = "Resumen para configurar CD (vars de GitHub)"
  value = {
    acr_login_server = module.acr.acr_login_server
    api_url          = module.aca_api.url
    key_vault_name   = module.keyvault.key_vault_name
  }
}
