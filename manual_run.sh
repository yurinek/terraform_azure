# download modules from registry
$ terraform get
# or
$ terraform init 

# plan creation of vm's
# see .templates for howto construct variables file

$ terraform plan -var-file="../terraform.tfvars" -var-file="example_app_production/production.tfvars" -state="example_app_production/production.state"
$ terraform plan -var-file="../terraform.tfvars" -var-file="example_app_staging/staging.tfvars" -state="example_app_staging/staging.state"


# apply creation of vm's
# firts vm's are created, after this ip's are allocated to these vm's
# in order for dynamically allocated ips to be displayed from output vars, run apply twice

$ terraform apply -var-file="../terraform.tfvars" -var-file="example_app_production/production.tfvars" -state="example_app_production/production.state"
$ terraform apply -var-file="../terraform.tfvars" -var-file="example_app_staging/staging.tfvars" -state="example_app_staging/staging.state"



# remove a certain vm from state file
$ terraform destroy -target module.linuxservers.azurerm_virtual_machine.vm-linux[0] -var-file="../terraform.tfvars" -var-file="example_app_staging/staging.tfvars" -state="example_app_staging/staging.state"
# for rm to take effect:
$ terraform apply -var-file="../terraform.tfvars" -var-file="example_app_staging/staging.tfvars" -state="example_app_staging/staging.state"


# destroy all vms for example_app and staging environment
$ terraform destroy -var-file="../terraform.tfvars" -var-file="example_app_staging/staging.tfvars" -state="example_app_staging/staging.state"
$ terraform apply   -var-file="../terraform.tfvars" -var-file="example_app_staging/staging.tfvars" -state="example_app_staging/staging.state"


# use output ips for ansible

# following doesnt work if var and state path are passed https://github.com/hashicorp/terraform/issues/17300
$ terraform output public_ip_address -state="example_app_staging/staging.state" > ansible_inventory_file

# so instead use:
$ terraform output -state="example_app_staging/staging.state" >> ansible_inventory_file
$ sed -i "s/,//g" ansible_inventory_file
$ sed -i "s/\"//g" ansible_inventory_file

# or https://github.com/mantl/terraform.py


