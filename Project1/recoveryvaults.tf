resource "azurerm_resource_group" "prodregionvaultrg" {
   name = "WUS-RG-VFA-BKUP"
   location = "West US"
}

resource "azurerm_recovery_services_vault" "prodregionvault" {
  name                = "WUS-VFA-Vault"
  location            = "${azurerm_resource_group.prodregionvaultrg.location}"
  resource_group_name = "${azurerm_resource_group.prodregionvaultrg.name}"
  sku                 = "Standard"
}
/*
resource "azurerm_recovery_services_protection_policy_vm" "prodpolicy" {
  name                = "VisualFactoryProd"
  resource_group_name = "${azurerm_resource_group.prodregionvaultrg.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.prodregionvault.name}"

  timezone = "UTC"

  backup = {
    frequency = "Daily"
    time      = "02:00"
  }

  retention_daily = {
    count = 7
  }

  retention_weekly = {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly = {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = [ "Last"]
  }
  resource "azurerm_recovery_services_protection_policy_vm" "testpolicy" {
  name                = "VisualFactoryTest"
  resource_group_name = "${azurerm_resource_group.prodregionvaultrg.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.prodregionvault.name}"

  timezone = "UTC"

  backup = {
    frequency = "Daily"
    time      = "02:00"
  }

  retention_daily = {
    count = 7
  }

  retention_weekly = {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly = {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = [ "Last"]
  }
  }


  resource "azurerm_recovery_services_protected_vm" "prodwebvm" {
  resource_group_name = "${azurerm_resource_group.prodregionvaultrg.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.prodregionvault.name}"
  source_vm_id        = "${azurerm_virtual_machine.webvm.id}"
  backup_policy_id    = "${azurerm_recovery_services_protection_policy_vm.prodpolicy.id}"
  */
  


