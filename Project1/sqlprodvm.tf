resource "azurerm_resource_group" "prodsqlresourcegroup" {
   name = "${var.prodsqlresourcegroupname}"
   location = "${var.prodvmlocation}"
   tags     = "${var.prodvmtags}"
}

resource "random_string" "sql" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}
resource "azurerm_storage_account" "sqlproddiagaccount" {
   name = "sqlvmsabootdiag${random_string.sql.result}"
   resource_group_name = "${azurerm_resource_group.prodsqlresourcegroup.name}"
   location = "${azurerm_resource_group.prodsqlresourcegroup.location}"
   account_tier = "Standard"
   account_replication_type = "LRS"
}
data "azurerm_subnet" "sqlsubnet" {
  name                 = "${var.prodsqlsubnetname}"
  virtual_network_name = "${var.ProdVnetName}"
  resource_group_name  = "${var.prodvNetResourceGroup}"
}

resource "azurerm_network_interface" "sqlvmnic" {
 name                = "${var.sqlvmname}-NIC"
 location            = "${azurerm_resource_group.prodsqlresourcegroup.location}"
 resource_group_name = "${azurerm_resource_group.prodsqlresourcegroup.name}"

 ip_configuration {
   name                          = "ipConfig"
   subnet_id                     = "${data.azurerm_subnet.sqlsubnet.id}"
   private_ip_address_allocation = "dynamic"
  
 }
}
resource "azurerm_virtual_machine" "sqlvm" {
  name                  = "${var.sqlvmname}"
  location              = "${azurerm_resource_group.prodsqlresourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.prodsqlresourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.sqlvmnic.id}"]
  vm_size               = "${var.sqlvmsize}"

  storage_image_reference {
   publisher = "${var.sqlvmpublisher}"
   offer     = "${var.sqlvmoffer}"
   sku       = "${var.sqlvmsku}"
   version   = "latest"
 }

storage_os_disk {
  
   name              = "${var.sqlvmname}-OSDisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "${var.osmanageddisktype}"
 }
 storage_data_disk {
   name            = "${var.sqlvmname}-DataDisk1"
   create_option   = "Empty"
   lun             = 1
   disk_size_gb    = 128
   managed_disk_type = "${var.osmanageddisktype}"
 }
 storage_data_disk {
   name            = "${var.sqlvmname}-DataDisk2"
   create_option   = "Empty"
   lun             = 2
   disk_size_gb    = 128
   managed_disk_type = "${var.osmanageddisktype}"
 }
 os_profile {
   computer_name  = "${var.sqlvmname}"
   admin_username = "azadmin"
   admin_password = "Password1234!!"
 }
 os_profile_windows_config {
     provision_vm_agent = true
 }
 boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.sqlproddiagaccount.primary_blob_endpoint}"
    }
 tags = "${azurerm_resource_group.prodsqlresourcegroup.tags}"
   
}
resource "azurerm_virtual_machine_extension" "sqliaasext" {
  name                 = "SqlIaasExtension"
  location             = "${azurerm_resource_group.prodsqlresourcegroup.location}"
  resource_group_name  = "${azurerm_resource_group.prodsqlresourcegroup.name}"
  virtual_machine_name = "${azurerm_virtual_machine.sqlvm.name}"
  publisher            = "Microsoft.SqlServer.Management"
  type                 = "SqlIaaSAgent"
  type_handler_version = "1.2"

  settings = <<SETTINGS
  {
    "AutoTelemetrySettings": {
      "Region": "westus"
    },
    "AutoPatchingSettings": {
      "PatchCategory": "WindowsMandatoryUpdates",
      "Enable": true,
      "DayOfWeek": "Sunday",
      "MaintenanceWindowStartingHour": "2",
      "MaintenanceWindowDuration": "60"
    },
    "KeyVaultCredentialSettings": {
      "Enable": false,
      "CredentialName": ""
    },
    "ServerConfigurationsManagementSettings": {
      "SQLConnectivityUpdateSettings": {
          "ConnectivityType": "Private",
          "Port": "1433"
      },
      "SQLWorkloadTypeUpdateSettings": {
          "SQLWorkloadType": "GENERAL"
      },
      "AdditionalFeaturesServerConfigurations": {
          "IsRServicesEnabled": "false"
      }
    }
  }
SETTINGS
}