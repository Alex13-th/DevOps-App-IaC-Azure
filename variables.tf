variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "vnet_address_prefix" {
  type = list(string)
}

variable "subnet_address_prefix" {
  type = list(string)
}

variable "subnet_name" {
  type = string
}

variable "network_security_group_name" {
  type = string
}

variable "public_ip_address_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "ssh_key_public" {
  type = string
}

variable "dns_label" {
  type = string
}

variable "script_path" {
  type = string
}