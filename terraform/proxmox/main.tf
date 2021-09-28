terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.7.4"
    }
  }
  # required_version = ">= 0.14"
}

provider "proxmox" {
  pm_api_url      = var.proxmox_host["pm_api_url"]
  pm_user         = var.proxmox_host["pm_user"]
  pm_password     = var.proxmox_host["pm_password"]
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "prox-vm" {
  count       = length(var.hostnames)
  name        = var.hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  full_clone  = true
  clone       = "cloud-init-focal"

  cores    = 2
  sockets  = 1
  memory   = 2048
  balloon  = 2048
  boot     = "c"
  bootdisk = "virtio0"

  scsihw = "virtio-scsi-pci"

  onboot  = true
  agent   = 1
  cpu     = "kvm64"
  numa    = true
  hotplug = "network,disk,cpu,memory"

  network {
    bridge = "vmbr0"
    model  = "e1000"
    # the vlan tag
    # tag    = 8
  }
  ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"

  disk {
    #id = 0
    type    = "virtio"
    storage = "local-lvm"
    size    = "20G"
  }

  os_type = "cloud-init"
  # uncomment and add your keys if you didn't add it in the cloud init template 
  # sshkeys = file(var.ssh_keys["pub"])


  # uncomment all of the following and configure if you want to run ansible playbooks inside terraform
  #creates ssh connection to check when the vm is ready for ansible provisioning
  # connection {
  #   host        = var.ips[count.index]
  #   user        = var.user
  #   private_key = file(var.ssh_keys["priv"])
  #   # host_key    = file(var.ssh_keys["pub"])
  #   agent   = false
  #   timeout = "30s"
  # }

  # provisioner "remote-exec" {
  #   # Leave this here so we know when to start with Ansible local-exec 
  #   inline = ["echo 'Cool, we are ready for provisioning'"]
  # }

  # provisioner "local-exec" {
  #   working_dir = "../../ansible/"
  #   command     = "ansible-playbook -u ${var.user} -e 'ansible_python_interpreter=/usr/bin/python3' --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, provision.yaml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../../ansible/"
  #   command     = "ansible-playbook -u ${var.user} -e 'ansible_python_interpreter=/usr/bin/python3' --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, install-qemu-guest-agent.yaml"
  # }
}


