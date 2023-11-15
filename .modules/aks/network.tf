resource "azurerm_resource_group" "net_group" {
  name     = "${var.service_short_name}-net-${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}


# resource "azurerm_firewall" "firewall" {
#   name                = "Firewall"
#   location            = var.resource_group_location
#   resource_group_name = "${var.service_short_name}-net-${var.environment}-rg"
#   sku_tier = "Standard"
#   sku_name = "AZFW_VNet"
#   ip_configuration {
#     name = "configuration"
#     subnet_id = azurerm_subnet.fw_subnet.id
#     public_ip_address_id = azurerm_public_ip.external_access.id

#   }
# }

# resource "azurerm_firewall_application_rule_collection" "acr_access" {
#   name                = "acrAccessRules"
#   azure_firewall_name = azurerm_firewall.firewall.name
#   resource_group_name = "${var.service_short_name}-net-${var.environment}-rg"
#   priority            = 100
#   action              = "Allow"

#   rule {
#     name = "ACRAllow"
#     description = "Allow AKS to ACR"
#     source_addresses = ["10.2.0.0/16"]
#     target_fqdns = ["*.azurecr.io"]
#     protocol {
#       type = "Https"
#       port = 443
#     }
#   }
# }

resource "azurerm_public_ip" "external_access" {
  name                = "external_access"
  location            = var.resource_group_location
  resource_group_name = "${var.service_short_name}-net-${var.environment}-rg"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "cluster_vnet" {
  name                = "clusterVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = "${var.service_short_name}-net-${var.environment}-rg"

  tags = {
    environment = var.environment
    customer    = var.customer_name
  }
}

#############################################
#                  SUBNETS                  #
#############################################

# resource "azurerm_subnet" "fw_subnet" {
#   name                 = "AzureFirewallSubnet"
#   resource_group_name  = "${var.service_short_name}-net-${var.environment}-rg"
#   virtual_network_name = azurerm_virtual_network.cluster_vnet.name
#   address_prefixes     = ["10.0.3.0/24"]

# }

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aksSubnet"
  resource_group_name  = "${var.service_short_name}-net-${var.environment}-rg"
  virtual_network_name = azurerm_virtual_network.cluster_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "acr_subnet" {
  name                 = "acrSubnet"
  resource_group_name  = "${var.service_short_name}-net-${var.environment}-rg"
  virtual_network_name = azurerm_virtual_network.cluster_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}