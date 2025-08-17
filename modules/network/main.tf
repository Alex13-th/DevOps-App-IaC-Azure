resource "azurerm_virtual_network" "vn" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_prefix
}

resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}



resource "azurerm_network_security_group" "example" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "example" {
  name                = var.public_ip_address_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = "${var.dns_label}${random_integer.dns_suffix.result}"

}

resource "random_integer" "dns_suffix" {
  min = 1
  max = 100
}