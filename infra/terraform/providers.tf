terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.88"
    }
  }
  # Configure remote state separately (e.g., azurerm backend) before apply.
}

provider "azurerm" {
  features {}
}
