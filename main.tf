terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_storage_account" "back" {
  name                     = "djstoragealex"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



resource "azurerm_storage_container" "back_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.back.id
  container_access_type = "private"
}

module "network" {
  source                    = "./modules/network"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  virtual_network_name      = var.virtual_network_name
  vnet_address_prefix       = var.vnet_address_prefix
  subnet_name               = var.subnet_name
  subnet_address_prefix     = var.subnet_address_prefix
  network_security_group_name = var.network_security_group_name
  public_ip_address_name    = var.public_ip_address_name
  dns_label                 = var.dns_label
}


 module "compute" {
   source              = "./modules/compute"
   resource_group_name = var.resource_group_name
   location            = var.location
   subnet_id           = module.network.subnet_id
   public_ip_id = module.network.public_ip_id
   nsg_id       = module.network.network_security_group_id
   vm_name             = var.vm_name
   vm_size             = var.vm_size

  ssh_public_key_path = var.ssh_key_public
  script_blob_url     = module.storage.install_script_url
 }

module "storage" {
  source              = "./modules/storage"
  resource_group_name = var.resource_group_name
  location            = var.location
  script_path = var.script_path

}


output "public_ip_address" { value = module.network.public_ip_address }
output "fqdn"              { value = module.network.fqdn }
output "virtual_network_id"{ value = module.network.virtual_network_id }
output "subnet_id"         { value = module.network.subnet_id }
output "network_security_group_id" { value = module.network.network_security_group_id }

# з compute-модуля
output "network_interface_id" { value = module.compute.network_interface_id }
output "vm_id"                { value = module.compute.vm_id }