resource "azurerm_resource_group" "hubAndSpokeRG" {
   name = "${var.resourceGroupName}"
   location = "${var.location}"
   tags = "${var.tags}"
}