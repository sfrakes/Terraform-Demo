provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "resource-group-name" {
  default     = "terraform-resource-group"
  description = "The prefix used for all resources in this example"
}

variable "app-service-name" {
  default     = "sfrakes-terraform-app-service"
  description = "The name of the Web App"
}

variable "location" {
  default     = "West Europe"
  description = "The Azure location where all resources in this example should be created"
}