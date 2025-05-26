# Define the Packer plugins required
packer {
  required_version = ">=1.11.0"

  required_plugins {
    proxmox = {
      version = ">= 1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }

    windows-update = {
      version = "0.16.7"
      source  = "github.com/rgl/windows-update"
    }
  }
}

