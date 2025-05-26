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

source "proxmox-clone" "redhat-base" {
  # Authenticate to Proxmox Host
  proxmox_url                 = "https://192.168.1.132:8006/api2/json"
  username                    = var.proxmox_username
  token                       = var.proxmox_token
  insecure_skip_tls_verify    = true

  clone_vm                    = "RedhatGoldenImage"  # Update the template to use your Red Hat template

  # VM Settings
  node                        = "pve1"            # Host node
  vm_id                       = "20001"           # ID for the created VM
  vm_name                     = "RedHat"          # Temporary name for the VM
  qemu_agent                  = true

  # Creates an empty cloud-init drive at the end of the build before vm conversion
  cloud_init                  = true
  cloud_init_storage_pool     = "local-lvm"

  memory = "2048"
  scsi_controller = "virtio-scsi-single"

  ssh_username                = "root"            # Red Hat default root user for SSH
  ssh_private_key_file        = var.ssh_private_key_file

  template_name = "RedHatGoldenImage-2"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
}

# Define the build process
build {
  sources = ["source.proxmox-clone.redhat-base"]

  # Provisioning steps
  provisioner "shell" {
    inline = [
    "while sudo fuser /var/run/yum.pid >/dev/null 2>&1; do echo 'Waiting for yum lock...'; sleep 5; done",
    "sudo yum update -y",
    "sudo yum install -y mysql-server",
    "sudo systemctl enable --now mysqld",
    "sudo systemctl start mysqld"
  ]
}

}

