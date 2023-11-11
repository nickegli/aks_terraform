data "azurerm_resource_group" "existing" {
  name = "${var.customer_name}-${var.environment}-rg"
}

resource "azurerm_resource_group" "new" {
  count    = length(data.azurerm_resource_group.existing.id) > 0 ? 0 : 1
  name     = "${var.customer_name}-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}