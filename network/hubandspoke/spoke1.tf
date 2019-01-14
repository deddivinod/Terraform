resource "azurerm_virtual_network" "spoke1" {
  name = "${var.spoke1name}"
  location = "${var.location}"
  address_space = "${var.spoke1addressspace}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  tags = "${azurerm_resource_group.hubAndSpokeRG.tags}"
}

resource "azurerm_subnet" "spoke1subnet" {
  name = "${var.spoke1Subnet1Name}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name = "${azurerm_virtual_network.spoke1.name}"
  address_prefix = "${var.spoke1Subnet1AddressPrefix}"
} 

resource "azurerm_subnet_route_table_association" "spoke1rtassoc" {
  subnet_id      = "${azurerm_subnet.spoke1subnet.id}"
  route_table_id = "${azurerm_route_table.spokert.id}"
}

resource "azurerm_virtual_network_peering" "spoke1tohub" {
  name                      = "${var.spoke1ToHubVnetPeerName}"
  resource_group_name       = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.spoke1.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.hub.id}"
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  allow_forwarded_traffic      = true
} 
