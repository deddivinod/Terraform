variable "location" {
  default = "West Europe"
}
variable "tags" {
  type = "map"

  default = {
    customer    = "pmp1"
    environment = "live"
  }
}
