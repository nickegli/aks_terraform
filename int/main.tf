module "aks_cluster" {
    source= "../modules/aks"

    cluster_name = "cluster1"
    environment = var.env
    service_short_name = "y"
    customer_name = "yanick"

}

module "acr" {
    source= "../modules/acr"

    environment = var.env
    service_short_name = "y"
    customer_name = "yanick"
    acr_subnet_id = module.aks_cluster.acr_subnet_id

}

variable "env" {
    type        = string
    description = "Environment (tst/int/prd)."
    default     = "int"
}