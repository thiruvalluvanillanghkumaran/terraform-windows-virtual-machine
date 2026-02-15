# Created with Terraform v1.5.6
######################################################################################################
# Created by Illanghkumaran Thiruvalluvan on 16/02/2026
# Purpose: Terraform script to create an Azure Resource Group,
#          Virtual Network, Subnet, and Windows Server Creation.
######################################################################################################

# Create a Resource Group
resource "azurerm_resource_group" "rg_windows" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet_windows" {
  name                = "vnet-windows"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_windows.location
  resource_group_name = azurerm_resource_group.rg_windows.name
}

# Create a Subnet
resource "azurerm_subnet" "subnet_windows" {
  name                 = "snet-windows"
  resource_group_name  = azurerm_resource_group.rg_windows.name
  virtual_network_name = azurerm_virtual_network.vnet_windows.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP for windows VM
resource "azurerm_public_ip" "pip_windows" {
  name                = "pip-windows"
  location            = azurerm_resource_group.rg_windows.location
  resource_group_name = azurerm_resource_group.rg_windows.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Create Network Security Group and rules
resource "azurerm_network_security_group" "nsg_windows" {
  name                = "nsg-windows"
  location            = azurerm_resource_group.rg_windows.location
  resource_group_name = azurerm_resource_group.rg_windows.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface for windows VM
resource "azurerm_network_interface" "nic_windows" {
  name                = "nic-windows"
  location            = azurerm_resource_group.rg_windows.location
  resource_group_name = azurerm_resource_group.rg_windows.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_windows.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_windows.id
  }

}

# Connect the security group to network interface
resource "azurerm_network_interface_security_group_association" "nsg_assoc_windows" {
  network_interface_id      = azurerm_network_interface.nic_windows.id
  network_security_group_id = azurerm_network_security_group.nsg_windows.id
}

# Generate unique suffix for storage account
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false

  keepers = {
    rg_id = azurerm_resource_group.rg_windows.id
  }
}

# Create storage account for windows VM
resource "azurerm_storage_account" "stg_windows" {
  name                     = "stgads3uwin${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_windows.name
  location                 = azurerm_resource_group.rg_windows.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create Virtual Machine for Windows VM
resource "azurerm_windows_virtual_machine" "vm_windows" {
  name                  = "vm-windows"
  resource_group_name   = azurerm_resource_group.rg_windows.name
  location              = azurerm_resource_group.rg_windows.location
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic_windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stg_windows.primary_blob_endpoint
  }
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}

variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
  default     = "myapp"
}
