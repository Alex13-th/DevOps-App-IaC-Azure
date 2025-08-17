terraform {
  backend "azurerm" {
    resource_group_name   = "django-backend-storage"
    storage_account_name  = "djstoragealex"
    container_name        = "backend-tfstate"
    key                   = "terraform.tfstate"

  }
}
