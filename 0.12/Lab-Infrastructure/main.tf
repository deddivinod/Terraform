#Configure Remote State
#terraform {
#  backend "azurerm" {
 # }
#}

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

