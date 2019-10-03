resource "azurerm_resource_group" "keyvaultrg" {
  name     = var.keyvaultresourcegroupname
  location = var.location

  tags = var.tags
}

//data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                            = var.keyvaultname
  location                        = azurerm_resource_group.keyvaultrg.location
  resource_group_name             = azurerm_resource_group.keyvaultrg.name
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tenant_id                       = var.tenantid

  sku_name = "standard"
  

  tags = azurerm_resource_group.keyvaultrg.tags
}

resource "azurerm_key_vault_access_policy" "paulpaccess" {
  key_vault_id          = azurerm_key_vault.keyvault.id
  tenant_id = var.tenantid
  object_id = "bb5d00ab-a75e-48db-bd90-ec3c75915609"

  key_permissions = [
    "get",
    "create",
  ]

  secret_permissions = [
    "get",
    "set",
    "delete",
    "list",
  ]
}
resource "random_string" "rndpwd" {
  length  = 16
  lower   = true
  number  = true
  upper   = true
  special = false
}

resource "azurerm_key_vault_secret" "windowslocaladminsecret" {
  name         = "windowslocaladminpwd"
  value        = random_string.rndpwd.result
  key_vault_id = azurerm_key_vault.keyvault.id
  tags         = azurerm_resource_group.keyvaultrg.tags
}

#resource "azurerm_key_vault_secret" "vpnpresharedkey" {
#  name         = "vpnpsk"
#  value        = var.vpnpsk
#  key_vault_id = azurerm_key_vault.keyvault.id
#  tags         = azurerm_resource_group.keyvaultrg.tags
#}





