module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  subnet_app_cidr     = var.subnet_app_cidr
  subnet_data_cidr    = var.subnet_data_cidr
  project             = var.project
  environment         = var.environment
}

module "postgres" {
  source              = "./modules/postgres"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_data_id
  admin_user          = var.postgres_admin_user
  admin_password      = var.postgres_admin_password
  sku_name            = var.postgres_sku
  storage_mb          = var.postgres_storage_mb
  version             = var.postgres_version
  project             = var.project
  environment         = var.environment
  allowed_ips         = var.allowed_ips
}

module "redis" {
  source              = "./modules/redis"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_data_id
  sku                 = var.redis_sku
  family              = var.redis_family
  capacity            = var.redis_capacity
  project             = var.project
  environment         = var.environment
}

module "keyvault" {
  source              = "./modules/keyvault"
  resource_group_name = var.resource_group_name
  location            = var.location
  project             = var.project
  environment         = var.environment
  secrets = {
    jwt_secret             = var.jwt_secret
    billing_webhook_secret = var.billing_webhook_secret
    postgres_admin_user    = var.postgres_admin_user
    postgres_admin_password= var.postgres_admin_password
    database_url           = module.postgres.database_url
    redis_url              = module.redis.redis_url_with_auth
  }
}

module "container_apps" {
  source                   = "./modules/container_apps"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  environment_name         = var.container_apps_env_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log_analytics_key        = var.log_analytics_key
  project                  = var.project
  environment              = var.environment
  subnet_id                = module.network.subnet_app_id
  api_image                = var.api_image
  worker_image             = var.worker_image
  env_secrets = {
    JWT_SECRET_KEY         = var.jwt_secret
    BILLING_WEBHOOK_SECRET = var.billing_webhook_secret
    DATABASE_URL           = module.postgres.database_url
    REDIS_URL              = module.redis.redis_url_with_auth
  }
}
