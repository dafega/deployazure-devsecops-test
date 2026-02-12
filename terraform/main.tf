# -----------------------------------------------------------------------------
# Data sources: resource group existente y cliente Azure (para Key Vault)
# -----------------------------------------------------------------------------
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# -----------------------------------------------------------------------------
# Módulo: Key Vault + secreto de prueba
# -----------------------------------------------------------------------------
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  name_prefix         = var.project_name
  environment         = var.environment
  test_secret_name    = var.key_vault_test_secret_name
  test_secret_value   = var.key_vault_test_secret_value
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

# -----------------------------------------------------------------------------
# Módulo: Azure Container Registry (ACR)
# -----------------------------------------------------------------------------
module "acr" {
  source = "./modules/acr"

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  name_prefix         = var.project_name
  environment         = var.environment
  sku                 = var.acr_sku
  admin_enabled       = true
}

# -----------------------------------------------------------------------------
# Módulo: Container App Environment
# -----------------------------------------------------------------------------
module "aca_environment" {
  source = "./modules/aca-environment"

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  name_prefix         = var.project_name
  environment         = var.environment
}

# -----------------------------------------------------------------------------
# Módulo: Container App (API + init container)
# -----------------------------------------------------------------------------
module "aca_api" {
  source = "./modules/aca"

  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  name_prefix                  = var.project_name
  environment                  = var.environment
  container_app_environment_id = module.aca_environment.environment_id
  acr_login_server             = module.acr.acr_login_server
  acr_admin_username           = module.acr.acr_admin_username
  acr_admin_password           = module.acr.acr_admin_password
  api_image                    = var.container_app_api_image
  init_image                   = var.container_app_init_image
  api_target_port              = 5000
  min_replicas                 = 1
  max_replicas                 = 3
}

# -----------------------------------------------------------------------------
# Módulo: Container App Job (mantenimiento / cron)
# -----------------------------------------------------------------------------
module "aca_job" {
  source = "./modules/aca-job"

  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  name_prefix                  = var.project_name
  environment                  = var.environment
  container_app_environment_id = module.aca_environment.environment_id
  acr_login_server             = module.acr.acr_login_server
  acr_admin_username           = module.acr.acr_admin_username
  acr_admin_password           = module.acr.acr_admin_password
  job_image                    = var.container_app_job_image
  cron_expression              = "*/2 * * * *" # cada 2 minutos (NCRONTAB 5 campos)
  replica_timeout_in_seconds   = 300
  parallelism                  = 1
  replica_completion_count     = 1
}
