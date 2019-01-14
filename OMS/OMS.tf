resource "azurerm_resource_group" "test" {
  name     = "RG_${var.prefix}"
  location = "${var.location}"
}

resource "azurerm_log_analytics_workspace" "test" {
  name                = "${var.omsname}-workspace"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
