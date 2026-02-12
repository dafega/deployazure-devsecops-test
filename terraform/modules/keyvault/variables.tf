variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "name_prefix" {
  description = "Prefijo para el nombre del Key Vault (el nombre debe ser único globalmente)"
  type        = string
}

variable "environment" {
  description = "Entorno (staging, production)"
  type        = string
  default     = "staging"
}

variable "test_secret_name" {
  description = "Nombre del secreto de prueba"
  type        = string
  default     = "test-secret"
}

variable "test_secret_value" {
  description = "Valor del secreto de prueba"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Tenant ID de Azure AD (para access policy del deployer)"
  type        = string
}

variable "object_id" {
  description = "Object ID (usuario o service principal) con acceso al Key Vault"
  type        = string
}
