variable "proxmox_host" {
  type = map(any)
  default = {
    # replace proxmox-server01 with your cluster master hostname or ip
    pm_api_url  = "https://proxmox-server01:8006/api2/json"
    pm_user     = "root@pam"
    pm_password = ""
    target_node = "pve"
  }
}

variable "hostnames" {
  description = "VMs to be created"
  type        = list(string)
  default     = ["prod-vm", "staging-vm", "dev-vm"]
}

variable "ips" {
  description = "IPs of the VMs, respective to the hostname order"
  type        = list(string)
  default     = ["10.0.42.80", "10.0.42.81", "10.0.42.82"]
}

variable "ssh_keys" {
  type = map(any)
  default = {
    pub  = "~/.ssh/id_rsa.pub"
    priv = "~/.ssh/id_rsa"
  }
}

variable "user" {
  default     = "ubuntu"
  description = "User used to SSH into the machine and provision it"
}
