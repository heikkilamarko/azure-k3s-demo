variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources in. Example: West Europe"
  type        = string
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

data "azurerm_public_ip" "demo" {
  name                = "pip-k3s-demo"
  resource_group_name = "rg-k3s-demo"
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-k3s-demo-app"
  location = var.location
}

resource "random_password" "demo_postgresql" {
  length  = 8
  special = false
}

resource "azurerm_postgresql_flexible_server" "demo" {
  name                   = "psql-k3s-demo-app"
  resource_group_name    = azurerm_resource_group.demo.name
  location               = azurerm_resource_group.demo.location
  version                = "16"
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"
  storage_mb             = 32768
  storage_tier           = "P4"
  administrator_login    = "psqladmin"
  administrator_password = random_password.demo_postgresql.result
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "demo_vm" {
  name             = "fwr-k3s-demo-vm"
  server_id        = azurerm_postgresql_flexible_server.demo.id
  start_ip_address = data.azurerm_public_ip.demo.ip_address
  end_ip_address   = data.azurerm_public_ip.demo.ip_address
}

resource "azurerm_postgresql_flexible_server_database" "demo" {
  name      = "demo"
  server_id = azurerm_postgresql_flexible_server.demo.id

  # lifecycle {
  #   prevent_destroy = true
  # }
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.demo.fqdn
}

output "postgresql_administrator_login" {
  value = azurerm_postgresql_flexible_server.demo.administrator_login
}

output "postgresql_administrator_password" {
  value     = azurerm_postgresql_flexible_server.demo.administrator_password
  sensitive = true
}
