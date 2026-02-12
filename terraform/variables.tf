variable "resource_group_name" {
  description = "Nombre del resource group existente (ej. rg-devsecops-test)"
  type        = string
  default     = "rg-devsecops-test"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Entorno corto para nombres (ej. stag, prod, dev)"
  type        = string
  default     = "stag"
}

variable "project_name" {
  description = "Nombre para prefijos de recursos"
  type        = string
  default     = "devsecops"
}

variable "acr_sku" {
  description = "SKU del Container Registry (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "container_app_api_image" {
  description = "Imagen de la API (ej. acr.azurecr.io/api:latest). Se puede dejar placeholder para aplicar después del primer push."
  type        = string
  default     = ""
}

variable "container_app_init_image" {
  description = "Imagen del init container (ej. acr.azurecr.io/init:latest)"
  type        = string
  default     = ""
}

variable "container_app_job_image" {
  description = "Imagen del job (ej. acr.azurecr.io/job:latest)"
  type        = string
  default     = ""
}

variable "key_vault_test_secret_value" {
  description = "Valor del secreto de prueba en Key Vault (sensible)"
  type        = string
  default     = "test-secret-value-from-terraform"
  sensitive   = true
}

variable "key_vault_test_secret_name" {
  description = "Nombre del secreto de prueba en Key Vault"
  type        = string
  default     = "test-secret"
}
