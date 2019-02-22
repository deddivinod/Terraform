variable "prodlocation" {
  default = "West US"
}
variable "testLocation" {
  default = "West US"
}
variable "ProdVnetName" {
    default = "WUS-VNET-ProdvNet"
}
variable "TestVnetName" {
     default = "WUS-VNET-TestVnet"
}
variable "ProdVnetAddressSpace" { 
     type = "list"
     default = ["192.168.0.0/24"]
}
variable "prodwebsubnetname" {
     default = "WUS-SUB-Web-Prod"
}
variable "prodwebsubnetprefix" {
      default = "192.168.0.0/27"
}
variable "prodsqlsubnetname" {
      default = "WUS-SUB-SQL-Prod"
}
variable "prodsqlsubnetprefix" {
       default = "192.168.0.32/27"
}
variable "TestVnetAddressSpace" { 
      type = "list"
     default = ["192.168.1.0/24"]
}
variable "testwebsubnetname" {
     default = "WUS-SUB-Web-Test"
}
variable "testwebsubnetprefix" {
      default = "192.168.1.0/27"
}
variable "testsqlsubnetname" {
       default = "WUS-SUB-SQL-Test"
}
      variable "testsqlsubnetprefix" {
        default = "192.168.1.32/27"
       }
      variable "prodvNetResourceGroup" {
      default = "WUS-RG-VFA-ProdVnet"
     }
       variable "testVnetResourceGroup" {
       default = "WUS-RG-VFA-TestVnet"
      }

      variable "testtags" {
        default     = {
            environment     = "Test"
    }
      }
      variable "tags" {
        default     = {
            environment     = "Prod"
    }
}
      