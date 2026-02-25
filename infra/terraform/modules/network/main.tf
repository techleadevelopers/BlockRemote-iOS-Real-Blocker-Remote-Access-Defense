variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_cidr" { type = string }
variable "subnet_app_cidr" { type = string }
variable "subnet_data_cidr" { type = string }
variable "project" { type = string }
variable "environment" { type = string }

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-${var.environment}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "app" {
  name                 = "app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_app_cidr]
  delegations {
    name = "delegation"
    service_delegation {
      name = "Microsoft.App/environments"
    }
  }
}

resource "azurerm_subnet" "data" {
  name                 = "data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_data_cidr]
}

output "vnet_id" { value = azurerm_virtual_network.vnet.id }
output "subnet_app_id" { value = azurerm_subnet.app.id }
output "subnet_data_id" { value = azurerm_subnet.data.id }
