# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.76.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create Main resourses
# resourse Group
resource "azurerm_resource_group" "halangroup" {
  name     = var.resource_group
  location = var.location
}
# Networking
# Main Virtual Network
resource "azurerm_virtual_network" "halannetwork" {
  name                = var.virtual_network
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name
  address_space       = [var.vn_address_space]
}

# Main Virtual Subnet
resource "azurerm_subnet" "halansubnet" {
  name                 = "${var.virtual_network}-sub1"
  resource_group_name  = azurerm_resource_group.halangroup.name
  virtual_network_name = azurerm_virtual_network.halannetwork.name
  address_prefixes     = [var.vn_sub1_address_prefixes]
}

##########################################################

### VMs Resources ###

## dbm Vm ##

# dbm VM public Ip
resource "azurerm_public_ip" "halandbmvmpubip" {
  name                = "${var.dbm_vm_name}-pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name
  allocation_method   = "Dynamic"
}

# dbm VM Nic
resource "azurerm_network_interface" "halandbmvmnic" {
  name                = "${var.dbm_vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name

  ip_configuration {
    name                          = "${var.dbm_vm_name}-nic-configuration"
    subnet_id                     = azurerm_subnet.halansubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.dbm_vm_private_ip
    public_ip_address_id          = azurerm_public_ip.halandbmvmpubip.id
  }

}

# dbm VM Linux
resource "azurerm_linux_virtual_machine" "halandbmvm" {
  name                            = var.dbm_vm_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.halangroup.name
  network_interface_ids           = [azurerm_network_interface.halandbmvmnic.id]
  size                            = var.vm_size
  admin_username                  = "admin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "admin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.dbm_vm_name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

##########################################################

## dbs1aster Vm ##

# dbs1aster VM public Ip
resource "azurerm_public_ip" "halandbs1vmpubip" {
  name                = "${var.dbs1_vm_name}-pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name
  allocation_method   = "Dynamic"
}

# dbs1 VM Nic
resource "azurerm_network_interface" "halandbs1vmnic" {
  name                = "${var.dbs1_vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name

  ip_configuration {
    name                          = "${var.dbs1_vm_name}-nic-configuration"
    subnet_id                     = azurerm_subnet.halansubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.dbs1_vm_private_ip
    public_ip_address_id          = azurerm_public_ip.halandbs1vmpubip.id
  }

}

# dbs1 VM Linux
resource "azurerm_linux_virtual_machine" "halandbs1vm" {
  name                            = var.dbs1_vm_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.halangroup.name
  network_interface_ids           = [azurerm_network_interface.halandbs1vmnic.id]
  size                            = var.vm_size
  admin_username                  = "admin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "admin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.dbs1_vm_name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


##########################################################

## dbs2 Vm ##

# dbs2 VM public Ip
resource "azurerm_public_ip" "halandbs2vmpubip" {
  name                = "${var.dbs2_vm_name}-pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name
  allocation_method   = "Dynamic"
}

# dbs2 VM Nic
resource "azurerm_network_interface" "halandbs2vmnic" {
  name                = "${var.dbs2_vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.halangroup.name

  ip_configuration {
    name                          = "${var.dbs2_vm_name}-nic-configuration"
    subnet_id                     = azurerm_subnet.halansubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.dbs2_vm_private_ip
    public_ip_address_id          = azurerm_public_ip.halandbs2vmpubip.id
  }

}

# dbs2 VM Linux
resource "azurerm_linux_virtual_machine" "halandbs2vm" {
  name                            = var.dbs2_vm_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.halangroup.name
  network_interface_ids           = [azurerm_network_interface.halandbs2vmnic.id]
  size                            = var.vm_size
  admin_username                  = "admin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "admin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.dbs2_vm_name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

##########################################################

# ### Module outputs ###
# output "DB_NAME" {
#   value = var.DB_NAME
# }
# output "DB_USER_NAME" {
#   value = var.DB_USER_NAME
# }
# output "DB_USER_PASS" {
#   value     = var.DB_USER_PASS
#   sensitive = true
# }
# output "DB_REPLICA_NAME" {
#   value = var.DB_REPLICA_NAME
# }
# output "DB_REPLICA_PASS" {
#   value     = var.DB_REPLICA_PASS
#   sensitive = true
# }
output "MASTERDB_PRIVATE_IP" {
  value = var.dbm_vm_private_ip
}
output "SLAVEDB1_PRIVATE_IP" {
  value = var.dbs1_vm_private_ip
}
output "SLAVEDB2_PRIVATE_IP" {
  value = var.dbs2_vm_private_ip
}


output "MASTERDB_PUBLIC_IP" {
  value = azurerm_linux_virtual_machine.halandbmvm.public_ip_address
}
output "SLAVEDB1_PUBLIC_IP" {
  value = azurerm_linux_virtual_machine.halandbs1vm.public_ip_address
}
output "SLAVEDB2_PUBLIC_IP" {
  value = azurerm_linux_virtual_machine.halandbs2vm.public_ip_address
}
