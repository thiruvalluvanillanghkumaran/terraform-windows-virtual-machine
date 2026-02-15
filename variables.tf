#add your client id
variable "azure_client_id" {
  default     = "0000000-000000-000000-000000"
  description = "The Client ID of the Azure Service Principal"
  type        = string
}

#add your tenant id
variable "azure_tenant_id" {
  default     = "0000000-000000-000000-000000"
  description = "The Tenant ID of the Azure Service Principal"
  type        = string
}

#add your subscription id
variable "azure_subscription_id" {
  default     = "0000000-000000-000000-000000"
  description = "The Subscription ID of the Azure Service Principal"
  type        = string
}

variable "resource_group_name" {
  default     = "rg-windows"
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  default     = "East US"
  description = "The Azure region to deploy resources"
  type        = string
}

variable "admin_username" {
  default     = "azureuser"
  description = "The admin username for the VM"
  type        = string
}

variable "admin_password" {
  default     = "Admin@12345"
  description = "The admin password for the VM"
  type        = string
}

variable "size" {
  default     = "Standard_B1s"
  description = "The size of the VM"
  type        = string
}

  