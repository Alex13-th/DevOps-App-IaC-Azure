location                    = "westeurope"
resource_group_name         = "django-web"
virtual_network_name        = "vnet"
vnet_address_prefix         = ["10.0.0.0/16"]
subnet_name                 = "default"
subnet_address_prefix       = ["10.0.0.0/24"]
network_security_group_name = "defaultnsg"
public_ip_address_name      = "linuxboxpip"
vm_name                     = "django-box"
vm_size                     = "Standard_B1s"
ssh_key_public              = "~/.ssh/id_ed25519.pub"
dns_label                   = "djangoazure"
script_path                 = "./install-app.sh"

