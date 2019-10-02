/*resource "azurerm_public_ip" "fwpip" {
  name                         = "fwpip"
  location                     = "${azurerm_resource_group.networkrg.location}"
  resource_group_name          = "${azurerm_resource_group.networkrg.name}"
  public_ip_address_allocation = "Static"
  sku                          = "Standard"
  tags = "${azurerm_resource_group.networkrg.tags}"
}

resource "azurerm_firewall" "azfirewall" {
    name    = "azfirewall"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.networkrg.name}"
    tags = "${azurerm_resource_group.networkrg.tags}"

    #ip_configuration {
     #   name    = "configuration"
      #  subnet_id = "${azurerm_subnet.AzureFirewallSubnet.id}"
       # internal_public_ip_address_id = "${azurerm_public_ip.fwpip.id}"
    }
    */
#}
