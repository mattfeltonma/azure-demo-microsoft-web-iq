output "resource_group_name" {
  description = "Name of the resource group, consumed by the notebook."
  value       = azurerm_resource_group.rg_webiq.name
}
