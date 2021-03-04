## <https://www.terraform.io/docs/providers/azurerm/index.html>
provider "azurerm" {
  version = "=2.5.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example_rg" {
name = "${var.resource_prefix}-rg"
location = var.node_location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example_vnet" {
name = "${var.resource_prefix}-vnet"
resource_group_name = azurerm_resource_group.example_rg.name
location = var.node_location
address_space = var.node_address_space
}

# Create a subnets within the virtual network
resource "azurerm_subnet" "example_subnet" {
name = "${var.resource_prefix}-subnet"
resource_group_name = azurerm_resource_group.example_rg.name
virtual_network_name = azurerm_virtual_network.example_vnet.name
address_prefix = var.node_address_prefix
}

# Create Network Interface
resource "azurerm_network_interface" "example_nic" {
count = var.node_count
name = "${var.resource_prefix}${format("%02d", count.index + 1)}-nic"
location = azurerm_resource_group.example_rg.location
resource_group_name = azurerm_resource_group.example_rg.name
#
ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.example_subnet.id
private_ip_address_allocation = "Dynamic"
}
}

# Creating resource NSG
resource "azurerm_network_security_group" "example_nsg" {
name = "${var.resource_prefix}-nsg"
location = azurerm_resource_group.example_rg.location
resource_group_name = azurerm_resource_group.example_rg.name
# Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.
security_rule {
name = "Inbound"
priority = 100
direction = "Inbound"
access = "Allow"
protocol = "Tcp"
source_port_range = "*"
destination_port_range = "*"
source_address_prefix = "*"
destination_address_prefix = "*"
}
tags = {
environment = "Test"
}
}
# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "example_subnet_nsg_association" {
subnet_id = azurerm_subnet.example_subnet.id
network_security_group_id = azurerm_network_security_group.example_nsg.id
}
# Virtual Machine Creation — Windows

resource "azurerm_windows_virtual_machine" "example_vm" {
count = var.node_count
name = "${var.resource_prefix}${format("%02d", count.index + 1)}"
location = azurerm_resource_group.example_rg.location
resource_group_name = azurerm_resource_group.example_rg.name
network_interface_ids = [element(azurerm_network_interface.example_nic.*.id, count.index + 1)]
size = "Standard_D1_v2"
admin_username = "rsadmin"
admin_password = "C0lumbiana12"

source_image_reference {
publisher = "MicrosoftWindowsServer"
offer = "WindowsServer"
sku = "2016-Datacenter"
version = "latest"
}

os_disk {
#name = "${var.resource_prefix}_osdisk${format("%02d", count.index + 1)}"
name = "${var.resource_prefix}${format("%02d", count.index + 1)}"
caching = "ReadWrite"
storage_account_type = "Standard_LRS"
}

}









