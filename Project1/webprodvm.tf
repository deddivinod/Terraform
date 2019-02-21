resource "azurerm_resource_group" "prodwebresourcegroup" {
   name = "${var.prodwebresourcegroupname}"
   location = "${var.prodvmlocation}"
   tags     = "${var.prodvmtags}"
}

resource "random_string" "web" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}
resource "azurerm_storage_account" "webproddiagaccount" {
   name = "webvmsabootdiag${random_string.web.result}"
   resource_group_name = "${azurerm_resource_group.prodwebresourcegroup.name}"
   location = "${azurerm_resource_group.prodwebresourcegroup.location}"
   account_tier = "Standard"
   account_replication_type = "LRS"
}
data "azurerm_subnet" "websubnet" {
  name                 = "${var.prodwebsubnetname}"
  virtual_network_name = "${var.ProdVnetName}"
  resource_group_name  = "${var.prodvNetResourceGroup}"
  depends_on = ["azurerm_subnet.prodwebsubnet"]
}

resource "azurerm_network_interface" "webvmnic" {
 name                = "${var.webvmname}-NIC"
 location            = "${azurerm_resource_group.prodwebresourcegroup.location}"
 resource_group_name = "${azurerm_resource_group.prodwebresourcegroup.name}"
 

 ip_configuration {
   name                          = "ipConfig"
   subnet_id                     = "${data.azurerm_subnet.websubnet.id}"
   private_ip_address_allocation = "dynamic"
  
 }
}
resource "azurerm_virtual_machine" "webvm" {
  name                  = "${var.webvmname}"
  location              = "${azurerm_resource_group.prodwebresourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.prodwebresourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.webvmnic.id}"]
  vm_size               = "${var.webvmsize}"

  storage_image_reference {
   publisher = "${var.vmpublisher}"
   offer     = "${var.vmoffer}"
   sku       = "${var.webvmsku}"
   version   = "latest"
 }

storage_os_disk {
  
   name              = "${var.webvmname}-OSDisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "${var.osmanageddisktype}"
 }
 storage_data_disk {
   name            = "${var.webvmname}-DataDisk1"
   create_option   = "Empty"
   lun             = 1
   disk_size_gb    = 32
   managed_disk_type = "${var.osmanageddisktype}"
 }
 os_profile {
   computer_name  = "${var.webvmname}"
   admin_username = "azadmin"
   admin_password = "Password1234!!"
 }
 os_profile_windows_config {
     provision_vm_agent = true
 }
 boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.webproddiagaccount.primary_blob_endpoint}"
    }
 tags = "${azurerm_resource_group.prodwebresourcegroup.tags}"
   
}