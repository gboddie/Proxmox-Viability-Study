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

source "proxmox-clone" "ubuntu-base" {
  proxmox_url   	      = "https://192.168.1.132:8006/api2/json"
  username                    = var.proxmox_username
  token                       = var.proxmox_token
  insecure_skip_tls_verify    = true

  clone_vm                    = "UbuntuGoldenImage"

  # VM Settings
  node                        = "pve1" 		# Host node
  vm_id                       = "10001"		# ID of created VM 
  vm_name                     = "Ubuntu"	# Temporary name for the VM
  qemu_agent                  = true

  # Creates an empty cloud-init drive at the end of the build before vm conversion
  cloud_init                  = true
  cloud_init_storage_pool     = "local-lvm"

  memory                      = "2048"
  scsi_controller             = "virtio-scsi-single"
 
  ssh_username                = "user1"
  ssh_private_key_file        = var.ssh_private_key_file
  ssh_port		      = 22

  template_name               = "UbuntuGoldenImage-2"

  network_adapters {
    bridge 		      = "vmbr0"
    model 	              = "virtio"
    firewall 		      = true
  } 
}

# Define the build process
build {
  sources = ["source.proxmox-clone.ubuntu-base"]

  provisioner "shell" {
    inline = [
    "while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do echo 'Waiting for lock...'; sleep 5; done",
    "sudo apt-get update",
    "sudo apt-get upgrade -y",
    "sudo apt-get install -y mysql-server",
    "sudo systemctl enable --now mysql"
  ]
}

}
