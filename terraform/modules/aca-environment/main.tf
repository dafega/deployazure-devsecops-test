resource "azurerm_log_analytics_workspace" "main" {
  count               = var.log_analytics_workspace_id == null ? 1 : 0
  name                = "log-${var.name_prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
    project     = var.name_prefix
  }
}

locals {
  log_analytics_id = coalesce(
    var.log_analytics_workspace_id,
    try(azurerm_log_analytics_workspace.main[0].id, null)
  )
}

resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.name_prefix}-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = local.log_analytics_id
  # Sin internal_load_balancer: usa LB externo (no requiere VNet/subnet).
  # Para LB interno haría falta infrastructure_subnet_id.

  tags = {
    environment = var.environment
    project     = var.name_prefix
  }
}
