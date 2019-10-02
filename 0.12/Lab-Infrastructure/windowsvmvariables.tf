variable "winprefix" {
  default = "WinVM"
}

variable "wincount" {
  description = "the number of VMs required"
  default     = 2
}

variable "winvmpublisher" {
  description = "the VM publisher"
}

variable "winvmoffer" {
  description = "the vm offer type, e.g. WindowsServer"
}

variable "winvmsku" {
  description = "the vm sku to use e.g. windows 2016 datacenter"
}

variable "vmtags" {
  type = map(string)

  default = {
    customer    = "Lab"
    environment = "Prod"
  }
}

variable "windowsusername" {
}

