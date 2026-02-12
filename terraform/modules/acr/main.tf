resource "azurerm_container_registry" "main" {
  name                = "acr${var.name_prefix}${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  tags = {
    environment = var.environment
    project     = var.name_prefix
  }
}
