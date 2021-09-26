variable "PM_API_URL" {
  description = "the name of the resource group"
  default     = "https://proxmox-server01.example.com:8006/api2/json"
}
variable "PM_USER" {
  description = "the name of the resource group"
  type        = string
  sensitive   = true
}
variable "PM_PASS" {
  description = "the name of the resource group"
  type        = string
  sensitive   = true
}
variable "vm_name" {
  description = "Required The name of the VM within Proxmox."
  default     = "test-vm"
}
variable "vm_target_node" {
  description = "Required The name of the Proxmox Node on which to place the VM."
  default     = "gpx5"
}
variable "vm_iso" {
  description = "The name of the ISO image to mount to the VM. Only applies when clone is not set. Either clone or iso needs to be set."
  default     = ""
}
variable "vm_cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  default     = 2
}
variable "vm_sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  default     = 1
}
variable "vm_memory" {
  description = "The amount of memory to allocate to the VM in Megabytes."
  default     = 2048
}
variable "disk_size" {
  description = "Required The size of the created disk, format must match the regex d+[GMK], where G, M, and K represent Gigabytes, Megabytes, and Kilobytes respectively."
  default     = "32G"
}
variable "disk_type" {
  description = "	Required The type of disk device to add. Options: ide, sata, scsi, virtio."
  default     = "virtio"
}
variable "disk_storage" {
  description = "Required The name of the storage pool on which to store the disk."
  default     = "lvm"
}
# variable "disk_ssd" {
#   description = "Whether to expose this drive as an SSD, rather than a rotational hard disk. Values 0, 1"
#   default     = 1
# }
variable "network_model" {
  description = "Required Network Card Model. The virtio model provides the best performance with very low CPU overhead. If your guest does not support this driver, it is usually best to use e1000. Options: e1000, e1000-82540em, e1000-82544gc, e1000-82545em, i82551, i82557b, i82559er, ne2k_isa, ne2k_pci, pcnet, rtl8139, virtio, vmxnet3."
  default     = "virtio"
}
variable "network_bridge" {
  description = "Bridge to which the network device should be attached. The Proxmox VE standard bridge is called vmbr0. Default value is nat"
  default     = "vmbr0"
}
variable "network_tag" {
  description = "The VLAN tag to apply to packets on this device. -1 disables VLAN tagging."
  default     = 7
}
variable "ipconfig0_ip" {
  description = "The first IP address to assign to the guest."
  default     = "10.0.0.10/24"
}
variable "ipconfig0_gw" {
  description = "The first GW address to assign to the guest."
  default     = "10.0.0.1"
}
# variable "sshkey" {
#   description = "The VLAN tag to apply to packets on this device. -1 disables VLAN tagging."
#   default     = <<EOF
#     ssh-rsa 9182739187293817293817293871== user@pc
#     EOF
# }
