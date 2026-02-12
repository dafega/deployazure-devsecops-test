output "key_vault_id" {
  description = "ID del Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI del Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "test_secret_name" {
  description = "Nombre del secreto de prueba"
  value       = azurerm_key_vault_secret.test.name
}

output "test_secret_id" {
  description = "ID del secreto de prueba (para referencias)"
  value       = azurerm_key_vault_secret.test.id
}
