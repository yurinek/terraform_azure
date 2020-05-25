# vars in this file should be static per environment, if dynamic then use them as command line variables

#environment_tag        = "stg"

env_vm_suffix   = "s"

env_data_disk_size_gb   = "32"

# free LRS
env_data_sa_type        = "Standard_LRS"

# free size
env_vm_size             = "Standard_B1s"

env_location            = "westeurope"

env_rg_network          = "APPNAMEPLACEHOLDER_stg_network"

env_rg_vm               = "APPNAMEPLACEHOLDER_stg_vm"



# deployed: ram: 1gb, cpu: 1, 2nd disk 4gb