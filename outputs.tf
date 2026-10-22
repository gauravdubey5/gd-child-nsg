output "id" {
  description = "The ID of the Network Security Group."
  value       = azurerm_network_security_group.nsg.id
}

output "name" {
  description = "The name of the Network Security Group."
  value       = azurerm_network_security_group.nsg.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the NSG was created."
  value       = azurerm_network_security_group.nsg.resource_group_name
}

output "location" {
  description = "The location of the Network Security Group."
  value       = azurerm_network_security_group.nsg.location
}
