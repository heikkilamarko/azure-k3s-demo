variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-k3s-demo"
  location = "West Europe"
}

resource "azurerm_user_assigned_identity" "demo" {
  name                = "id-k3s-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
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
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
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
    name                       = "HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
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
  size                            = "Standard_F2"
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
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server-gen1"
    version   = "latest"
  }

  custom_data = filebase64("cloud-init.sh")
}

output "vm_public_ip" {
  value = azurerm_public_ip.demo.ip_address
}
