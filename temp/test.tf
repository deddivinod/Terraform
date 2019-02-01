
data "azurerm_key_vault_secret" "saKey" {
name = "saterraformaccountkey"
vault_uri = "https://pmpkeyvault.vault.azure.net/"
}
terraform {
    backend "azurerm"{
        resource_group_name = {}
        storage_account_name = {}
        container_name = {}
        access_key = {}
        key = {}
    }
}

resource "azurerm_resource_group" "MyResource" {
   name = "example-name3"
   location = "West Europe"
}

resource "azurerm_resource_group" "1" {
   name = "example-name4"
   location = "West US"
}

resource "azurerm_resource_group" "2" {
   name = "example-name5"
   location = "West US"
}
resource "azurerm_resource_group" "3" {
   name = "example-name6"
   location = "West US"
}