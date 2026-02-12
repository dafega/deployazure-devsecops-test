output "environment_id" {
  description = "ID del Container App Environment"
  value       = azurerm_container_app_environment.main.id
}

output "environment_name" {
  description = "Nombre del Container App Environment"
  value       = azurerm_container_app_environment.main.name
}

output "default_domain" {
  description = "Dominio por defecto del environment"
  value       = azurerm_container_app_environment.main.default_domain
}

output "static_ip_address" {
  description = "IP estática outbound del environment"
  value       = azurerm_container_app_environment.main.static_ip_address
}

output "log_analytics_workspace_id" {
  description = "ID del Log Analytics usado"
  value       = local.log_analytics_id
}
