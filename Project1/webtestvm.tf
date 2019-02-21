resource "azurerm_resource_group" "testwebresourcegroup" {
   name = "${var.testwebresourcegroupname}"
   location = "${var.testvmlocation}"
   tags     = "${var.testvmtags}"
}

resource "random_string" "testweb" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}
resource "azurerm_storage_account" "webtestdiagaccount" {
   name = "testwebvmadiag${random_string.web.result}"
   resource_group_name = "${azurerm_resource_group.testwebresourcegroup.name}"
   location = "${azurerm_resource_group.testwebresourcegroup.location}"
   account_tier = "Standard"
   account_replication_type = "LRS"
}
data "azurerm_subnet" "testwebsubnet" {
  name                 = "${var.testwebsubnetname}"
  virtual_network_name = "${var.TestVnetName}"
  resource_group_name  = "${var.testVnetResourceGroup}"
  depends_on = ["azurerm_subnet.testwebsubnet"]
}

resource "azurerm_network_interface" "testwebvmnic" {
 name                = "${var.testwebvmname}-NIC"
 location            = "${azurerm_resource_group.testwebresourcegroup.location}"
 resource_group_name = "${azurerm_resource_group.testwebresourcegroup.name}"

 ip_configuration {
   name                          = "ipConfig"
   subnet_id                     = "${data.azurerm_subnet.testwebsubnet.id}"
   private_ip_address_allocation = "dynamic"
  
 }
}
resource "azurerm_virtual_machine" "testwebvm" {
  name                  = "${var.testwebvmname}"
  location              = "${azurerm_resource_group.testwebresourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.testwebresourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.testwebvmnic.id}"]
  vm_size               = "${var.testwebvmsize}"

  storage_image_reference {
   publisher = "${var.testvmpublisher}"
   offer     = "${var.testvmoffer}"
   sku       = "${var.testwebvmsku}"
   version   = "latest"
 }

storage_os_disk {
  
   name              = "${var.testwebvmname}-OSDisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "${var.testosmanageddisktype}"
 }
 storage_data_disk {
   name            = "${var.testwebvmname}-DataDisk1"
   create_option   = "Empty"
   lun             = 1
   disk_size_gb    = 32
   managed_disk_type = "${var.testosmanageddisktype}"
 }
 os_profile {
   computer_name  = "${var.testwebvmname}"
   admin_username = "azadmin"
   admin_password = "Password1234!!"
 }
 os_profile_windows_config {
     provision_vm_agent = true
 }
 boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.webtestdiagaccount.primary_blob_endpoint}"
    }
 tags = "${azurerm_resource_group.testwebresourcegroup.tags}"
   
}