
resource "azurerm_storage_account" "msa-django" {
  name                     = "djangostorageaccalex13"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {

   prevent_destroy = true

 }

}



resource "azurerm_storage_container" "msc-django" {
  name                  = "artifacts"
  storage_account_id    = azurerm_storage_account.msa-django.id
  container_access_type = "blob"

  lifecycle {

   prevent_destroy = true

 }


}

resource "azurerm_storage_blob" "install_script" {
  name                   = "install-app.sh"
  storage_account_name   = azurerm_storage_account.msa-django.name
  storage_container_name = azurerm_storage_container.msc-django.name
  type                   = "Block"
  source                 = var.script_path
}