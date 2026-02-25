variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "project" { type = string }
variable "environment" { type = string }

variable "vnet_cidr" { type = string default = "10.20.0.0/16" }
variable "subnet_app_cidr" { type = string default = "10.20.1.0/24" }
variable "subnet_data_cidr" { type = string default = "10.20.2.0/24" }

variable "postgres_sku" { type = string default = "B_Standard_B1ms" }
variable "postgres_storage_mb" { type = number default = 32768 }
variable "postgres_version" { type = string default = "14" }

variable "redis_sku" { type = string default = "Premium" }
variable "redis_family" { type = string default = "P" }
variable "redis_capacity" { type = number default = 1 }

variable "container_apps_env_name" { type = string default = "blockremote-ca-env" }
variable "api_image" { type = string }
variable "worker_image" { type = string }
variable "jwt_secret" { type = string }
variable "billing_webhook_secret" { type = string }

variable "postgres_admin_user" { type = string default = "appadmin" }
variable "postgres_admin_password" { type = string }
variable "allowed_ips" { type = list(string) default = [] }

variable "log_analytics_workspace_id" { type = string default = null }
variable "log_analytics_key" { type = string default = null }
