variable "prefix" {
  description = "Default prefix to use with your resource names."
  default     = "Automation1"
}

variable "RGName"{
  default = "RG_LogAnalytics"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "NorthEurope"
}

variable "omsname" {
  description = "The name of the OMS workspace"
  default     = "pmplab"
}
 variable "tags" {
        default     = {
            source  = "pmp"
            env     = "lab"
    }
         }
