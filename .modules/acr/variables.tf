variable "resource_group_location" {
  type        = string
  default     = "switzerlandnorth"
  description = "Location of the resource group."
}

variable "environment" {
  type        = string
  description = "The environment (tst/int/prd)."
}

variable "service_short_name" {
  type        = string
  description = "The short name of the service."
}

variable "customer_name" {
  type        = string
  description = "Name of the customer."
}

variable "acr_subnet_id" {
  description = "The ID of the ACR subnet"
  type        = string
}
