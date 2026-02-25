variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "project" { type = string }
variable "environment" { type = string }
variable "secrets" { type = map(string) }

resource "azurerm_key_vault" "kv" {
  name                = replace("${var.project}-${var.environment}-kv", "-", "")
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_secret" "secret" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
}

output "vault_uri" { value = azurerm_key_vault.kv.vault_uri }
output "secret_ids" { value = { for k, v in azurerm_key_vault_secret.secret : k => v.id } }
