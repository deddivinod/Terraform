variable "prodsqlresourcegroupname" {
    default = "WUS-RG-Prod-SQL"
 }
variable "prodvmlocation" {
     default = "West US"
 }
variable "prodwebresourcegroupname" {
      default = "WUS-RG-WEb-Prod"
 }
variable "webvmname" {
       default = "WUSVFAWebprod01"
 }
variable "sqlvmname" {
       default = "WUSVFASQlProd01"
 }
variable "webvmsize" {
       default = "Standard_B2ms"
 }
variable "sqlvmsize" {
       default = "Standard_DS3_v2"
 }
variable "vmpublisher" {
        default = "MicrosoftWindowsServer"
 }
variable "vmoffer" {
        default = "WindowsServer"
 }
variable "webvmsku" {
        default = "2016-DataCenter"
 }
variable "sqlvmsku" {
        default = "Enterprise"
 }
variable "sqlvmpublisher" { 
         default = "MicrosoftSQLServer"
 }
variable "sqlvmoffer" {
         default = "SQL2016SP2-WS2016"
 }
variable "osmanageddisktype" {
         default = "Premium_LRS"
 }

 
variable "prodvmtags" {
        default     = {
            environment     = "Prod"
 }
}