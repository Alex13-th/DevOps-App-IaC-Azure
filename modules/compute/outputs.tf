output "network_interface_id" {
  description = "ID створеного мережевого інтерфейсу"
  value       = azurerm_network_interface.vm_nic.id
}

output "vm_id" {
  description = "ID створеної віртуальної машини"
  value       = azurerm_virtual_machine.main.id
}

