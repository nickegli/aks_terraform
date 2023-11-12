resource "azurerm_resource_group" "aks_group" {
  name     = "${var.service_short_name}-aks-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.customer_name}-${var.environment}-${var.cluster_name}"
  location            = azurerm_resource_group.aks_group.location
  resource_group_name = "${var.service_short_name}-aks-${var.environment}-rg"
  dns_prefix          = "tsk8s"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }

  default_node_pool {
    name            = var.vm_name
    vm_size         = var.vm_size
    node_count      = var.vm_node_count
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id

  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }

  network_profile {
    network_plugin    = "azure"
    service_cidr      = "10.2.0.0/16"
    dns_service_ip    = "10.2.0.10"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  # depends_on = [
  #   azurerm_container_registry.acr,
  # ]

}