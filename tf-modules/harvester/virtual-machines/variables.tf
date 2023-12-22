variable "create_os_image" {
  description = "Harvester's VMs Image"
  default     = true
}

variable "os_image_name" {
  description = "Harvester's VMs OS Image name"
  default     = "ubuntu22"
}

variable "os_image" {
  description = "Harvester's VMs OS Image display name"
  default     = "ubuntu-22.04-server-cloudimg-amd64"
}

variable "os_image_url" {
  description = "Harvester's VMs OS Image URL"
  default     = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "create_secondary_network" {
  description = "Harvester's Network"
  default     = true
}

variable "cluster_network_name" {
  description = "Harvester's Secondary Cluster Network name"
  default     = "secondary"
}

variable "vlan_uplink_nic" {
  description = "Harvester's VLAN Uplink NIC"
  default     = "enp1s0f1"
}

variable "prefix" {
  description = "The prefix used in front of all Equnix resources"
}

variable "vm_count" {
  description = "The number of instances"
  default     = 3
}

variable "vm_namespace" {
  description = "VMs namespace"
  default     = "default"
}

variable "description" {
  description = "VMs description"
  default     = "Created using Terraform"
}

variable "ssh_username" {
  description = "Username used for SSH login"
  default     = "ubuntu"
}

variable "ssh_password" {
  description = "Password used for SSH login"
  default     = null
}

variable "cpu" {
  description = "VMs CPU"
  default     = 8
}

variable "memory" {
  description = "VMs Memory, specified in GB"
  default     = 16
}

variable "vm_disk_size" {
  description = "Size of the root disk attached to each VMs, specified in GB"
  default     = 50
}

variable "vm_data_disk_size" {
  description = "Size of the data disk attached to each VMs, specified in GB"
  default     = 10
}

variable "startup_script" {
  description = "Custom startup script"
  default     = null
}

variable "network_config_script" {
  description = "Custom network startup script - Necessary to configure 2 NICs for example"
  default     = null
}
