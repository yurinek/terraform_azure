# terraform_azure

## The goals of this project are to automatically create virtual machines, resource groups, networks, subnets, private and public ips, nics and firewall rules in Azure Cloud.


## Methods in creating the project were based on using existing modules placed under .terraform/modules which are pulled from:

https://github.com/Azure/terraform-azurerm-network
https://github.com/Azure/terraform-azurerm-vm

Some parts of the code of these modules are customized.


## How to install:
```hcl
$ cp terraform.tfvars ..
```
Fill your Azure cloud credentials in the above file.


## How to run:

### For how to run automatically in CD/CI Pipelines alongside with creation of Ansible inventory and passing ip's of created vm's to this inventory see:

run_terraform_wrapper.sh


### For example manual runs see:

manual_run.sh
