resource "azurerm_resource_group" "recoveryvaultrg" {
  name     = var.recoveryvaultrgname
  location = var.location
}

resource "azurerm_recovery_services_vault" "recoveryvault" {
  name                = var.recoveryvaultname
  location            = azurerm_resource_group.recoveryvaultrg.location
  resource_group_name = azurerm_resource_group.recoveryvaultrg.name
  sku                 = "Standard"
}

resource "random_string" "rndforasr" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "asraccount" {
  name                     = "asrstorage${random_string.rndforasr.result}"
  resource_group_name      = azurerm_resource_group.recoveryvaultrg.name
  location                 = azurerm_resource_group.recoveryvaultrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

