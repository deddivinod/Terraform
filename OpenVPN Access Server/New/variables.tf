variable "ubuntuprefix" {
  default = "VM"
}

variable "location" {
    default = "UK South"
}
variable "openvpnresourcegroupname" {
  description = "The name of the resource group"
}
variable "tags" {
  type = map(string)

  default = {
    customer    = "Lab"
    environment = "Prod"
  }
}
variable "ubuntucount" {
  description = "the number of VMs required"
  default     = 2
}

variable "datadiskstorageaccounttype" {
  description = "the type of storage account"
}

variable "datadisksize" {
  description = "the size of the data disk in GB"
}

variable "avsetname" {
  description = "the name of the availablity set"
}

variable "vmsize" {
  description = "the VM size"
}

variable "vmpublisher" {
  description = "the VM publisher"
}

variable "vmoffer" {
  description = "the vm offer type, e.g. WindowsServer"
}

variable "vmsku" {
  description = "the vm sku to use e.g. windows 2016 datacenter"
}

variable "osmanageddisktype" {
  description = "the type of managed disk"
  default     = []
}

variable "linuxusername" {
}

variable "linuxpassword" {
}