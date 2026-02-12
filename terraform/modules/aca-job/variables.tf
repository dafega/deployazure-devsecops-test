variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "name_prefix" {
  description = "Prefijo para el Container App Job"
  type        = string
}

variable "environment" {
  description = "Entorno (staging, production)"
  type        = string
  default     = "staging"
}

variable "container_app_environment_id" {
  description = "ID del Container App Environment"
  type        = string
}

variable "acr_login_server" {
  description = "Login server del ACR"
  type        = string
}

variable "acr_admin_username" {
  description = "Usuario admin del ACR"
  type        = string
  sensitive   = true
}

variable "acr_admin_password" {
  description = "Password admin del ACR"
  type        = string
  sensitive   = true
}

variable "job_image" {
  description = "Imagen del job (ej. myacr.azurecr.io/job:latest). Si está vacío se usa placeholder."
  type        = string
  default     = ""
}

variable "cron_expression" {
  description = "Expresión cron cada 2 min"
  type        = string
  default     = "*/2 * * * *"
}

variable "replica_timeout_in_seconds" {
  description = "Timeout en segundos por réplica del job"
  type        = number
  default     = 300
}

variable "parallelism" {
  description = "Número de réplicas en paralelo del job"
  type        = number
  default     = 1
}

variable "replica_completion_count" {
  description = "Número de réplicas que deben completarse para considerar el job exitoso"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU por contenedor"
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memoria por contenedor (ej. 0.5Gi)"
  type        = string
  default     = "0.5Gi"
}
