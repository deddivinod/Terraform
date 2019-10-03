#Configure Remote State
#terraform {
#  backend "azurerm" {
 # }
#}
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.34.0"

  #subscription_id = "TF_VAR_SUBSCRIPTION_ID"
  #client_id       = "TF_VAR_CLIENT_ID"
  #client_secret   = "TF_VAR_CLIENT_SECRET"
  #tenant_id       = "TF_VAR_TENANT_ID"
  subscription_id =  "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
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

