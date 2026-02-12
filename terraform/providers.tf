terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-devsecops-test"
    storage_account_name = "sttfstatedevsecops"
    container_name       = "tfstate"
    key                  = "devsecops.terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {}
