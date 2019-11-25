variable "ubuntuprefix" {
  default = "VM"
}

variable "location" {
    default = "West Europe"
}
variable "openvpnresourcegroupname" {
  description = "The name of the resource group"
  default = "RG-TestOPENVPN"
}
variable "tags" {
    type = "map"

    default = {
        Environment = "Terraform GS"
        Dept = "Engineering"
  }
}

variable "ubuntucount" {
  description = "the number of VMs required"
  default     = 2
}

variable "datadiskstorageaccounttype" {
  description = "the type of storage account"
  default = "Standard_LRS"
}

variable "datadisksize" {
  description = "the size of the data disk in GB"
  default = "20"
}

variable "avsetname" {
  description = "the name of the availablity set"
  default = "av1"
}

variable "vmsize" {
  description = "the VM size"
  default = "Standard_B2s"
}

variable "vmpublisher" {
  description = "the VM publisher"
  default = "Canonical"
}

variable "vmoffer" {
  description = "the vm offer type, e.g. WindowsServer"
  default = "UbuntuServer"
}

variable "vmsku" {
  description = "the vm sku to use e.g. windows 2016 datacenter"
  default = "18.04-LTS"
}

variable "osmanageddisktype" {
  description = "the type of managed disk"
  default     = "StandardSSD_LRS"
}

variable "linuxusername" {
  default = "azadmin"
}

variable "linuxpassword" {
  default = "Password1234!!"
}