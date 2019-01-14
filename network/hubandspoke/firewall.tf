
resource "azurerm_public_ip" "test" {
  name                         = "testpip"
  location                     = "${azurerm_resource_group.hubAndSpokeRG.location}"
  resource_group_name          = "${azurerm_resource_group.hubAndSpokeRG.name}"
  public_ip_address_allocation = "Static"
  sku                          = "Standard"
}
resource "azurerm_firewall" "azfirewall" {
    name    = "azfirewall"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.hubAndSpokeRG.name}"

    ip_configuration {
        name    = "configuration"
        subnet_id = "${azurerm_subnet.AzureFirewallSubnet.id}"
        internal_public_ip_address_id = "${azurerm_public_ip.test.id}"
    }

  
}
