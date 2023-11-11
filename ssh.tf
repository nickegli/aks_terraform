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
  location  = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.new[0].location
  parent_id = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.id : azurerm_resource_group.new[0].id
}

output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}
