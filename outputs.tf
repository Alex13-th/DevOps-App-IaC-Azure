output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.network.public_ip_address
}

output "fqdn" {
  description = "Public FQDN of the VM"
  value       = module.network.fqdn
}

output "virtual_network_id" {
  description = "ID of the created virtual network"
  value       = module.network.virtual_network_id
}

output "subnet_id" {
  description = "ID of the default subnet"
  value       = module.network.subnet_id
}

output "network_security_group_id" {
  description = "ID of the NSG"
  value       = module.network.network_security_group_id
}

output "install_script_url" {
  description = "HTTP URL to install-app.sh in Blob Storage"
  value       = module.storage.install_script_url
}

output "network_interface_id" {
  description = "ID of the VM network interface"
  value       = module.compute.network_interface_id
}

output "vm_id" {
  description = "ID of the VM"
  value       = module.compute.vm_id
}
