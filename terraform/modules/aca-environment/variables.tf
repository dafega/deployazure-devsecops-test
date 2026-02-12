variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "name_prefix" {
  description = "Prefijo para el Container App Environment"
  type        = string
}

variable "environment" {
  description = "Entorno (staging, production)"
  type        = string
  default     = "staging"
}

variable "log_analytics_workspace_id" {
  description = "ID del Log Analytics Workspace (opcional). Si no se pasa, se crea uno interno."
  type        = string
  default     = null
}
