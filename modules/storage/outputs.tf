output "storage_account_name" {
  value = data.azurerm_storage_account.msa_django.name
}

output "storage_account_id" {
  value = data.azurerm_storage_account.msa_django.id
}

output "container_name" {
  value = data.azurerm_storage_container.msc_django.name
}


output "install_script_url"   { value = local.install_script_url }