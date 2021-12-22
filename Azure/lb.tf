resource "azurerm_public_ip" "pubIPLB" {
  name                = "IPLB"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "Loadbalancer" {
  name                = "LoadBalancer"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  frontend_ip_configuration {
    name                 = "PubIP"
    public_ip_address_id = azurerm_public_ip.pubIPLB.id
  }
}

resource "azurerm_lb_backend_address_pool" "LB_backend" {
  loadbalancer_id = azurerm_lb.Loadbalancer.id
  name            = "LB_backend"
}

resource "azurerm_network_interface_backend_address_pool_association" "address_pool_association-00" {
  depends_on = [azurerm_network_interface.myterraformnic-00]
  backend_address_pool_id = azurerm_lb_backend_address_pool.LB_backend.id
  ip_configuration_name   = "terraNICConfig-00"
  network_interface_id    = azurerm_network_interface.myterraformnic-00.id
}

resource "azurerm_network_interface_backend_address_pool_association" "address_pool_association-01" {
  depends_on = [azurerm_network_interface.myterraformnic-01, azurerm_network_interface_backend_address_pool_association.address_pool_association-00]
  backend_address_pool_id = azurerm_lb_backend_address_pool.LB_backend.id
  ip_configuration_name   = "terraNICConfig-01"
  network_interface_id    = azurerm_network_interface.myterraformnic-01.id
}

resource "azurerm_lb_rule" "rule" {
  resource_group_name            = azurerm_resource_group.myterraformgroup.name
  loadbalancer_id                = azurerm_lb.Loadbalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PubIP"
  backend_address_pool_id       = azurerm_lb_backend_address_pool.LB_backend.id
  probe_id                       = azurerm_lb_probe.probe.id
}

resource "azurerm_lb_probe" "probe" {
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  loadbalancer_id     = azurerm_lb.Loadbalancer.id
  name                = "http-running-probe"
  port                = 80
  protocol            = "HTTP"
  request_path = "/"
}
