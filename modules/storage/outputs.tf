output "storage_account_name" {
  description = "Ім’я створеного Storage Account"
  value       = azurerm_storage_account.msa-django.name
}

output "storage_account_id" {
  description = "ID створеного Storage Account"
  value       = azurerm_storage_account.msa-django.id
}

output "container_name" {
  description = "Ім’я створеного Storage Container"
  value       = azurerm_storage_container.msc-django.name
}

output "install_script_url" {
  description = "HTTPS-URL до скрипта install-app.sh Blob Storage"
  value       = azurerm_storage_blob.install_script.url
}

