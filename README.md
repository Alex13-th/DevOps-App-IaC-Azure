# DevOps-App-IaC-Azure


# 1) Група ресурсів
az group create -n django-backend-storage -l westeurope

# 2) Storage Account (назва лише нижній регістр, 3–24 символи, унікальна глобально)
az storage account create \
  -n djstoragealex \
  -g django-backend-storage \
  -l westeurope \
  --sku Standard_LRS

# 3) Контейнер під state (назва — нижній регістр; використовуй AAD-автентифікацію)
az storage container create \
  --account-name djstoragealex \
  -n backend-tfstate \
  --auth-mode login




# перезалити блоб зі скриптом
terraform apply -target=module.storage.azurerm_storage_blob.install_script

# перевстановити лише VM extension (щоб виконав новий скрипт)
terraform apply -replace=module.compute.azurerm_virtual_machine_extension.custom_script


# видалити лише цей блоб
terraform destroy -target='module.storage.azurerm_storage_blob.install_script'




ARM_SUBSCRIPTION_ID="e03fc955-5f65-40e1-ae07-a2032a398b92"