#
# Provider part
#

provider "vsphere" {
  user           = var.vsphere_username
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # Skip SSL checks since self-signed
  allow_unverified_ssl = true
}

#
# Data need for deploy
#

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

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

#
#vSphere VM configuration
#

resource "vsphere_virtual_machine" "vsphere_vm" {
  count            = length(var.vsphere_vm)
  name             = lookup(var.vsphere_vm[count.index], "hostname")
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = lookup(var.vsphere_vm[count.index], "folder")

  num_cpus = lookup(var.vsphere_vm[count.index], "cpus")
  memory   = lookup(var.vsphere_vm[count.index], "memory")
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }


  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = lookup(var.vsphere_vm[count.index], "hostname")
        domain    = ""
      }

      network_interface {
        ipv4_address = lookup(var.vsphere_vm[count.index], "ip")
        ipv4_netmask = lookup(var.vsphere_vm[count.index], "netmask")
      }

    ipv4_gateway = lookup(var.vsphere_vm[count.index], "gateway")
   }
    
  }

 connection {
    type     = "ssh"
    user     = lookup(var.vsphere_vm[count.index], "username")
    password = lookup(var.vsphere_vm[count.index], "password")
    host     = lookup(var.vsphere_vm[count.index], "ip")
 }

 provisioner "remote-exec" {
   inline = [
    "sleep 60",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y"
      
    ]
 }
}
#
# Output
#

#output "ip" {
#value = vsphere_virtual_machine.vm[count.index].default_ip_address

#}
