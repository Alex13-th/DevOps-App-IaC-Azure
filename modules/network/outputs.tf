output "virtual_network_id" {
  description = "ID створеного Virtual Network"
  value       = azurerm_virtual_network.vn.id
}

output "subnet_id" {
  description = "ID створеного Subnet ‘default’"
  value       = azurerm_subnet.example.id
}

output "network_security_group_id" {
  description = "ID створеного Network Security Group"
  value       = azurerm_network_security_group.example.id
}

output "public_ip_id" {
  description = "ID створеного Public IP"
  value       = azurerm_public_ip.example.id
}

output "public_ip_address" {
  description = "Публічна IP-адреса (якщо динамічна — відобразиться після створення)"
  value       = azurerm_public_ip.example.ip_address
}

output "fqdn" {
  description = "Повне ім’я (FQDN) згенерованого DNS"
  value       = azurerm_public_ip.example.fqdn
}
