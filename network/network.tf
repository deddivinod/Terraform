resource "azurerm_resource_group" "RG_NetworkTF" {
   name = "RG_NetworkTF"
   location = "${var.location}"
   tags     = "${var.tags}"
}
module "network" {
  source = "Azure/network/azurerm"
  resource_group_name = "${azurerm_resource_group.RG_NetworkTF.name}"
  location            = "${azurerm_resource_group.RG_NetworkTF.location}"
  vnet_name           = "TFVnet"
  address_space       = "192.168.0.0/24"
  subnet_prefixes     = ["192.168.0.0/27", "192.168.0.32/27", "192.168.0.64/27"]
  subnet_names        = ["GateWaySubnet", "dev", "training"]
  dns_servers         = ["1.1.1.1"]  
    tags              = "${azurerm_resource_group.RG_NetworkTF.tags}"  
}


