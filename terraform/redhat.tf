resource "proxmox_vm_qemu" "redhat_clones" {
  for_each = tomap({
    for i in range(1, var.clone_count + 1) :
    "redhat-${i}" => {
      vmid = var.templates.redhat.vmid + i
      name = "redhat-clone-${i}"
    }
  })

  vmid        = each.value.vmid
  name        = each.value.name
  target_node = "pve1"
  clone       = var.templates.redhat.name
  full_clone  = true
  bios        = "seabios"
  agent       = 1
  cores       = 1
  memory      = 2048
  vm_state    = "stopped"
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-single"
  sshkeys     = file(var.ssh_public_key)

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size      = 16
          cache     = "writeback"
          storage   = "local-lvm"
          discard   = true
          iothread  = true
        }
      }
    }
  }

  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }

  ipconfig0 = "ip=dhcp"

}

resource "null_resource" "rollback_redhat_vms" {
  count = var.restore ? var.clone_count : 0

  provisioner "remote-exec" {
    inline = [
      "qm rollback ${var.templates.redhat.vmid + count.index + 1} ${var.snapshot_name}"
    ]
    connection {
      type        = "ssh"
      host        = var.proxmox_host
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }
  }
}

