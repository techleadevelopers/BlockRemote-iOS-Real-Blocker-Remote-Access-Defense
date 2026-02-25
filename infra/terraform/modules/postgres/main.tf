variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "admin_user" { type = string }
variable "admin_password" { type = string }
variable "sku_name" { type = string }
variable "storage_mb" { type = number }
variable "version" { type = string }
variable "project" { type = string }
variable "environment" { type = string }
variable "allowed_ips" { type = list(string) }

resource "azurerm_postgresql_flexible_server" "pg" {
  name                = "${var.project}-${var.environment}-pg"
  location            = var.location
  resource_group_name = var.resource_group_name
  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password
  version             = var.version
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb
  delegated_subnet_id = var.subnet_id
  zone                = "1"
  backup_retention_days = 7
  public_network_access_enabled = false
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "blockremote"
  server_id = azurerm_postgresql_flexible_server.pg.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow" {
  for_each            = toset(var.allowed_ips)
  name                = "allow-${replace(each.value, "/", "-")}"
  server_id           = azurerm_postgresql_flexible_server.pg.id
  start_ip_address    = each.value
  end_ip_address      = each.value
}

output "fqdn" { value = azurerm_postgresql_flexible_server.pg.fqdn }
output "database_url" {
  value = "postgresql+asyncpg://${var.admin_user}:${var.admin_password}@${azurerm_postgresql_flexible_server.pg.fqdn}:5432/blockremote"
}
