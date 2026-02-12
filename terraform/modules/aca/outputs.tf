output "container_app_id" {
  description = "ID del Container App (API)"
  value       = azurerm_container_app.api.id
}

output "container_app_name" {
  description = "Nombre del Container App"
  value       = azurerm_container_app.api.name
}

output "fqdn" {
  description = "FQDN de la API (URL pública)"
  value       = azurerm_container_app.api.latest_revision_fqdn
}

output "url" {
  description = "URL base de la API (https)"
  value       = "https://${azurerm_container_app.api.latest_revision_fqdn}"
}
