variable "prefix" {
  description = "Default prefix to use with your resource names."
  default     = "PMP1"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "WestEurope"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet"
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."

  default = {
    "0" = "10.0.1.0/24"
    "1" = "10.0.2.0/24"
    "2" = "10.0.3.0/24"
    "3" = "10.0.4.0/24"
    "4" = "10.0.5.0/24"
  }
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."

  default = {
    "0" = "subnet1"
    "1" = "subnet2"
    "2" = "subnet3"
    "3" = "subnet4"
    "4" = "subnet5"
  }
}

variable "tags" {
  type = "map"

  default = {
    customer    = "pmp"
    environment = "live"
  }
}
