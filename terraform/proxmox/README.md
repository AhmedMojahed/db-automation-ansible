# Proxmox IAC provisioning

## Prerequisit

Before Provisioning on any node on your proxmox cluster you need to create cloud init template

on every target node you need to do the following steps:

1. `apt install cloud-init`
2. Create a template VM (in this case Ubuntu 20.04):

```
wget http://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
export VM_ID="9000"
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --sockets 1 --cores 2 --vcpu 2  -hotplug network,disk,cpu,memory --agent 1 --name cloud-init-focal --ostype l26
qm importdisk $VM_ID focal-server-cloudimg-amd64.img local-lvm
qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-$VM_ID-disk-0
qm set $VM_ID --ide2 local-lvm:cloudinit
qm set $VM_ID --boot c --bootdisk virtio0
qm set $VM_ID --serial0 socket
qm template $VM_ID
rm focal-server-cloudimg-amd64.img
```

## Modifications

You need to modify the files to fit you setup

In [variables.tf](./variables.tf) file you need to chane `all` the attributes

In [main.tf](./main.tf) file you may need to change some attributes

```
resource "proxmox_vm_qemu" "prepprovision-test" {
    ...
    cores    = 2
    sockets  = 1
    memory   = 2048
    balloon  = 2048
    ...
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

    # uncomment and add your keys if you didn't add it in the cloud init template
    # sshkeys = file(var.ssh_keys["pub"])
    # or
    # sshkeys = <<EOF
    # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIM... key
    # EOF

}
```
## Usage
` terraform init `
` terraform apply -auto-approve `
### Note: the apply stage takes around 11 min to finish
for destroying the infra 
 ` terraform destroy `
