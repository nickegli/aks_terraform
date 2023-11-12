resource "azurerm_resource_group" "ssh_group" {
  name     = "${var.service_short_name}-ssh-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = "ssh-${var.customer_name}-${var.environment}-${var.cluster_name}"
  location  = azurerm_resource_group.ssh_group.location
  parent_id = azurerm_resource_group.ssh_group.id

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}
