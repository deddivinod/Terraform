

variable "resourceGroupName" {
  description = "The resource group name"
 }
variable "location" {
  default = "West Europe"
}
  variable "hubvnetname" {
    default = "hubvnet"
   }

   variable "hubaddressspace" {
     type    = "list"
     default = ["10.10.0.0/16"]
    }

variable "azFireWallSubnetPreFix" {
  description = "The Subnet address for the AzureFirewallSubnet"
 }
 
 variable "subnet1Name" {
   description = "the name for subnet1"
  }

variable "subnet1AddressPrefix" {
  description = "the subnet1 address prefix"
 }

 variable "subnet2Name" {
   description = "the name for subnet2"
  }
  variable "subnet2AddressPrefix" {
    description = "the subnet2 address prefix"
   }

   variable "hubtospok1VnetPeerName" {
     description = "the name of the peer connection from hub to spoke1 "
    }
    variable "hubtospok2VnetPeerName" {
     description = "the name of the peer connection from hub to spoke2 "
    }

    variable "routeTableName" {
      description = "the name of the route table"
     }
     variable "routeName" {
       description = "the name of the route to send traffic to Azfirewall"
      }

    variable "gateWaySubnetPrefix" {
      description = "the address prefix for the gatewaysubnet"
     }

    variable "spoke1name" {
    default = "spoke1vnet"
}
    variable "spoke1addressspace" {
    type = "list"
    default = ["10.20.0.0/16"]  
 }
    variable "spoke1Subnet1Name" {
  description = "the name of Subnet1 in spoke1 vnet"
 }
    variable "spoke1Subnet1AddressPrefix" {
   description = "the address prefix for subnet1 in spoke1"
 }

    variable "spoke1ToHubVnetPeerName" {
    description = "the name of the peering between spoke1 vnet and hub"
 }
    variable "spoke2name" {
    default = "spoke2vnet"
 }
    variable "spoke2addressspace" {
    type = "list"
    default = ["10.30.0.0/16"]
 }
    variable "spoke2Subnet1Name" {
    description = "the name of Subnet1 in spoke1 vnet"
 }
    variable "spoke2Subnet1AddressPrefix" {
     description = "the address prefix for subnet1 in spoke1"
 }
  variable "spoke2ToHubVnetPeerName" {
    description = "the name of the peering between spoke1 vnet and hub"
   }
   variable "tags" {
        default     = {
            source  = "citadel"
            env     = "training"
    }
         }
