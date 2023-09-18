output "ip_address" {
  value       = azurerm_public_ip.main.ip_address
  description = "value of the public IP address"
}

output "private_ip_address" {
  value       = azurerm_network_interface.main.private_ip_address
  description = "value of the private IP address"
}

output "network_security_group_name" {
  value       = azurerm_network_security_group.main.name
  description = "value of the network security group name"
}

output "tls_private_key" {
  value       = tls_private_key.main.private_key_pem
  description = "value of the tls private key"
}
