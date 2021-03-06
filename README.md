# terraform_azure

## Goals of the project 

Create virtual machines, resource groups, networks, subnets, private and public ips, nics and firewall rules in Azure Cloud using Terraform.


Methods in creating the project were based on using existing modules placed under .terraform/modules which are pulled from:

https://github.com/Azure/terraform-azurerm-network
https://github.com/Azure/terraform-azurerm-vm

Some parts of the code of these modules are customized.


## How to install
```hcl
# scripts expect this file to be 1 level above this repo, because it should contain some sensible data 
$ cp terraform.tfvars ..
```
Fill your Azure cloud credentials in the above file.


## How to run

To run automatically in CD/CI Pipelines alongside with creation of Ansible inventory and passing ip's of created vm's to this inventory:
```hcl
# for description of parameters run 
$ bash run_terraform_wrapper.sh -h
# preview
$ bash run_terraform_wrapper.sh -a demoapp2 -e staging -i 2 -r plan
# create infrastructure
$ bash run_terraform_wrapper.sh -a demoapp1 -e staging -i 2 -r apply
# remove infrastructure
$ bash run_terraform_wrapper.sh -a demoapp1 -e staging -i 2 -r destroy
```

For manual example runs see:
```hcl
$ cat manual_run.sh
```
