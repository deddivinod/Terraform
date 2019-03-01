
resource "azurerm_lb" "prodsqllb" {
  name                = "WUSProdSQLLB"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.prodsqlresourcegroup.name}"

  frontend_ip_configuration {
      name = "WUSprodSQLLBIP"
      subnet_id = "${data.azurerm_subnet.sqlsubnet.id}"
      private_ip_address = "192.168.0.40"
      private_ip_address_allocation = "static"
  }
}

resource "azurerm_lb_rule"  "sqlprodlbrule"{
    resource_group_name = "${azurerm_resource_group.prodsqlresourcegroup.name}"
    loadbalancer_id    =  "${azurerm_lb.prodsqllb.id}"
    name = "SQLAlwaysonRule"
    protocol = "TCP"
    frontend_port = "1433"
    backend_port = "1433"
    frontend_ip_configuration_name = "WUSprodSQLLBIP"
    enable_floating_ip = "true"
}

resource "azurerm_lb_probe" "prodsqllbprobe" {
    resource_group_name =  "${azurerm_resource_group.prodsqlresourcegroup.name}"
    loadbalancer_id = "${azurerm_lb.prodsqllb.id}"
    name = "SQLAlwaysOnEndPointProbe"
    port = "59999"
    protocol = "TCP"
    interval_in_seconds = "5"
    number_of_probes = "2"
}

resource "azurerm_lb_backend_address_pool" "prodsqlbackendpool" {
    resource_group_name = "${azurerm_resource_group.prodsqlresourcegroup.name}"
    loadbalancer_id = "${azurerm_lb.prodsqllb.id}"
    name = "ProdSQLBackEndPool"
}
