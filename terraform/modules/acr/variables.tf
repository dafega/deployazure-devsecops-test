variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "name_prefix" {
  description = "Prefijo para el nombre del ACR (solo alfanuméricos, único globalmente)"
  type        = string
}

variable "environment" {
  description = "Entorno (staging, production)"
  type        = string
  default     = "staging"
}

variable "sku" {
  description = "SKU del Container Registry (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Habilitar usuario admin del ACR (para pulls desde Container Apps)"
  type        = bool
  default     = true
}
