output "acr_id" {
  description = "ID del Container Registry"
  value       = azurerm_container_registry.main.id
}

output "acr_name" {
  description = "Nombre del Container Registry"
  value       = azurerm_container_registry.main.name
}

output "acr_login_server" {
  description = "URL del servidor de login (para docker push/pull)"
  value       = azurerm_container_registry.main.login_server
}

output "acr_admin_username" {
  description = "Usuario admin del ACR (si admin_enabled)"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Password admin del ACR (si admin_enabled)"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}
