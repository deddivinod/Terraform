resource "azurerm_resource_group" "loganalyticsRG" {
  name     = "${var.RGName}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

resource "azurerm_log_analytics_workspace" "LAWorkspace" {
  name                = "${var.omsname}-workspace"
  location            = "${azurerm_resource_group.loganalyticsRG.location}"
  resource_group_name = "${azurerm_resource_group.loganalyticsRG.name}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags =  "${azurerm_resource_group.loganalyticsRG.tags}"
}
resource "azurerm_automation_account" "autoaccount" {
  name                = "testautoaccount-01"
  location            = "${azurerm_resource_group.loganalyticsRG.location}"
  resource_group_name = "${azurerm_resource_group.loganalyticsRG.name}"
  tags =  "${azurerm_resource_group.loganalyticsRG.tags}"

  sku {
    name = "Basic"
  }
}
resource "azurerm_log_analytics_linked_service" "link" {
  resource_group_name = "${azurerm_resource_group.loganalyticsRG.name}"
  workspace_name      = "${azurerm_log_analytics_workspace.LAWorkspace.name}"
  resource_id         = "${azurerm_automation_account.autoaccount.id}"
}

/*resource "azurerm_log_analytics_solution" "updates" {
  solution_name         = "Updates"
  location              = "${azurerm_resource_group.loganalyticsRG.location}"
  resource_group_name   = "${azurerm_resource_group.loganalyticsRG.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.LAWorkspace.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.LAWorkspace.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
  }
  */