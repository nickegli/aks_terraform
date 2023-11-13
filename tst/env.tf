module "aks_cluster" {
    source= "../.modules/aks"

    cluster_name = "cluster1"
    environment = var.env
    service_short_name = var.service_short_name
    customer_name = var.customer_name
    monitoring_grafana_password = "admin1234"

}

module "acr" {
    source= "../.modules/acr"

    environment = var.env
    service_short_name = var.service_short_name
    customer_name = var.customer_name
    acr_subnet_id = module.aks_cluster.acr_subnet_id # ignore this it's required for the module to work but doesn't need change

}

variable "env" {
    type        = string
    description = "Environment (tst/int/prd)."
    default     = "tst"
}

variable "customer_name" {
    type        = string
    description = "Customer name."
    default     = "yanick"
  
}

variable "service_short_name" {
    type        = string
    description = "Service short name."
    default     = "y"
  
}