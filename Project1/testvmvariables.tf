variable "testsqlresourcegroupname" {
    default = "WUS-RG-Test-SQL"
}
variable "testvmlocation" {
    default = "West US"
}

variable "testwebresourcegroupname" {
    default = "WUS-RG-Test-Web"
}
variable "testwebvmname" {
    default = "WUSVFAWebTest01"
}
variable "testsqlvmname" {
    default = "WUSVFASQlTest01"
}
variable "testwebvmsize" {
    default = "Standard_B2ms"
}
variable "testsqlvmsize" {
    default = "Standard_DS3_v2"
}
variable "testvmpublisher" {
    default = "MicrosoftWindowsServer"
}
variable "testvmoffer" {
    default = "WindowsServer"
       }
variable "testwebvmsku" {
     default = "2016-DataCenter"
        }
variable "testsqlvmsku" {
    default = "Enterprise"
         }
variable "testsqlvmpublisher" { 
    default = "MicrosoftSQLServer"
         }
variable "testsqlvmoffer" {
    default = "SQL2016SP2-WS2016"
          }
variable "testosmanageddisktype" {
    default = "Premium_LRS"
         } 
variable "testvmtags" {
     default     = {
            environment     = "Test"
    }
}