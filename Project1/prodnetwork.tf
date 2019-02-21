resource "azurerm_resource_group" "NetworkProd" {
   name = "${var.prodvNetResourceGroup}"
   location = "${var.prodlocation}"
   tags     = "${var.tags}"
}


resource "azurerm_virtual_network" "prodnetwork" {
  name = "${var.ProdVnetName}"
  address_space = "${var.ProdVnetAddressSpace}"
  location = "${azurerm_resource_group.NetworkProd.location}"
  resource_group_name = "${azurerm_resource_group.NetworkProd.name}"
  tags = "${azurerm_resource_group.NetworkProd.tags}"
}

resource "azurerm_subnet" "prodwebsubnet" {
  name = "${var.prodwebsubnetname}"
  resource_group_name = "${azurerm_resource_group.NetworkProd.name}"
  virtual_network_name = "${azurerm_virtual_network.prodnetwork.name}"
  address_prefix = "${var.prodwebsubnetprefix}"
}

resource "azurerm_subnet" "prodsqlsubnet" {
  name = "${var.prodsqlsubnetname}"
  resource_group_name = "${azurerm_resource_group.NetworkProd.name}"
  virtual_network_name = "${azurerm_virtual_network.prodnetwork.name}"
  address_prefix = "${var.prodsqlsubnetprefix}"
}