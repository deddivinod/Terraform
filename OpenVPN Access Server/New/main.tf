resource "azurerm_resource_group" "openvpnrg" {
  name = var.openvpnresourcegroupname
  location = var.location
  tags     = var.tags
}

resource "random_string" "rnd" {
  length  = 6
  lower   = false
  number  = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "diagaccount" {
  name                     = "sabootdiag${random_string.rnd.result}"
  resource_group_name      = azurerm_resource_group.openvpnrg.name
  location                 = azurerm_resource_group.openvpnrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface" "openvpnvmvnic" {
  count               = var.ubuntucount
  name                = "${var.ubuntuprefix}${count.index + 1}-NIC"
  location            = azurerm_resource_group.openvpnrg.location
  resource_group_name = azurerm_resource_group.openvpnrg.name

  ip_configuration {
    name                          = "ipConfig"
    subnet_id                     = azurerm_subnet.spoke1subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_public_ip" "openvpnpip" {
  count                        = var.ubuntucount
  name                         = "${var.ubuntuprefix}${count.index + 1}-PIP"
  location                     = "${azurerm_resource_group.openvpnrg.location}"
  resource_group_name          = "${azurerm_resource_group.openvpnrg.name}"
  allocation_method            = "Static"
  sku                          = "Standard"
}

resource "azurerm_managed_disk" "openvpnvmdisk" {
  count                = var.ubuntucount
  name                 = "${var.ubuntuprefix}${count.index + 1}-DataDisk1"
  location             = azurerm_resource_group.openvpnrg.location
  resource_group_name  = azurerm_resource_group.openvpnrg.name
  storage_account_type = var.datadiskstorageaccounttype
  create_option        = "Empty"
  disk_size_gb         = var.datadisksize
}

/*resource "azurerm_availability_set" "studylinuxavset" {
  name                         = var.avsetname
  location                     = azurerm_resource_group.openvpnrg.location
  resource_group_name          = azurerm_resource_group.openvpnrg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}
*/
resource "azurerm_virtual_machine" "openvpnvms" {
  count                 = var.ubuntucount
  name                  = "${var.ubuntuprefix}${count.index + 1}"
  location              = azurerm_resource_group.openvpnrg.location
  availability_set_id   = azurerm_availability_set.studylinuxavset.id
  resource_group_name   = azurerm_resource_group.openvpnrg.name
  network_interface_ids = [element(azurerm_network_interface.openvpnvmvnic.*.id, count.index)]
  vm_size               = var.vmsize

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.vmpublisher
    offer     = var.vmoffer
    sku       = var.vmsku
    version   = "latest"
  }

  #Create the OS disk and select index 1 from osmanageddisktype variable for standardssd_lrs
  storage_os_disk {
    name              = "${var.ubuntuprefix}${count.index + 1}OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.osmanageddisktype[1]
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
    name            = element(azurerm_managed_disk.openvpnvmdisk.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.openvpnvmdisk.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb = element(
      azurerm_managed_disk.openvpnvmdisk.*.disk_size_gb,
      count.index + 1,
    )
  }

  os_profile {
    computer_name  = "${var.ubuntuprefix}${count.index + 1}"
    admin_username = var.linuxusername
    admin_password = var.linuxpassword
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.diagaccount.primary_blob_endpoint
  }
  tags = var.vmtags
}



  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

