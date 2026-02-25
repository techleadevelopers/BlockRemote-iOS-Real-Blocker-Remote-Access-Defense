output "vnet_id" { value = module.network.vnet_id }
output "subnet_app_id" { value = module.network.subnet_app_id }
output "subnet_data_id" { value = module.network.subnet_data_id }
output "postgres_fqdn" { value = module.postgres.fqdn }
output "redis_hostname" { value = module.redis.hostname }
output "container_app_api_url" { value = module.container_apps.api_url }
