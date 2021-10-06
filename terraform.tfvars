vsphere_server = "fqdn-or-ip-vcenter"
vsphere_username = "administrator@vsphere.local"
vsphere_password = "password"
vsphere_datacenter = "vmware-datacenter"
vsphere_network = "dvport"
vsphere_template = "ubuntu2004"
vsphere_cluster = "vmware-cluster"
vsphere_datastore = "datastore"

vsphere_vm = [
          {
            hostname = "vm1"
            username = "ubuntu"
            password = "template-pw"
            cpus = "2"
            memory = "4096"
            ip = "192.168.40.216"
            netmask = "24"
            gateway = "192.168.40.1"
            folder = "folder1"
          },
          {
            hostname = "vm2"
            username = "ubuntu"
            password = "template-pw"
            cpus = "2"
            memory = "4096"
            ip = "192.168.40.217"
            netmask = "24"
            gateway = "192.168.40.1"
            folder = "folder2"
          }
]
