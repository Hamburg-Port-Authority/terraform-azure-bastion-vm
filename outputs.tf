output "ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  value = azurerm_network_interface.main.private_ip_address
}

output "network_security_group_name" {
  value = azurerm_network_security_group.main.name
}
