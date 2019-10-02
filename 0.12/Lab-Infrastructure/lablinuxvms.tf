resource "azurerm_resource_group" "linuxstudyvmsrg" {
  name = var.studyvmsresourcegroupname

  
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
  resource_group_name      = azurerm_resource_group.linuxstudyvmsrg.name
  location                 = azurerm_resource_group.linuxstudyvmsrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface" "studylinuxubuntumvnic" {
  count               = var.ubuntucount
  name                = "${var.ubuntuprefix}${count.index + 1}-NIC"
  location            = azurerm_resource_group.linuxstudyvmsrg.location
  resource_group_name = azurerm_resource_group.linuxstudyvmsrg.name

  ip_configuration {
    name                          = "ipConfig"
    subnet_id                     = azurerm_subnet.spoke1subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "studylinuxcentosmvnic" {
  count               = var.centoscount
  name                = "${var.centosprefix}${count.index + 1}-NIC"
  location            = azurerm_resource_group.linuxstudyvmsrg.location
  resource_group_name = azurerm_resource_group.linuxstudyvmsrg.name

  ip_configuration {
    name                          = "ipConfig"
    subnet_id                     = azurerm_subnet.spoke1subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_managed_disk" "studylinuxubuntuvmdisk" {
  count                = var.ubuntucount
  name                 = "${var.ubuntuprefix}${count.index + 1}-DataDisk1"
  location             = azurerm_resource_group.linuxstudyvmsrg.location
  resource_group_name  = azurerm_resource_group.linuxstudyvmsrg.name
  storage_account_type = var.datadiskstorageaccounttype
  create_option        = "Empty"
  disk_size_gb         = var.datadisksize
}

resource "azurerm_managed_disk" "studylinuxcentosvmdisk" {
  count                = var.centoscount
  name                 = "${var.centosprefix}${count.index + 1}-DataDisk1"
  location             = azurerm_resource_group.linuxstudyvmsrg.location
  resource_group_name  = azurerm_resource_group.linuxstudyvmsrg.name
  storage_account_type = var.datadiskstorageaccounttype
  create_option        = "Empty"
  disk_size_gb         = var.datadisksize
}

resource "azurerm_availability_set" "studylinuxavset" {
  name                         = var.avsetname
  location                     = azurerm_resource_group.linuxstudyvmsrg.location
  resource_group_name          = azurerm_resource_group.linuxstudyvmsrg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "studyubuntuvm" {
  count                 = var.ubuntucount
  name                  = "${var.ubuntuprefix}${count.index + 1}"
  location              = azurerm_resource_group.linuxstudyvmsrg.location
  availability_set_id   = azurerm_availability_set.studylinuxavset.id
  resource_group_name   = azurerm_resource_group.linuxstudyvmsrg.name
  network_interface_ids = [element(azurerm_network_interface.studylinuxubuntumvnic.*.id, count.index)]
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
    name            = element(azurerm_managed_disk.studylinuxubuntuvmdisk.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.studylinuxubuntuvmdisk.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb = element(
      azurerm_managed_disk.studylinuxubuntuvmdisk.*.disk_size_gb,
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

resource "azurerm_virtual_machine" "studycentosvm" {
  count               = var.centoscount
  name                = "${var.centosprefix}${count.index + 1}"
  location            = azurerm_resource_group.linuxstudyvmsrg.location
  availability_set_id = azurerm_availability_set.studylinuxavset.id
  resource_group_name = azurerm_resource_group.linuxstudyvmsrg.name
  network_interface_ids = [element(
    azurerm_network_interface.studylinuxcentosmvnic.*.id,
    count.index,
  )]
  vm_size = var.vmsize

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.centosvmpublisher
    offer     = var.centosvmoffer
    sku       = var.centosvmsku
    version   = "latest"
  }

  #Create the OS disk and select index 1 from osmanageddisktype variable for standardssd_lrs
  storage_os_disk {
    name              = "${var.centosprefix}${count.index + 1}OSDisk"
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
    name = element(
      azurerm_managed_disk.studylinuxcentosvmdisk.*.name,
      count.index,
    )
    managed_disk_id = element(
      azurerm_managed_disk.studylinuxcentosvmdisk.*.id,
      count.index,
    )
    create_option = "Attach"
    lun           = 1
    disk_size_gb = element(
      azurerm_managed_disk.studylinuxcentosvmdisk.*.disk_size_gb,
      count.index + 1,
    )
  }

  os_profile {
    computer_name  = "${var.centosprefix}${count.index + 1}"
    admin_username = var.linuxusername
    admin_password = var.linuxpassword
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  /*os_profile_windows_config {
     provision_vm_agent = true
 }
 */
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.diagaccount.primary_blob_endpoint
  }
  tags = var.vmtags
}

