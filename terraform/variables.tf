variable "templates" {
  default = {
    ubuntu          = { vmid = 1000, name = "UbuntuTemplate" }
    redhat          = { vmid = 2000, name = "RedhatTemplate" }
    windows_server  = { vmid = 3000, name = "WindowsServerTemplate" }
    windows11	    = { vmid = 4000, name = "Windows11Template"}
  }
}

variable "clone_count" {
  type = number
  default = 1
}

variable "proxmox_api_url" {
  description = "The Proxmox API URL"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "The Proxmox API token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "The Proxmox API token secret"
  type        = string
}

variable "proxmox_host" {
  description = "IP address of the Proxmox host."
  type        = string
  default     = "192.168.1.132"
}

variable "ssh_user" {
  description = "SSH username for Proxmox host."
  type        = string
  default     = "root"
}

variable "ssh_private_key" {
  description = "Path to the SSH private key for authentication."
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "snapshot_name" {
  description = "Snapshot name to restore from. Leave empty if not restoring."
  type = string
  default = ""
}

variable "restore" {
  description = "Determines if I want to restore vms from a snapshot. Set to true to restore."
  type = bool
  default = false
}

variable "ssh_password" {
  description = "temporary password to ssh to newly created VMs"
  type = string
  default = "PASSWORD!"
}

variable "mysql_root_password" {
  description = "sql root password on each host"
  type = string
  default = "P@SSWORD!"
}
