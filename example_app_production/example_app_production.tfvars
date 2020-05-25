# vars in this file should be static per environment, if dynamic then use them as command line variables

env_vm_suffix   = "p"

env_data_disk_size_gb   = "64"

env_data_sa_type        = "Premium_LRS"

# Standard_D2s_v3 is also default defined in .terraform/modules/linuxservers/Azure-terraform-azurerm-compute-80cab6f/variables.tf
env_vm_size             = "Standard_D2s_v3"

env_location            = "westeurope"

env_rg_network          = "myapp_prod_network"

env_rg_vm               = "myapp_prod_vm"

env_vm_instances        = "1"

# deployed: ram: 8gb, cpu: 2, 2nd disk 16gb