
variable "subID" {
    description = "the subscription ID"
 }

 variable "clientID" {
     description = "the client ID"
  }

  variable "clientSecret" {
      description = "the client secret"
   }

   variable "tenantID" {
       description = "the tenant ID"
    }
variable "prefix" {
    default = "VM"
}

variable "location" {
    type = "list"
    default = []
}

variable "resourcegroupname" {
  description = "The name of the resource group"
}

variable "existingsubnetname" {
    description = "the subnet you want the vm to connect to"
 }

 variable "existingvnetname" {
     description = "the name of the vnet the vm should be on"
  }

  variable "vnetresourcegroup" {
      description = "the resource group that holds the vnet"
   }

   variable "count" {
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
             default = []
         }

         variable "tags" {
        default     = {
            source  = "citadel"
            env     = "training"
    }
         }

