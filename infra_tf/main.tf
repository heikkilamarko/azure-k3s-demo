variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources in. Example: West Europe"
  type        = string
}

variable "owner" {
  description = "Owner of the resources, used for tagging"
  type        = string
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-k3s-demo-tf"
  location = var.location

  tags = {
    owner = var.owner
  }
}

resource "azurerm_storage_account" "demo" {
  name                            = "stk3sdemotf"
  resource_group_name             = azurerm_resource_group.demo.name
  location                        = azurerm_resource_group.demo.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "demo" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.demo.id
  container_access_type = "private"
}
