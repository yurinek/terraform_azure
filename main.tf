# readme https://github.com/Azure/terraform-azurerm-vm
# readme https://github.com/Azure/terraform-azurerm-network


# resource group is a logical place where all infrastructure objects for an applications are placed together
resource "azurerm_resource_group" "vm" {
        name     = var.env_rg_vm
        location = var.env_location
}


module "network" {
  source              = "Azure/network/azurerm"
  location             = var.env_location
  #version             = "3.0.0"
  #resource_group_name = azurerm_resource_group.vm.name
  resource_group_name = var.env_rg_network
  #allow_ssh_traffic   = "true"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "linuxservers" {
  # following parameters are nothing else than variables from .terraform/modules/linuxservers/Azure-terraform-azurerm-compute-80cab6f/variables.tf
  # number of vms to be created
  nb_instances        = var.vm_instances
  # vm should have public ip enabled: set 0 to disable, e.g. if 2 vms are deployed and both need public ip: set to 2, if only one needs pub ip: set to 1
  # following var ensures that as many public ips are created as many vms are created
  nb_public_ip        = var.vm_instances                    # "2"
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.vm.name
  delete_os_disk_on_termination = "true"
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_hostname         = var.app_name
  data_disk_size_gb   = var.env_data_disk_size_gb
  data_sa_type        = var.env_data_sa_type
  admin_username      = "ansible"
  vm_size             = var.env_vm_size
  # too find out values for next 4 vars go to https://azuremarketplace.microsoft.com/en-us/marketplace/apps/debian.debian-10 and click "get it now", fill all the sections to create the VM,
  # instead of create click "Download Template and parameters" and search for imageReference
  # or see in existing deployments https://vincentlauzon.com/2018/01/10/finding-a-vm-image-reference-publisher-sku/ 
  # These 4 vars are ignored when vm_os_id or vm_os_simple are provided
  vm_os_publisher     = "debian"
  vm_os_offer         = "debian-10"
  vm_os_sku           = "10"    
  vm_os_version       = "latest"
  env_suffix          = var.env_vm_suffix    
}

