# DevOps-App IaC (Azure): Workload RG + Network/VM, Storage as Data

This stack creates a working Resource Group, network resources, and VMs, but does not create storage (TF backend and artifacts) — it reads data from an existing Storage Account.

Prerequisites

- Terraform ≥ 1.6
- AzureRM provider = 4.37.0
- Azure subscription + az login
- Existing objects for backend/artifacts:
  - RG: django-storage-tf
  - Storage Account: djstoragealex
  - Containers:
    - backend-tfstate — for Terraform state
    - artifacts — for install-app.sh


- Acces:
  - To upload the script: Storage Blob Data Contributor role on the account or use account key (locally).
  - To expand Custom Script:
    - or make artifacts publicly readable (public-access blob)
    - or use SAS-URL in fileUris.


## Usage

### backend.tf

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "django-storage-tf"
    storage_account_name = "djstoragealex"
    container_name       = "backend-tfstate"
    key                  = "fresh/2025-08-17.tfstate"
  }
}
```

### Root main.tf
```hcl
terraform {
  required_version = ">= 1.6.0"
  required_providers { azurerm = { source = "hashicorp/azurerm", version = "4.37.0" } }
}

provider "azurerm" {
  features {
    resource_group { prevent_deletion_if_contains_resources = false }
  }
}

resource "azurerm_resource_group" "workload" {
  name     = var.resource_group_name   # напр. "django-web"
  location = var.location              # напр. "westeurope"
}

module "network" {
  source                      = "./modules/network"
  resource_group_name         = azurerm_resource_group.workload.name   # важливо: посилання на ресурс
  location                    = var.location
  virtual_network_name        = var.virtual_network_name
  vnet_address_prefix         = var.vnet_address_prefix
  subnet_name                 = var.subnet_name
  subnet_address_prefix       = var.subnet_address_prefix
  network_security_group_name = var.network_security_group_name
  public_ip_address_name      = var.public_ip_address_name
  dns_label                   = var.dns_label
  depends_on                  = [azurerm_resource_group.workload]
}

module "storage" {
  source               = "./modules/storage"
  storage_rg_name      = "django-storage-tf"
  storage_account_name = "djstoragealex"
  script_path          = var.script_path   # локальний шлях до install-app.sh
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = azurerm_resource_group.workload.name
  location            = var.location
  subnet_id           = module.network.subnet_id
  public_ip_id        = module.network.public_ip_id
  nsg_id              = module.network.network_security_group_id
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  ssh_public_key_path = var.ssh_key_public

  # URL скрипта з модуля storage (для Custom Script Extension)
  script_blob_url     = module.storage.install_script_url

  depends_on = [module.network]
}
```


### Variables
```hcl
location                  = "westeurope"
resource_group_name       = "django-web"
virtual_network_name      = "vnet"
vnet_address_prefix       = ["10.0.0.0/16"]
subnet_name               = "default"
subnet_address_prefix     = ["10.0.0.0/24"]
network_security_group_name = "defaultnsg"
public_ip_address_name    = "linuxboxpip"
vm_name                   = "django-box"
vm_size                   = "Standard_B1s"
ssh_key_public            = "~/.ssh/id_ed25519.pub"
dns_label                 = "djangoazure"
script_path               = "./install-app.sh"
```

### Outputs

```hcl

output "public_ip_address"            { value = module.network.public_ip_address }
output "fqdn"                         { value = module.network.fqdn }
output "virtual_network_id"           { value = module.network.virtual_network_id }
output "subnet_id"                    { value = module.network.subnet_id }
output "network_security_group_id"    { value = module.network.network_security_group_id }
output "install_script_url"           { value = module.storage.install_script_url } # sensitive=true, якщо SAS
output "network_interface_id"         { value = module.compute.network_interface_id }
output "vm_id"                        { value = module.compute.vm_id }
```


## Quick Start

```bash

# 1) Login
az login
az account set --subscription e03fc955-5f65-40e1-ae07-a2032a398b92
export ARM_SUBSCRIPTION_ID="e03fc955-5f65-40e1-ae07-a2032a398b92"

# 2) script loading artifacts
az storage blob upload \
  --account-name djstoragealex \
  --container-name artifacts \
  --name install-app.sh \
  --file ./install-app.sh \
  --auth-mode login --overwrite

# 3) (Optional) public blob for Custom Script
az storage account update -g django-storage-tf -n djstoragealex --allow-blob-public-access true
az storage container set-permission --name artifacts --account-name djstoragealex --public-access blob --auth-mode login
curl -I https://djstoragealex.blob.core.windows.net/artifacts/install-app.sh  # маємо бачити 200 OK

# 4) Terraform
terraform init -reconfigure
terraform validate
terraform apply -auto-approve
```

## Destroy / Re-Apply
```bash
terraform destroy -auto-approve
# The script in Blob is NOT controlled by TF, so it does not disappear (separate life cycle)
terraform apply -auto-approve
```
