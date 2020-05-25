# variable declaration blocks (which can actually appear in any .tf file, but are in variables.tf by convention) declare that a variable exists


################################# variables to be passed as command line vars (should be values which differ for unique app+environment)

variable "app_name" {
  description = "Create vms with these names e.g. appname-db-p01"
}

# how many vms with this app_name and this environment should be created
variable "vm_instances" {}

# which environment e.g. p for appname-db-p01 or s for appname-db-s01
variable "env_vm_suffix" {}

#############################################################################



variable "arm_subscription_id" {}
variable "arm_principal" {}
variable "arm_password" {}
variable "tenant_id" {}

provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider   being used
  version = "=2.2.0"
  features {}
}

# resource group for network
variable "env_rg_network" {}

# resource group for vms
variable "env_rg_vm" {}

variable "env_location" {}
variable "env_data_disk_size_gb" {}
variable "env_data_sa_type" {}
variable "env_vm_size" {}




