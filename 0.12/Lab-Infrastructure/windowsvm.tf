resource "azurerm_resource_group" "windowsvmsrg" {
  name = var.windowsvmsresourcegroup
  location = var.location
  tags     = var.tags
}


data "azurerm_key_vault_secret" "windowslocaladminpwd" {
  name         = "windowslocaladminpwd"
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_network_interface" "studywindowsvnic" {
  count               = var.wincount
  name                = "${var.winprefix}${count.index + 1}-NIC"
  location            = azurerm_resource_group.windowsvmsrg.location
  resource_group_name = azurerm_resource_group.windowsvmsrg.name

  ip_configuration {
    name                          = "ipConfig"
    subnet_id                     = azurerm_subnet.spoke1subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_managed_disk" "studywindowsvmdisk" {
  count                = var.wincount
  name                 = "${var.winprefix}${count.index + 1}-DataDisk1"
  location             = azurerm_resource_group.windowsvmsrg.location
  resource_group_name  = azurerm_resource_group.windowsvmsrg.name
  storage_account_type = var.datadiskstorageaccounttype
  create_option        = "Empty"
  disk_size_gb         = var.datadisksize
}

resource "azurerm_virtual_machine" "studywindowsvm" {
  count                 = var.wincount
  name                  = "${var.winprefix}${count.index + 1}"
  location              = azurerm_resource_group.windowsvmsrg.location
  availability_set_id   = azurerm_availability_set.studylinuxavset.id
  resource_group_name   = azurerm_resource_group.windowsvmsrg.name
  network_interface_ids = [element(azurerm_network_interface.studywindowsvnic.*.id, count.index)]
  vm_size               = var.vmsize

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.winvmpublisher
    offer     = var.winvmoffer
    sku       = var.winvmsku
    version   = "latest"
  }

  #Create the OS disk and select index 1 from osmanageddisktype variable for standardssd_lrs
  storage_os_disk {
    name              = "${var.winprefix}${count.index + 1}OSDisk"
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
    name            = element(azurerm_managed_disk.studywindowsvmdisk.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.studywindowsvmdisk.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb = element(
      azurerm_managed_disk.studywindowsvmdisk.*.disk_size_gb,
      count.index + 1,
    )
  }

  os_profile {
    computer_name  = "${var.winprefix}${count.index + 1}"
    admin_username = var.windowsusername
    admin_password = data.azurerm_key_vault_secret.windowslocaladminpwd.value
  }

  /*
 os_profile_linux_config {
   disable_password_authentication = false
 }
 */
  os_profile_windows_config {
    provision_vm_agent = true
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.diagaccount.primary_blob_endpoint
  }
  tags = var.vmtags
}

