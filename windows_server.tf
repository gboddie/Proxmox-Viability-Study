resource "proxmox_vm_qemu" "windows_server_clone" {
  for_each = tomap({
    for i in range(1, var.clone_count + 1) :
    "windows-${i}" => {
      vmid = var.templates.windows_server.vmid + i
      name = "windows-server-clone-${i}"
    }
  })

  vmid        = each.value.vmid
  name        = each.value.name
  target_node = "pve1"
  clone       = var.templates.windows_server.name
  full_clone  = true
  bios        = "ovmf"
  agent       = 1
  cores       = 2
  sockets     = 1
  memory      = 4096
  machine     = "pc-q35-9.0"
  vm_state    = "stopped"
  scsihw      = "virtio-scsi-single"
  os_type     = "cloud-init"
  sshkeys     = file(var.ssh_public_key)

  disks {
    virtio {
      virtio0 {
        disk {
          size      = 32
          cache     = "writeback"
          storage   = "local-lvm"
          iothread  = true
        }
      }
    }
  }

  network {
    id        = 0
    model     = "e1000"
    bridge    = "vmbr0"
    firewall  = true
  }

  efidisk {
    storage = "local-lvm"
    efitype = "4m"
  }

  ipconfig0 = "ip=dhcp"
}

resource "null_resource" "rollback_windows_server_vms" {
  count = var.restore ? var.clone_count : 0

  provisioner "remote-exec" {
    inline = [
      "qm rollback ${var.templates.windows_server.vmid + count.index + 1} ${var.snapshot_name}"
    ]
    connection {
      type        = "ssh"
      host        = var.proxmox_host
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }
  }
}

