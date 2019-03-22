resource "azurerm_resource_group" "openvpnrg" {
   name = "${var.resourcegroup}"
   location = "${var.location}"
   tags = "${var.tags}"
}

data "azurerm_subnet" "trainingsubnet" {
  name                 = "training"
  virtual_network_name = "core"
  resource_group_name  = "core"
 # depends_on = ["azurerm_subnet.prodsqlsubnet"]
}
data "azurerm_subnet" "devsubnet" {
  name                 = "dev"
  virtual_network_name = "core"
  resource_group_name  = "core"
 # depends_on = ["azurerm_subnet.prodsqlsubnet"]
}
resource "azurerm_public_ip" "openvpnpip" {
  name                         = "pFSenseIP"
  location                     = "${azurerm_resource_group.pfSenseRG.location}"
  resource_group_name          = "${azurerm_resource_group.pfSenseRG.name}"
  allocation_method = "Static"
  sku                          = "Standard"
}

resource "azurerm_network_interface" "openvpnpublicnic" {
 name                = "pfSense-PublicNIC"
 location            = "${azurerm_resource_group.pfSenseRG.location}"
 resource_group_name = "${azurerm_resource_group.pfSenseRG.name}"

 ip_configuration {
   name                          = "ipConfig-1"
   subnet_id                     = "${data.azurerm_subnet.trainingsubnet.id}"
   public_ip_address_id = "${azurerm_public_ip.pfSensePIP.id}"
   private_ip_address_allocation = "dynamic"
  
 }
}


resource "azurerm_network_interface" "openvpnprivatenic" {
 name                = "pfSense-InternalNIC"
 location            = "${azurerm_resource_group.pfSenseRG.location}"
 resource_group_name = "${azurerm_resource_group.pfSenseRG.name}"
 

 ip_configuration {
   name                          = "ipConfig-2"
   subnet_id                     = "${data.azurerm_subnet.devsubnet.id}"
   private_ip_address_allocation = "static"
   private_ip_address = "10.0.2.4"
  
 }
}


resource "azurerm_virtual_machine" "openvpnvm" {
  name                  = "FW01"
  location              = "${azurerm_resource_group.pfSenseRG.location}"
  resource_group_name   = "${azurerm_resource_group.pfSenseRG.name}"
  network_interface_ids = ["${azurerm_network_interface.pfSensePrivateNIC.id}", "${azurerm_network_interface.pfSensePublicNIC.id}"]
  vm_size               = "Standard_B1ms"
  primary_network_interface_id = "${azurerm_network_interface.pfSensePublicNIC.id}"

  storage_image_reference {
   publisher = "openvpn"
   offer     = "openvpnas"
   sku       = "access_server_byol"
   version   = "2.6.1"
 }
 storage_os_disk {
  
   name              = "OpenVPNOSDisk"
   create_option     = "FromImage"
   managed_disk_type = "StandardSSD_LRS"
 }
 os_profile {
   computer_name  = "FW01"
   admin_username = "azadmin"
   admin_password = "YourPassWord"
 }
 plan   {
     name = "access_server_byol"
     publisher = "openvpn"
     product = "openvpnas"
 }
 os_profile_linux_config {
    disable_password_authentication = false
  }
}