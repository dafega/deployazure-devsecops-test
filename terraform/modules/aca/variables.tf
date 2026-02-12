variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "name_prefix" {
  description = "Prefijo para el Container App (API)"
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
  description = "Login server del ACR (ej. myacr.azurecr.io)"
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

variable "api_image" {
  description = "Imagen de la API (ej. myacr.azurecr.io/api:latest). Si está vacío se usa imagen placeholder."
  type        = string
  default     = ""
}

variable "init_image" {
  description = "Imagen del init container (ej. myacr.azurecr.io/init:latest). Si está vacío se usa imagen placeholder."
  type        = string
  default     = ""
}

variable "api_target_port" {
  description = "Puerto expuesto por la API"
  type        = number
  default     = 5000
}

variable "min_replicas" {
  description = "Mínimo de réplicas"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Máximo de réplicas"
  type        = number
  default     = 3
}

variable "cpu" {
  description = "CPU por contenedor (ej. 0.25)"
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memoria por contenedor (ej. 0.5Gi)"
  type        = string
  default     = "0.5Gi"
}

variable "app_my_secret_value" {
  description = "Valor para la variable de entorno MY_SECRET (p. ej. desde Key Vault). Si está vacío, MY_SECRET no se inyecta."
  type        = string
  default     = ""
  sensitive   = true
}
