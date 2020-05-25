resource "azurerm_resource_group" "example_app_stg_network" {
    name     = "example_app_stg_network"
    location = "west europe" 

}

resource "azurerm_resource_group" "example_app_stg_vm" {
    name     = "example_app_stg_vm"
    location = "west europe" 

}
