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

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-k3s-demo-tf"
    storage_account_name = "stk3sdemotf"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-k3s-demo"
  location = var.location

  tags = {
    owner = var.owner
  }
}

resource "azurerm_user_assigned_identity" "demo" {
  name                = "id-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

resource "azurerm_log_analytics_workspace" "demo" {
  name                = "log-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

resource "azurerm_application_insights" "demo" {
  name                = "appi-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  workspace_id        = azurerm_log_analytics_workspace.demo.id
  application_type    = "other"
  retention_in_days   = 30
}

resource "azurerm_container_registry" "demo" {
  name                = "crk3sdemo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "demo_container_registry" {
  scope                = azurerm_container_registry.demo.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.demo.principal_id
}

resource "azurerm_virtual_network" "demo" {
  name                = "vnet-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo" {
  name                 = "snet-k3s-demo"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "demo" {
  name                = "pip-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "demo" {
  name                = "nic-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo.id
  }
}

resource "azurerm_network_security_group" "demo" {
  name                = "nsg-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "NATS"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4222"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "demo" {
  network_interface_id      = azurerm_network_interface.demo.id
  network_security_group_id = azurerm_network_security_group.demo.id
}

resource "azurerm_linux_virtual_machine" "demo" {
  name                            = "vm-k3s-demo"
  resource_group_name             = azurerm_resource_group.demo.name
  location                        = azurerm_resource_group.demo.location
  network_interface_ids           = [azurerm_network_interface.demo.id]
  size                            = "Standard_D2as_v5"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.demo.id]
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "disk-k3s-demo"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  custom_data = filebase64("cloud-init.yaml")

  lifecycle {
    ignore_changes = [
      admin_ssh_key,
    ]
  }
}

resource "azurerm_managed_disk" "demo" {
  name                 = "disk-k3s-demo-data"
  resource_group_name  = azurerm_resource_group.demo.name
  location             = azurerm_resource_group.demo.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_virtual_machine_data_disk_attachment" "demo" {
  virtual_machine_id = azurerm_linux_virtual_machine.demo.id
  managed_disk_id    = azurerm_managed_disk.demo.id
  lun                = "0"
  caching            = "ReadWrite"
}

output "vm_public_ip" {
  value = azurerm_public_ip.demo.ip_address
}

output "application_insights_connection_string" {
  value     = azurerm_application_insights.demo.connection_string
  sensitive = true
}

output "container_registry_login_server" {
  value = azurerm_container_registry.demo.login_server
}

output "container_registry_username" {
  value     = azurerm_container_registry.demo.admin_username
  sensitive = true
}

output "container_registry_password" {
  value     = azurerm_container_registry.demo.admin_password
  sensitive = true
}
