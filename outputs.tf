# value references module.modulename.variable_name_from_outputs.tf ( from .terraform/modules/linuxservers/Azure-terraform-azurerm-compute-80cab6f/outputs.tf )

output "private_ip_address" {
  description = "private ip addresses of the vm nics"
  value       = module.linuxservers.network_interface_private_ip
}

output "public_ip_address" {
  value = "${module.linuxservers.public_ip_address}"
}

