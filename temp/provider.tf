variable "subscription_ID" {}
variable "Client_ID"       {} 
variable "client_Secret"   {}
variable "tenant_ID"       {}
  



provider "azurerm" {
    subscription_id = "${var.subscription_ID}"
    client_id       = "${var.Client_ID}"
    client_secret   = "${var.client_Secret}"
    tenant_id       = "${var.tenant_ID}"
  
}