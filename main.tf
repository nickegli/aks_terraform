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

  depends_on = [
    azurerm_container_registry.acr
  ]

}

resource "azurerm_resource_group" "acr_group" {
  name     = "${var.service_short_name}-acr-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.customer_name}${var.environment}acr"
  resource_group_name = "${var.service_short_name}-acr-${var.environment}-rg"
  location            = "${var.resource_group_location}"
  sku                 = "Premium" #required for geo-replication / private link
  #public_network_access_enabled = false # needs to be activated later so only accessible through bastion or vpn
  admin_enabled       = false # need to find a way to permanently prevent activation of admin user

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }

  depends_on = [
    azurerm_resource_group.acr_group
  ]
}

resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "AcrPrivateEndpoint"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.service_short_name}-acr-${var.environment}-rg"
  subnet_id           = azurerm_subnet.acr_subnet.id

  private_service_connection {
    name                           = "AcrPrivateConnection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

# resource "azurerm_network_interface" "aks_nic" {
#   name                = "aksNic"
#   location            = var.resource_group_location
#   resource_group_name = "${var.service_short_name}-aks-${var.environment}-rg"

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.aks_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }

#   tags = {
#     environment = var.environment
#     customer    = var.customer_name
#   }
# }

# resource "azurerm_private_dns_zone" "acr" {
#   name                = "privatelink.azurecr.io"
#   resource_group_name = "${var.service_short_name}-acr-${var.environment}-rg"
# }

# resource "azurerm_role_assignment" "developer_acr_access" {
#   principal_id         = "<developer_principal_id>"
#   role_definition_name = "AcrImageReader"
#   scope                = azurerm_container_registry.acr.id
# }

# #resource lock to be used to prevent deletion of registry
# resource "azurerm_management_lock" "acr_lock" {
#   name       = "acr-lock"
#   scope      = azurerm_container_registry.acr.id
#   lock_level = "CanNotDelete"
#   notes      = "Prevent deletion of the ACR"
# }

# #missing permission for user to create role assignment
# resource "azurerm_role_assignment" "AcrPull" {
#   principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
# }