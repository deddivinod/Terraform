#Configure Remote State
#terraform {
#  backend "azurerm" {
 # }
#}
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.34.0"

  subscription_id = "var.subscriptionID"
  client_id       = "var.clientID"
  client_secret   = "var.client_secret"
  tenant_id       = "var.tenant_ID"
}
resource "azurerm_resource_group" "networkrg" {
  name     = var.networkresourcegroupname
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "loganalyticsrg" {
  name     = var.loganalyticsresourcgroupname
  location = var.location
  tags     = var.tags
}

