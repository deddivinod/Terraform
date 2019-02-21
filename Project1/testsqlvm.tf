resource "azurerm_resource_group" "testsqlresourcegroup" {
   name = "${var.testsqlresourcegroupname}"
   location = "${var.testvmlocation}"
   tags     = "${var.testvmtags}"
}

resource "random_string" "testsql" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}
resource "azurerm_storage_account" "sqltestdiagaccount" {
   name = "testsqlvmdiag${random_string.testsql.result}"
   resource_group_name = "${azurerm_resource_group.testsqlresourcegroup.name}"
   location = "${azurerm_resource_group.testsqlresourcegroup.location}"
   account_tier = "Standard"
   account_replication_type = "LRS"
}
data "azurerm_subnet" "testsqlsubnet" {
  name                 = "${var.testsqlsubnetname}"
  virtual_network_name = "${var.TestVnetName}"
  resource_group_name  = "${var.testVnetResourceGroup}"
  depends_on = ["azurerm_subnet.testsqlsubnet"]
}

resource "azurerm_network_interface" "testsqlvmnic" {
 name                = "${var.testsqlvmname}-NIC"
 location            = "${azurerm_resource_group.testsqlresourcegroup.location}"
 resource_group_name = "${azurerm_resource_group.testsqlresourcegroup.name}"

 ip_configuration {
   name                          = "ipConfig"
   subnet_id                     = "${data.azurerm_subnet.testsqlsubnet.id}"
   private_ip_address_allocation = "dynamic"
  
 }
}
resource "azurerm_virtual_machine" "testsqlvm" {
  name                  = "${var.testsqlvmname}"
  location              = "${azurerm_resource_group.testsqlresourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.testsqlresourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.testsqlvmnic.id}"]
  vm_size               = "${var.testsqlvmsize}"

  storage_image_reference {
   publisher = "${var.testsqlvmpublisher}"
   offer     = "${var.testsqlvmoffer}"
   sku       = "${var.testsqlvmsku}"
   version   = "latest"
 }

storage_os_disk {
  
   name              = "${var.testsqlvmname}-OSDisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "${var.testosmanageddisktype}"
 }
 storage_data_disk {
   name            = "${var.testsqlvmname}-DataDisk1"
   create_option   = "Empty"
   lun             = 1
   disk_size_gb    = 128
   managed_disk_type = "${var.testosmanageddisktype}"
 }
 storage_data_disk {
   name            = "${var.testsqlvmname}-DataDisk2"
   create_option   = "Empty"
   lun             = 2
   disk_size_gb    = 128
   managed_disk_type = "${var.testosmanageddisktype}"
 }
 os_profile {
   computer_name  = "${var.testsqlvmname}"
   admin_username = "azadmin"
   admin_password = "Password1234!!"
 }
 os_profile_windows_config {
     provision_vm_agent = true
 }
 boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.sqltestdiagaccount.primary_blob_endpoint}"
    }
 tags = "${azurerm_resource_group.testsqlresourcegroup.tags}"
   
}
resource "azurerm_virtual_machine_extension" "testsqliaasext" {
  name                 = "SqlIaasExtension"
  location             = "${azurerm_resource_group.testsqlresourcegroup.location}"
  resource_group_name  = "${azurerm_resource_group.testsqlresourcegroup.name}"
  virtual_machine_name = "${azurerm_virtual_machine.testsqlvm.name}"
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