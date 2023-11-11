variable "resource_group_location" {
  type        = string
  default     = "switzerlandnorth"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-yanick"
  description = "Name of the resource group."
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "kubernetes-admin"
}

variable "vm_size" {
  type        = string
  description = "The size of the Virtual Machine."
  default     = "Standard_D2_v2"
  
}

variable "vm_name" {
  type        = string
  description = "The name of the Virtual Machine."
  default     = "agentpool"
  
}

variable "vm_node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "cluster_name" {
  type        = string
  description = "The name of the Kubernetes Cluster."
  default     = "yanick-test-cluster"
}

variable "environment" {
  type        = string
  description = "The environment name."
  default     = "int"
}
