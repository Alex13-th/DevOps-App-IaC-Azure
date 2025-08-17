terraform {
  backend "azurerm" {
    resource_group_name   = "django-storage-tf"
    storage_account_name  = "djstoragealex"
    container_name        = "backend-tfstate"
    key                   = "fresh/2025-08-17.tfstate"

  }
}
