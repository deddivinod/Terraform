resource "azurerm_resource_group" "NetworkTest" {
   name = "${var.testVnetResourceGroup}"
   location = "${var.testLocation}"
   tags     = "${var.testtags}"
}


resource "azurerm_virtual_network" "testnetwork" {
  name = "${var.TestVnetName}"
  address_space = "${var.TestVnetAddressSpace}"
  location = "${azurerm_resource_group.NetworkTest.location}"
  resource_group_name = "${azurerm_resource_group.NetworkTest.name}"
  tags = "${azurerm_resource_group.NetworkTest.tags}"
}

resource "azurerm_subnet" "testwebsubnet" {
  name = "${var.testwebsubnetname}"
  resource_group_name = "${azurerm_resource_group.NetworkTest.name}"
  virtual_network_name = "${azurerm_virtual_network.testnetwork.name}"
  address_prefix = "${var.testwebsubnetprefix}"
}

resource "azurerm_subnet" "testsqlsubnet" {
  name = "${var.testsqlsubnetname}"
  resource_group_name = "${azurerm_resource_group.NetworkTest.name}"
  virtual_network_name = "${azurerm_virtual_network.testnetwork.name}"
  address_prefix = "${var.testsqlsubnetprefix}"
}