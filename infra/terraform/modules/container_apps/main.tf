variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment_name" { type = string }
variable "log_analytics_workspace_id" { type = string }
variable "log_analytics_key" { type = string }
variable "project" { type = string }
variable "environment" { type = string }
variable "subnet_id" { type = string }
variable "api_image" { type = string }
variable "worker_image" { type = string }
variable "env_secrets" { type = map(string) }

resource "azurerm_log_analytics_workspace" "law" {
  count               = var.log_analytics_workspace_id == null ? 1 : 0
  name                = "${var.project}-${var.environment}-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

locals {
  law_id  = var.log_analytics_workspace_id != null ? var.log_analytics_workspace_id : azurerm_log_analytics_workspace.law[0].id
  law_key = var.log_analytics_key != null ? var.log_analytics_key : azurerm_log_analytics_workspace.law[0].primary_shared_key
}

resource "azurerm_container_app_environment" "env" {
  name                       = var.environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = local.law_id
  infrastructure_subnet_id   = var.subnet_id
}

resource "azurerm_container_app" "api" {
  name                         = "${var.project}-${var.environment}-api"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  ingress {
    external_enabled = true
    target_port      = 8000
  }
  template {
    container {
      name   = "api"
      image  = var.api_image
      cpu    = 0.5
      memory = "1Gi"
      env { name = "ENVIRONMENT" value = "production" }
      env { name = "DEBUG" value = "false" }
      env {
        name  = "DATABASE_URL"
        secret_ref = "DATABASE_URL"
      }
      env { name = "REDIS_URL" secret_ref = "REDIS_URL" }
      env { name = "JWT_SECRET_KEY" secret_ref = "JWT_SECRET_KEY" }
      env { name = "BILLING_WEBHOOK_SECRET" secret_ref = "BILLING_WEBHOOK_SECRET" }
    }
  }
  secret {
    for_each = var.env_secrets
    name  = each.key
    value = each.value
  }
}

resource "azurerm_container_app" "worker" {
  name                         = "${var.project}-${var.environment}-worker"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  ingress { external_enabled = false }
  template {
    container {
      name   = "worker"
      image  = var.worker_image
      cpu    = 0.5
      memory = "1Gi"
      args   = ["celery", "-A", "app.workers.celery_app.celery", "worker", "--loglevel=info"]
      env { name = "ENVIRONMENT" value = "production" }
      env { name = "DEBUG" value = "false" }
      env { name = "DATABASE_URL" secret_ref = "DATABASE_URL" }
      env { name = "REDIS_URL" secret_ref = "REDIS_URL" }
      env { name = "JWT_SECRET_KEY" secret_ref = "JWT_SECRET_KEY" }
      env { name = "BILLING_WEBHOOK_SECRET" secret_ref = "BILLING_WEBHOOK_SECRET" }
    }
  }
  secret {
    for_each = var.env_secrets
    name  = each.key
    value = each.value
  }
}

output "api_url" { value = azurerm_container_app.api.latest_revision_fqdn }
