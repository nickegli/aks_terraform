data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

resource "azurerm_resource_group" "new" {
  count    = length(data.azurerm_resource_group.existing.id) > 0 ? 0 : 1
  name     = var.resource_group_name
  location = var.resource_group_location
}