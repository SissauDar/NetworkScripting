
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template-ubuntu" {
  name          = var.vm_template_ubuntu
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template-windows" {
  name          = var.vm_template_windows
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vm-ubuntu" {
  # count            = var.vsphere_ubuntuservers
  count            = 1
  name             = "${element(var.list_students, count.index)}-ubu"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.template-ubuntu.guest_id

  scsi_type = data.vsphere_virtual_machine.template-ubuntu.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template-ubuntu.network_interface_types[0]
  }

  disk {
    label            = var.vm_disk
    size             = data.vsphere_virtual_machine.template-ubuntu.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template-ubuntu.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template-ubuntu.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template-ubuntu.id

    customize {
      linux_options {
        host_name = "${element(var.list_students, count.index)}-ubu"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "192.168.50.${100 + count.index}"
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway
      dns_server_list = var.dns_servers
    }
  }

 provisioner "local-exec" {
    command = "ansible-playbook playbook.yml -i inventory.txt"
  }

}

resource "vsphere_virtual_machine" "vm-windows" {
  # count            = var.vsphere_ubuntuservers
  count            = 1
  name             = "${element(var.list_students, count.index)}-win"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.template-windows.guest_id

  scsi_type = data.vsphere_virtual_machine.template-windows.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template-windows.network_interface_types[0]
  }

  disk {
    label            = var.vm_disk
    size             = data.vsphere_virtual_machine.template-windows.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template-windows.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template-windows.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template-windows.id

    customize {

      windows_options {
        computer_name  = "${element(var.list_students, count.index)}"
        admin_password = "P@ssw0rd"
      }


      network_interface {
        ipv4_address = "192.168.50.${120 + count.index}"
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway
      dns_server_list = var.dns_servers
    }

  }

}


