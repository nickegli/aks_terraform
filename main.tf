resource "azurerm_kubernetes_cluster" "k8s" {
  location            = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.new[0].location
  name                = "${var.customer_name}-${var.environment}-${var.cluster_name}"
  resource_group_name = "${length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.new[0].name}"
  dns_prefix          = "tsk8s"
  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
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
}
