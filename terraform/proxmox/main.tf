terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.PM_API_URL
  pm_user         = var.PM_USER
  pm_password     = var.PM_PASS
  pm_tls_insecure = true
}


resource "proxmox_vm_qemu" "cloudinit-test" {
  name = var.vm_name


  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = var.vm_target_node

  iso = var.vm_iso
  # Requested HA state for the resource. One of "started", "stopped", "enabled", "disabled", or "ignored". See the docs about HA for more info.
  # hastate = ""

  cores   = var.vm_cores
  sockets = var.vm_sockets
  vcpus   = 0
  cpu     = "host"
  memory  = var.vm_memory
  # scsihw = "lsi"

  # If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. 
  #Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an error will be produced.)
  # force_create = false

  os_type = "ubuntu"
  # Setup the disk
  disk {
    size    = var.disk_size
    type    = var.disk_type
    storage = var.disk_storage
    # ssd     = var.disk_ssd
  }

  # Setup the network interface and assign a vlan tag: 256
  network {
    model  = var.network_model
    bridge = var.network_bridge
    tag    = var.network_tag
  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip.
  # The first IP address to assign to the guest.
  # Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>].
  ipconfig0 = "ip=${var.ipconfig0_ip},gw=${var.ipconfig0_gw}"

  # sshkeys = var.sshkey


}



# resource "proxmox_vm_qemu" "cloudinit-test" {
#     name = "terraform-test-vm"
#     desc = "A test for using terraform and cloudinit"

#     # Node name has to be the same name as within the cluster
#     # this might not include the FQDN
#     target_node = "proxmox-server02"

#     # The destination resource pool for the new VM
#     pool = "pool0"

#     # The template name to clone this vm from
#     clone = "linux-cloudinit-template"

#     # Activate QEMU agent for this VM
#     agent = 1

#     os_type = "cloud-init"
#     cores = 2
#     sockets = 1
#     vcpus = 0
#     cpu = "host"
#     memory = 2048
#     scsihw = "lsi"

#     # Setup the disk
#     disk {
#         size = 32
#         type = "virtio"
#         storage = "ceph-storage-pool"
#         storage_type = "rbd"
#         iothread = 1
#         ssd = 1
#         discard = "on"
#     }

#     # Setup the network interface and assign a vlan tag: 256
#     network {
#         model = "virtio"
#         bridge = "vmbr0"
#         tag = 256
#     }

#     # Setup the ip address using cloud-init.
#     # Keep in mind to use the CIDR notation for the ip.
#     ipconfig0 = "ip=192.168.10.20/24,gw=192.168.10.1"

#     sshkeys = <<EOF
#     ssh-rsa 9182739187293817293817293871== user@pc
#     EOF
# }



# resource "proxmox_lxc" "lxc-test" {
#     features {
#         nesting = true
#     }
#     hostname = "terraform-new-container"
#     network {
#         name = "eth0"
#         bridge = "vmbr0"
#         ip = "dhcp"
#         ip6 = "dhcp"
#     }
#     ostemplate = "shared:vztmpl/centos-7-default_20171212_amd64.tar.xz"
#     password = "rootroot"
#     pool = "terraform"
#     target_node = "node-01"
#     unprivileged = true
# }
