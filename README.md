# terraform_azure

The goals of this project are to automatically create virtual machines, resource groups, networks, subnets, private and public ips, nics and firewall rules in Azure Cloud using Terraform.


Methods in creating the project were based on using existing modules placed under .terraform/modules which are pulled from:

https://github.com/Azure/terraform-azurerm-network
https://github.com/Azure/terraform-azurerm-vm

Some parts of the code of these modules are customized.


## How to install:
```hcl
$ cp terraform.tfvars ..
```
Fill your Azure cloud credentials in the above file.


## How to run:

To run automatically in CD/CI Pipelines alongside with creation of Ansible inventory and passing ip's of created vm's to this inventory:
```hcl
$ run_terraform_wrapper.sh
```

For manual example runs see:
```hcl
$ cat manual_run.sh
```
