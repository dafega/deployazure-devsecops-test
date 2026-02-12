output "job_id" {
  description = "ID del Container App Job"
  value       = azurerm_container_app_job.main.id
}

output "job_name" {
  description = "Nombre del Container App Job"
  value       = azurerm_container_app_job.main.name
}
