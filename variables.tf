variable "vsphere_server" {}

variable "vsphere_username" {}

variable "vsphere_password" {
  sensitive = "true"
}

variable "vsphere_datacenter" {}

variable "vsphere_network" {}

variable "vsphere_template" {}

variable "vsphere_cluster" {}

variable "vsphere_datastore" {}

variable "vsphere_vm" {
  type = list
  default = [ ]
}
