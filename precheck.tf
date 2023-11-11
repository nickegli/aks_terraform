data "azurerm_resource_group" "existing" {
  name = "rg-${var.customer_name}"
}

resource "azurerm_resource_group" "new" {
  count    = length(data.azurerm_resource_group.existing.id) > 0 ? 0 : 1
  name     = "rg-${var.customer_name}"
  location = var.resource_group_location
}