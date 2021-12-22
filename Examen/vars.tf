variable "vm_hostname" {
  default = "webserver"
}

variable "vm_hostname_lb" {
  default = "balancer"
}

variable "ubuntu_password" {
  type = string
  sensitive = true
}

variable "vsphere_user" {
  description = "Please put in your username: "
  type    = string
  sensitive = true
}

variable "vsphere_ubuntuservers" {
  description = "How many ubuntu vm's do you want: "
  type    = string
  sensitive = true
  default = 1
}

variable "vsphere_password" {
  description = "Please put in your password: "
  type    = string
  sensitive = true
}

variable "vsphere_server" {
  description = "Please put in your vsphere_server: "
  type    = string
  default = "192.168.50.10"
  sensitive = true
}

variable "vsphere_datacenter" {
  default = "StudentDatacenter"
}

variable "list_students" {
  description = "List of students"
  type    = list
  default = ["dar", "esli"]

}

variable "vsphere_datastore" {
  default = "sissau-dar"
}

variable "vsphere_cluster" {
  default = "StudentCluster"
}

variable "vsphere_network" {
  default = "VM Network"
}

variable "firmware_efi" {
  default = "efi"
}

variable "vm_template_ubuntu" {
  default = "ubuntu-template-examen"
}
variable "vm_template_windows" {
  default = "win-template"
}


variable "vm_disk" {
  default = "disk0"
}

variable "vm_domain" {
  default = "lab.local"
}

variable "dns_servers" {
  default = ["192.168.40.1"]
}

variable "gateway" {
  default = "192.168.50.1"
}

# ssh connection

variable "connection_type_ssh" {
  default = "ssh"
}

variable "connection_user" {
  default = "student"
}

