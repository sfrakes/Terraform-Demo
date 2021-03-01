# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG-Terraform" {
  name     = "simple-resource-group"
  location = "uksouth"
}