# Configure the Microsoft Azure Provider
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "RG-Terraform" {
  name     = "MPN-resource-group"
  location = "uksouth"
}