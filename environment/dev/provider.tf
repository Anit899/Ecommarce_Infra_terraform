terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "anrg01"
    storage_account_name = "novastg01"
    container_name       = "nova-container"
    key                  = "dev-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "818db7f4-d80e-42f3-ae3e-b98232ed02c0"

}