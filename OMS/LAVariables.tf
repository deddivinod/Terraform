variable "prefix" {
  description = "Default prefix to use with your resource names."
  default     = "Automation1"
}

variable "RGName"{
  default = "RG_LogAnalyticsTest"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "WestEurope"
}

variable "omsname" {
  description = "The name of the OMS workspace"
  default     = "pmp1"
}
