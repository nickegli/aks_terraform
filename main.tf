resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.aks_group.location
  name                = "${var.customer_name}-${var.environment}-${var.cluster_name}"
  resource_group_name = "${var.service_short_name}-${var.environment}-rg"
  dns_prefix          = "tsk8s"
  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }

  default_node_pool {
    name       = var.vm_name
    vm_size    = var.vm_size
    node_count = var.vm_node_count
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

    depends_on = [
    azurerm_container_registry.acr
  ]

}


resource "azurerm_container_registry" "acr" {
  name                = "${var.customer_name}${var.environment}acr"
  resource_group_name = "${var.service_short_name}-acr-${var.environment}-rg"
  location            = "${var.resource_group_location}"
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

#missing permission for user to crete role assignment
# resource "azurerm_role_assignment" "AcrPull" {
#  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
#  role_definition_name             = "AcrPull"
#  scope                            = azurerm_container_registry.acr.id
#  skip_service_principal_aad_check = true
#}