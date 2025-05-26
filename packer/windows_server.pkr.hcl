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

# Define the Proxmox source for the Windows Server template
source "proxmox-clone" "windows-server-base" {
  proxmox_url                 = "https://192.168.1.132:8006/api2/json"
  username                    = var.proxmox_username
  token                       = var.proxmox_token
  insecure_skip_tls_verify    = true

  node                        = "pve1"                     # Proxmox node
  vm_name                     = "WindowsServer"            # Temporary VM name
  vm_id                       = "30001"                    # Unique VM ID
  clone_vm                    = "WindowsServerGoldenImage" # Base Windows template
  qemu_agent                  = true                       # Enable QEMU guest agent

  # VM settings
  memory                      = "4096"                     # Memory (4GB)
  scsi_controller             = "virtio-scsi-single"       # SCSI controller type

  template_name = "WindowsServerGoldenImage-2"

  # Network configuration
#  network_adapters {
#    bridge = "vmbr0"
#    model  = "e1000"
#  }

#  disks {
#    storage_pool = "local-lvm"          
#    disk_size    = "32G"                
#    type         = "virtio"         
#    #format      = "qcow2"
#  }

  # EFI configuration
#  efi_config {
#    efi_storage_pool  = "local-lvm"
#    efi_type          = "4m"
#    pre_enrolled_keys = true
#  }

  # WinRM communicator settings
  communicator  = "winrm"
  winrm_username = "Administrator"
  winrm_password = "P@SSWORD!123"
  winrm_insecure = true
  winrm_use_ntlm = true
  winrm_timeout  = "5m"
  winrm_use_ssl  = false
  winrm_port     = 5985
}

build {
  sources = ["source.proxmox-clone.windows-server-base"]
  provisioner "shell" {
    inline = [
    "powershell -Command \"Enable-PSRemoting -Force\"",
    "powershell -Command \"Set-Item WSMan:\\localhost\\Service\\AllowUnencrypted $true\"",
    "powershell -Command \"Enable-NetFirewallRule -Name 'Windows Remote Management (HTTP-In)'\"",
    "powershell -Command \"winrm set winrm/config/service @{AllowUnencrypted='true'}\"",
    "powershell -Command \"winrm set winrm/config/service/auth @{Basic='true'}\""
    ]
  }
}
