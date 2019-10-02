resource "azurerm_virtual_network" "spoke2" {
  name                = var.spoke2name
  location            = var.location
  address_space       = var.spoke2addressspace
  resource_group_name = azurerm_resource_group.networkrg.name
  tags                = azurerm_resource_group.networkrg.tags
}

resource "azurerm_subnet" "spoke2subnet" {
  name                 = var.spoke2Subnet1Name
  resource_group_name  = azurerm_resource_group.networkrg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefix       = var.spoke2Subnet1AddressPrefix
  /* route_table_id = "${azurerm_route_table.spokert.id}" */
}

/*
resource "azurerm_subnet_route_table_association" "spoke2rtassoc" {
  subnet_id      = "${azurerm_subnet.spoke2subnet.id}"
  route_table_id = "${azurerm_route_table.spokert.id}"
}
*/

resource "azurerm_virtual_network_peering" "spoke2tohub" {
  name                         = var.spoke2ToHubVnetPeerName
  resource_group_name          = azurerm_resource_group.networkrg.name
  virtual_network_name         = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  allow_forwarded_traffic      = false
}

