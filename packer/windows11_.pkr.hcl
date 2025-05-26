variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_token" {
  description = "Proxmox API token"
  type        = string
}

variable "ssh_private_key_file" {
  description = "Path to the SSH private key file"
  type        = string
}

source "proxmox-clone" "windows11" {
  # Authenticate to Proxmox Host
  proxmox_url                 = "https://192.168.1.132:8006/api2/json"
  username                    = var.proxmox_username
  token                       = var.proxmox_token
  insecure_skip_tls_verify    = true

  clone_vm                    = "Windows11GoldenImage"

  # VM Settings
  node                        = "pve1"          	# Host node
  vm_id                       = "40001"           	# ID of created VM
  vm_name                     = "Windows-Server-Test" 	# Temporary name for the VM
  memory                      = 4096
  scsi_controller             = "virtio-scsi-single"
  
  template_name = "Windows11GoldenImage-2"  

  network_adapters {
    bridge = "vmbr0"
    model  = "e1000"
  }
}
