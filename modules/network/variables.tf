variable "resource_group_name" {
    type = string
}

variable "location" {
  type = string
}

variable "dns_label" {
  type = string
}

variable "subnet_address_prefix" {
  type = list(string)
}

variable "vnet_address_prefix" {
  type = list(string)
}

variable "subnet_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "network_security_group_name" {
  type = string
}

variable "public_ip_address_name" {
  type = string
}