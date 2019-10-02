resource "azurerm_log_analytics_workspace" "laworkspace" {
  name                = "${var.laname}-workspace"
  location            = azurerm_resource_group.loganalyticsrg.location
  resource_group_name = azurerm_resource_group.loganalyticsrg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = azurerm_resource_group.loganalyticsrg.tags
}

resource "azurerm_automation_account" "autoaccount" {
  name                = var.autoaccountname
  location            = azurerm_resource_group.loganalyticsrg.location
  resource_group_name = azurerm_resource_group.loganalyticsrg.name
  tags                = azurerm_resource_group.loganalyticsrg.tags

  sku_name = "Basic" 
  
}

resource "azurerm_log_analytics_linked_service" "link" {
  resource_group_name = azurerm_resource_group.loganalyticsrg.name
  workspace_name      = azurerm_log_analytics_workspace.laworkspace.name
  resource_id         = azurerm_automation_account.autoaccount.id
}

resource "azurerm_log_analytics_solution" "updates" {
  solution_name         = "Updates"
  location              = azurerm_resource_group.loganalyticsrg.location
  resource_group_name   = azurerm_resource_group.loganalyticsrg.name
  workspace_resource_id = azurerm_log_analytics_workspace.laworkspace.id
  workspace_name        = azurerm_log_analytics_workspace.laworkspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}

resource "azurerm_log_analytics_solution" "security" {
  solution_name         = "Security"
  location              = azurerm_resource_group.loganalyticsrg.location
  resource_group_name   = azurerm_resource_group.loganalyticsrg.name
  workspace_resource_id = azurerm_log_analytics_workspace.laworkspace.id
  workspace_name        = azurerm_log_analytics_workspace.laworkspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Security"
  }
}

resource "azurerm_security_center_workspace" "example" {
  scope        = var.seccenterscope
  workspace_id = azurerm_log_analytics_workspace.laworkspace.id
}

resource "azurerm_security_center_subscription_pricing" "seccenterstandard" {
  tier = "Standard"
}

resource "azurerm_security_center_contact" "seccentercontact" {
  email               = "ppaginton@gmail.com"
  phone               = "+1-555-555-5555"
  alert_notifications = true
  alerts_to_admins    = false
}

