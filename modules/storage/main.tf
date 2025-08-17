data "azurerm_storage_account" "msa_django" {
  name                = "djstoragealex"
  resource_group_name = "django-storage-tf"
}

data "azurerm_storage_container" "msc_django" {
  name                 = "artifacts"
  storage_account_name = data.azurerm_storage_account.msa_django.name
}


locals {
  install_script_name = "install-app.sh"
  install_script_url  = "${data.azurerm_storage_account.msa_django.primary_blob_endpoint}${data.azurerm_storage_container.msc_django.name}/${local.install_script_name}"
}