locals {
  # Imagen placeholder helloworld
  job_image = var.job_image != "" ? var.job_image : "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

resource "azurerm_container_app_job" "main" {
  name                         = "caj-${var.name_prefix}-maint-${var.environment}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  replica_timeout_in_seconds   = var.replica_timeout_in_seconds
  replica_retry_limit          = 3

  schedule_trigger_config {
    cron_expression          = var.cron_expression
    parallelism              = var.parallelism
    replica_completion_count = var.replica_completion_count
  }

  secret {
    name  = "acr-password"
    value = var.acr_admin_password
  }

  registry {
    server               = var.acr_login_server
    username             = var.acr_admin_username
    password_secret_name = "acr-password"
  }

  template {
    container {
      name   = "maintenance-job"
      image  = local.job_image
      cpu    = var.cpu
      memory = var.memory
    }
  }

  tags = {
    environment = var.environment
    project     = var.name_prefix
  }
}
