# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "AzureTest"
    location = "westeurope"

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "terraVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "terraSubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip-00" {
    name                         = "terraPublicIp-00"
    location                     = "westeurope"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "terraNSG"
    location            = "westeurope"
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic-00" {
    name                      = "terraNIC-00"
    location                  = "westeurope"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "terraNICConfig-00"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip-00.id
    }

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example-00" {
    network_interface_id      = azurerm_network_interface.myterraformnic-00.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "tfstgacc"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    location                    = "westeurope"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Dar Sissau Terraform"
    }
}

# Create (and save) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" {
    value = tls_private_key.example_ssh.private_key_pem
    sensitive = true
}

resource "local_file" "private_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = "terrakey.pem"
  file_permission = "0600"
}

resource "azurerm_availability_set" "avset" {
   name                         = "avset"
   location                     = azurerm_resource_group.myterraformgroup.location
   resource_group_name          = azurerm_resource_group.myterraformgroup.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm-00" {
    depends_on = [azurerm_lb.Loadbalancer, azurerm_lb_backend_address_pool.LB_backend, azurerm_network_interface_backend_address_pool_association.address_pool_association-00, azurerm_network_interface_backend_address_pool_association.address_pool_association-01, azurerm_lb_rule.rule, azurerm_lb_probe.probe, azurerm_public_ip.pubIPLB]
    name                  = "webserver-00"
    location              = "westeurope"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    availability_set_id   = azurerm_availability_set.avset.id
    network_interface_ids = [azurerm_network_interface.myterraformnic-00.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "Disk-00"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "webserver-00"
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
            "sudo sed -i 's/to nginx/to webserver-00/g' /var/www/html/index.nginx-debian.html"
        ]
        connection {
            type        = "ssh"
            host        = azurerm_linux_virtual_machine.myterraformvm-00.public_ip_address
            user        = "dar"
            #private_key = "${file("terrakey.pem")}"
            private_key = tls_private_key.example_ssh.private_key_pem
        }
    }
  }
