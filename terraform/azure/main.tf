provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "bankpro_rg" {
  name     = "bankpro-rg"
  location = var.azure_region
}

resource "azurerm_virtual_network" "bankpro_vnet" {
  name                = "bankpro-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.bankpro_rg.name
}

resource "azurerm_subnet" "bankpro_subnet" {
  name                 = "bankpro-subnet"
  resource_group_name  = azurerm_resource_group.bankpro_rg.name
  virtual_network_name = azurerm_virtual_network.bankpro_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "bankpro_ip" {
  name                = "bankpro-public-ip"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.bankpro_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "bankpro_nic" {
  name                = "bankpro-nic"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.bankpro_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bankpro_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bankpro_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "bankpro_vm" {
  name                  = "bankpro-azure-vm"
  location              = var.azure_region
  resource_group_name   = azurerm_resource_group.bankpro_rg.name
  network_interface_ids = [azurerm_network_interface.bankpro_nic.id]
  size                  = "Standard_B1s"

  admin_username        = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  provision_vm_agent = true

  custom_data = file("${path.module}/cloud-init.txt")
}

output "azure_vm_public_ip" {
  value = azurerm_public_ip.bankpro_ip.ip_address
}
