locals {
  # Imagen placeholder para que terraform apply funcione antes del primer push
  api_image  = var.api_image != "" ? var.api_image : "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
  init_image = var.init_image != "" ? var.init_image : "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

resource "azurerm_container_app" "api" {
  name                         = "ca-${var.name_prefix}-api-${var.environment}"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

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
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    init_container {
      name   = "init-migrations"
      image  = local.init_image
      cpu    = 0.25
      memory = "0.5Gi"
    }

    container {
      name   = "api"
      image  = local.api_image
      cpu    = var.cpu
      memory = var.memory

      liveness_probe {
        transport        = "HTTP"
        path             = "/api/bicycles/health"
        port             = var.api_target_port
        initial_delay    = 10
        interval_seconds = 10
      }

      readiness_probe {
        transport               = "HTTP"
        path                    = "/api/bicycles/health"
        port                    = var.api_target_port
        interval_seconds        = 5
        success_count_threshold = 1
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.api_target_port
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    environment = var.environment
    project     = var.name_prefix
  }
}
