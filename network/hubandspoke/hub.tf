resource "azurerm_virtual_network" "hub" {
  name = "${var.hubvnetname}"
  address_space = "${var.hubaddressspace}"
  location = "${azurerm_resource_group.hubAndSpokeRG.location}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  tags = "${azurerm_resource_group.hubAndSpokeRG.tags}"
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name = "AzureFirewallSubnet"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
  address_prefix = "${var.azFireWallSubnetPreFix}"
}

resource "azurerm_subnet" "Subnet1" {
  name = "${var.subnet1Name}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
  address_prefix = "${var.subnet1AddressPrefix}"
}

resource "azurerm_subnet" "Subnet2" {
  name = "${var.subnet2Name}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
  address_prefix = "${var.subnet2AddressPrefix}"
}

resource "azurerm_virtual_network_peering" "hubtospoke1" {
  name                      = "${var.hubtospok1VnetPeerName}"
  resource_group_name       = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.hub.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.spoke1.id}"
  allow_virtual_network_access = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "hubtospoke2" {
  name                      = "${var.hubtospok2VnetPeerName}"
  resource_group_name       = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.hub.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.spoke2.id}"
  allow_virtual_network_access = true
  allow_gateway_transit        = false
}

# Generic Route table for hauling traffice back to the hub
 resource "azurerm_route_table" "spokert" {
  name = "${var.routeTableName}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
}

resource "azurerm_route" "spokertroute1" {
  name = "${var.routeName}"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  route_table_name = "${azurerm_route_table.spokert.name}"

  address_prefix = "0.0.0.0/0"
  next_hop_type = "VirtualAppliance"
  next_hop_in_ip_address = "${azurerm_firewall.azfirewall.ip_configuration.0.private_ip_address}"
}

 resource "azurerm_subnet" "gatewaysubnet" {
  name = "GatewaySubnet"
  resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
  address_prefix = "${var.gateWaySubnetPrefix}" 
 }
 
