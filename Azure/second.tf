# Create public IP
resource "azurerm_public_ip" "myterraformpublicip-01" {
    name                         = "terraPublicIp-01"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic-01" {
    name                      = "terraNIC-01"
    location                  = "westeurope"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "terraNICConfig-01"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip-01.id
    }

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example-01" {
    network_interface_id      = azurerm_network_interface.myterraformnic-01.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm-01" {
    depends_on = [azurerm_network_interface.myterraformnic-00, azurerm_network_interface.myterraformnic-01, azurerm_lb.Loadbalancer, azurerm_lb_backend_address_pool.LB_backend, azurerm_network_interface_backend_address_pool_association.address_pool_association-00, azurerm_network_interface_backend_address_pool_association.address_pool_association-01, azurerm_lb_rule.rule, azurerm_lb_probe.probe,  azurerm_public_ip.pubIPLB]
    name                  = "webserver-01"
    location              = "westeurope"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    availability_set_id   = azurerm_availability_set.avset.id
    network_interface_ids = [azurerm_network_interface.myterraformnic-01.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "Disk-01"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "webserver-01"
    admin_username = "dar"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "dar"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Dar Sissau Terraform"
    }
    provisioner "remote-exec" {

        inline = [
            "sudo apt update",
            "sudo apt install nginx -y",
            "sudo sed -i 's/to nginx/to webserver-01/g' /var/www/html/index.nginx-debian.html"
        ]
        connection {
            type        = "ssh"
            host        = azurerm_linux_virtual_machine.myterraformvm-01.public_ip_address
            user        = "dar"
            #private_key = "${file("terrakey.pem")}"
            private_key = tls_private_key.example_ssh.private_key_pem
        }
    }
  }
