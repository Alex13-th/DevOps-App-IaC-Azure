# terraform-azurerm-resource_group_storage

This Terraform module creates an Azure Resource Group and a Storage Account.

## Usage

```hcl
module "rg_storage" {
  source              = "github.com/Alex13-th/terraform-azurerm-resource_group_storage"
  version             = "1.0.0"

  # Required variables
  resource_group_name = "my-rg"
  location            = "West Europe"
  storage_account_name = "mystorageacct"
}

output "resource_group_id" {
  value = module.rg_storage.resource_group_id
}

output "storage_account_primary_web_endpoint" {
  value = module.rg_storage.storage_account_primary_web_endpoint
}
```

## Requirements

    Terraform ≥ 1.0

    AzureRM provider v3.105.0 or later

    An existing Azure Subscription and permissions to create resource groups and storage accounts


## Example
```
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```