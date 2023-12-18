terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "t-clo-901-mpl-2"
    storage_account_name = "atclo901mpl23060"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}