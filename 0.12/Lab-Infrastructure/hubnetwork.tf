resource "azurerm_virtual_network" "hub" {
  name                = var.hubvnetname
  address_space       = var.hubaddressspace
  location            = azurerm_resource_group.networkrg.location
  resource_group_name = azurerm_resource_group.networkrg.name
  tags                = azurerm_resource_group.networkrg.tags
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.networkrg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefix       = var.azFireWallSubnetPreFix
}

resource "azurerm_subnet" "Subnet1" {
  name                 = var.subnet1Name
  resource_group_name  = azurerm_resource_group.networkrg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefix       = var.subnet1AddressPrefix
}

resource "azurerm_subnet" "Subnet2" {
  name                 = var.subnet2Name
  resource_group_name  = azurerm_resource_group.networkrg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefix       = var.subnet2AddressPrefix
}

resource "azurerm_subnet" "BastionSubnet" {
  name                 = var.BastionSubnetName
  resource_group_name  = azurerm_resource_group.networkrg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefix       = var.BastionSubnetAddressPrefix
}

resource "azurerm_virtual_network_peering" "hubtospoke1" {
  name                         = var.hubtospok1VnetPeerName
  resource_group_name          = azurerm_resource_group.networkrg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke1.id
  allow_virtual_network_access = true
  allow_gateway_transit        = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hubtospoke2" {
  name                         = var.hubtospok2VnetPeerName
  resource_group_name          = azurerm_resource_group.networkrg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke2.id
  allow_virtual_network_access = true
  allow_gateway_transit        = false
}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.networkrg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefix       = var.gateWaySubnetPrefix
}

# Generic Route table for hauling traffice back to the hub

#resource "azurerm_route_table" "spokert" {
#name = "${var.routeTableName}"
#location = "${var.location}"
#resource_group_name = "${azurerm_resource_group.networkrg.name}"
#}

#resource "azurerm_route" "spokertroute1" {
# name = "${var.routeName}"
#resource_group_name = "${azurerm_resource_group.networkrg.name}"
#route_table_name = "${azurerm_route_table.spokert.name}"

#address_prefix = "0.0.0.0/0"
#next_hop_type = "VirtualAppliance"
#next_hop_in_ip_address = "${azurerm_firewall.azfirewall.ip_configuration.0.private_ip_address}"
#}
/*
resource "azurerm_public_ip" "vpngwpip" {
  name                = var.vpngwpipname
  location            = azurerm_resource_group.networkrg.location
  resource_group_name = azurerm_resource_group.networkrg.name
  tags                = azurerm_resource_group.networkrg.tags

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vpngwname
  location            = azurerm_resource_group.networkrg.location
  resource_group_name = azurerm_resource_group.networkrg.name
  tags                = azurerm_resource_group.networkrg.tags

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngwpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
  }
}

resource "azurerm_local_network_gateway" "localnethome" {
  name                = var.localnetname
  resource_group_name = azurerm_resource_group.networkrg.name
  location            = azurerm_resource_group.networkrg.location
  gateway_address     = var.localgwaddress
  address_space       = var.localaddressspace
  tags                = azurerm_resource_group.networkrg.tags
}

resource "azurerm_virtual_network_gateway_connection" "onpremises" {
  name                = "onpremiseconnection"
  location            = azurerm_resource_group.networkrg.location
  resource_group_name = azurerm_resource_group.networkrg.name
  tags                = azurerm_resource_group.networkrg.tags

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.localnethome.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  */
#}

