provider "azurerm" {
  subscription_id = "${var.subID}"
  client_id       = "${var.clientID}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantID}"
}
resource "azurerm_resource_group" "test" {
 name     = "${var.resourcegroupname}"
 location = "${var.location}"
 tags     = "${var.tags}"
}

resource "random_string" "rnd" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}
resource "azurerm_storage_account" "diagaccount" {
   name = "sabootdiag${random_string.rnd.result}"
   resource_group_name = "${azurerm_resource_group.test.name}"
   location = "${azurerm_resource_group.test.location}"
   account_tier = "Standard"
   account_replication_type = "LRS"
}

#refer to an existing subnet
data "azurerm_subnet" "test" {
  name                 = "${var.existingsubnetname}"
  virtual_network_name = "${var.existingvnetname}"
  resource_group_name  = "${var.vnetresourcegroup}"
}

resource "azurerm_network_interface" "test" {
 count               = "${var.count}"
 name                = "${var.prefix}${count.index + 1}-NIC"
 location            = "${azurerm_resource_group.test.location}"
 resource_group_name = "${azurerm_resource_group.test.name}"

 ip_configuration {
   name                          = "ipConfig"
   subnet_id                     = "${data.azurerm_subnet.test.id}"
   private_ip_address_allocation = "dynamic"
  
 }
}

resource "azurerm_managed_disk" "test" {
 count                = "${var.count}"
 name                 = "${var.prefix}${count.index + 1}-DataDisk1"
 location             = "${azurerm_resource_group.test.location}"
 resource_group_name  = "${azurerm_resource_group.test.name}"
 storage_account_type = "${var.datadiskstorageaccounttype}"
 create_option        = "Empty"
 disk_size_gb         = "${var.datadisksize}"
}

resource "azurerm_availability_set" "avset" {
 name                         = "${var.avsetname}"
 location                     = "${azurerm_resource_group.test.location}"
 resource_group_name          = "${azurerm_resource_group.test.name}"
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}

resource "azurerm_virtual_machine" "test" {
 count                 = "${var.count}"
 name                  = "${var.prefix}${count.index + 1}"
 location              = "${azurerm_resource_group.test.location}"
 availability_set_id   = "${azurerm_availability_set.avset.id}"
 resource_group_name   = "${azurerm_resource_group.test.name}"
 network_interface_ids = ["${element(azurerm_network_interface.test.*.id, count.index)}"]
 vm_size               = "${var.vmsize}"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

 storage_image_reference {
   publisher = "${var.vmpublisher}"
   offer     = "${var.vmoffer}"
   sku       = "${var.vmsku}"
   version   = "latest"
 }

 storage_os_disk {
  
   name              = "${var.prefix}${count.index + 1}OSDisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "${var.osmanageddisktype}"
 }

 # Optional data disks
 /*storage_data_disk {
   name              = "${var.prefix}-DataDisk${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "1023"
 }*/

 storage_data_disk {
   name            = "${element(azurerm_managed_disk.test.*.name, count.index)}"
   managed_disk_id = "${element(azurerm_managed_disk.test.*.id, count.index)}"
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = "${element(azurerm_managed_disk.test.*.disk_size_gb, count.index + 1)}"
 }

 os_profile {
   computer_name  = "${var.prefix}${count.index + 1}"
   admin_username = "testadmin"
   admin_password = "Password1234!"
 }

 /*os_profile_linux_config {
   disable_password_authentication = false
 }*/
 os_profile_windows_config {
     provision_vm_agent = true
 }
  boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.diagaccount.primary_blob_endpoint}"
    }
 tags = "${azurerm_resource_group.test.tags}"
   
}