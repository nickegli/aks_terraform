resource "azurerm_resource_group" "aks_group" {
  name     = "${var.service_short_name}-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

resource "azurerm_resource_group" "acr_group" {
  name     = "${var.service_short_name}-acr-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

resource "azurerm_resource_group" "ssh_group" {
  name     = "${var.service_short_name}-ssh-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}