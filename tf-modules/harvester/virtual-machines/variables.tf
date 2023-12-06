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

variable "cpu" {
  description = "VMs CPU"
  default     = 2
}

variable "memory" {
  description = "VMs Memory, specified in GB"
  default     = 8
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
