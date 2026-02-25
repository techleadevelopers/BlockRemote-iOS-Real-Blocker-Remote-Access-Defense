variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "sku" { type = string }
variable "family" { type = string }
variable "capacity" { type = number }
variable "project" { type = string }
variable "environment" { type = string }

resource "azurerm_redis_cache" "redis" {
  name                = "${var.project}-${var.environment}-redis"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  subnet_id           = var.subnet_id
}

output "hostname" { value = azurerm_redis_cache.redis.hostname }
output "ssl_port" { value = azurerm_redis_cache.redis.ssl_port }
output "primary_key" { value = azurerm_redis_cache.redis.primary_access_key }
output "redis_url" {
  value = "rediss://${azurerm_redis_cache.redis.hostname}:${azurerm_redis_cache.redis.ssl_port}"
}
output "redis_url_with_auth" {
  value = "rediss://:${azurerm_redis_cache.redis.primary_access_key}@${azurerm_redis_cache.redis.hostname}:${azurerm_redis_cache.redis.ssl_port}/0"
}
